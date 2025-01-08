import 'package:flutter/material.dart';
import 'package:nthmusicmp3/services/song_service.dart';
import '../constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/song.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../providers/spotify_provider.dart';
import '../services/spotify_service.dart';
import 'dart:math';
import '../mixins/timer_mixin.dart';
import 'playlist/add_to_playlist_bottom_sheet.dart';
import '../services/play_history_service.dart';
import '../providers/auth_provider.dart';

enum PlayMode {
  none,        // Phát một lần rồi dừng
  sequential,  // Phát lần lượt
  shuffle,     // Phát ngẫu nhiên
  repeatOne    // Lặp lại một bài
}

class NowPlayingScreen extends StatefulWidget {
  final Song song;
  final List<Song> playlist;
  final int currentIndex;
  
  const NowPlayingScreen({
    super.key,
    required this.song,
    required this.playlist,
    required this.currentIndex,
  });

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> 
    with SingleTickerProviderStateMixin, TimerMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late PageController _pageController;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool isPlaying = false;
  bool isFavorite = false;
  double currentSliderValue = 0;
  PlayMode _playMode = PlayMode.none;
  
  late AnimationController _rotationController;
  late Song _currentSong;
  late SpotifyService _spotifyService;
  bool _initialized = false;
  late List<Song> _playlist;
  late int _currentIndex;
  final PlayHistoryService _playHistoryService = PlayHistoryService();
  Timer? _sleepTimer;
  int? _sleepMinutes;

  int _songsPlayedCount = 0;
  bool _isPlayingAds = false;
  final AudioPlayer _adsPlayer = AudioPlayer();
  
  @override
  void initState() {
    super.initState();
    _playlist = widget.playlist;
    _currentIndex = widget.currentIndex;
    _currentSong = _playlist[_currentIndex];
    _pageController = PageController(initialPage: 1);
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    addController(_rotationController);

    _setupAudioPlayer();
    _checkFavoriteStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _spotifyService =
        Provider.of<SpotifyProvider>(context, listen: false).spotifyService;

    if (!_initialized) {
      _initializeAudio();
      _loadLyrics();
      _initialized = true;
    }
  }

  Future<void> _loadLyrics() async {
    // Delay một chút để đảm bảo nhạc đã bắt đầu phát
    await Future.delayed(Duration(seconds: 1));
    
    if (mounted) {
      final spotifyService = Provider.of<SpotifyProvider>(context, listen: false).spotifyService;
      try {
        final updatedSong = await spotifyService.loadSongDetails(_currentSong);
        if (mounted) {
          setState(() {
            _currentSong = updatedSong;
          });
        }
      } catch (e) {
        print('Error loading lyrics: $e');
        // Không throw lỗi vì lyrics không quan trọng bằng việc phát nhạc
      }
    }
  }

  // Khởi tạo AudioPlayer và phát bài hát
  Future<void> _initializeAudio() async {
    try {
      // Dừng bài đang phát
      await _spotifyService.pauseTrack();
      await Future.delayed(Duration(milliseconds: 500));

      print(
          'Playing song: ${_currentSong.title} with ID: ${_currentSong.spotifyId}');
      await _spotifyService.playSpotifyTrack(_currentSong.spotifyId);

      setState(() {
        isPlaying = true;
        _position = Duration.zero;
        currentSliderValue = 0;
        _duration = Duration(seconds: _currentSong.duration);
        _rotationController.repeat();
      });
    } catch (e) {
      print('Error initializing audio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể phát bài hát này: ${e.toString()}')),
      );
    }
  }

  // Thiết lập AudioPlayer
  void _setupAudioPlayer() {
    createPeriodicTimer(const Duration(milliseconds: 500), (timer) {
      if (!mounted || !isPlaying) return;

      final newPosition = _position + const Duration(milliseconds: 500);
      if (newPosition >= _duration) {
        _spotifyService.pauseTrack();
        if (mounted) {
          setState(() {
            isPlaying = false;
            _rotationController.stop();
          });
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              _handleSongEnd();
            }
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _position = newPosition;
            currentSliderValue = _position.inSeconds.toDouble();
          });
        }
      }
    });

    _duration = Duration(seconds: _currentSong.duration);
  }

  // Xử lý khi bài hát kết thúc
  void _handleSongEnd() async {
    if (_isPlayingAds) {
      return; // Không xử lý khi đang phát quảng cáo
    }

    // Tăng số bài đã phát
    _songsPlayedCount++;
    
    // Kiểm tra điều kiện phát quảng cáo
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final needsAds = !authProvider.isAuthenticated || 
                    (authProvider.currentUser?.role?.id == 2);
                    
    if (needsAds && _songsPlayedCount >= 2 && !_isPlayingAds) {
      // Phát quảng cáo
      await _playAds();
      return;
    }

    // Logic phát nhạc hiện tại
    switch (_playMode) {
      case PlayMode.none:
        setState(() {
          isPlaying = false;
          _rotationController.stop();
        });
        break;

      case PlayMode.sequential:
        if (_currentIndex < _playlist.length - 1) {
          _currentIndex++;
          setState(() {
            _currentSong = _playlist[_currentIndex];
          });
          await Future.delayed(Duration(milliseconds: 500));
          await _initializeAudio();
        }
        break;

      case PlayMode.shuffle:
        final random = Random();
        _currentIndex = random.nextInt(_playlist.length);
        setState(() {
          _currentSong = _playlist[_currentIndex];
        });
        await Future.delayed(Duration(milliseconds: 500));
        await _initializeAudio();
        break;
      
      case PlayMode.repeatOne:
        setState(() {
          _position = Duration.zero;
          currentSliderValue = 0;
        });
        await Future.delayed(Duration(milliseconds: 500));
        await _initializeAudio();
        break;
    }
  }

  Future<void> _playAds() async {
    // Lưu bài hát hiện tại để phát lại sau khi quảng cáo kết thúc
    final previousSong = _currentSong;
    final previousIndex = _currentIndex;
    
    setState(() {
      _isPlayingAds = true;
      isPlaying = true;
      _currentSong = _createAdsSong();
      _position = Duration.zero;
      _duration = Duration(seconds: _currentSong.duration);
      currentSliderValue = 0;
    });

    try {
      await _stopPlayback();
      await _adsPlayer.setAsset('assets/mp3ads/ads.mp3');
      await _adsPlayer.play();
      
      _adsPlayer.positionStream.listen((position) {
        if (mounted && _isPlayingAds) {
          setState(() {
            _position = position;
            currentSliderValue = position.inSeconds.toDouble();
          });
        }
      });
      
      await _adsPlayer.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed
      );
      
      _songsPlayedCount = 0;
      _isPlayingAds = false;

      // Chuyển sang bài tiếp theo thay vì phát lại bài cũ
      if (_currentIndex < _playlist.length - 1) {
        _currentIndex = previousIndex + 1;
      } else {
        _currentIndex = 0; // Quay lại bài đầu tiên nếu đã hết playlist
      }
      
      setState(() {
        _currentSong = _playlist[_currentIndex];
        _position = Duration.zero;
        _duration = Duration(seconds: _currentSong.duration);
        currentSliderValue = 0;
      });
      
      await _initializeAudio();
    } catch (e) {
      print('Error playing ads: $e');
      _isPlayingAds = false;
      setState(() {
        _currentSong = previousSong;
        _currentIndex = previousIndex;
      });
      await _initializeAudio();
    }
  }
  
  @override
  void dispose() {
    _sleepTimer?.cancel();
    _pageController.dispose();
    _audioPlayer.dispose();
    _adsPlayer.dispose();
    _stopPlayback();
    super.dispose();
  }

  // Dừng phát nhạc
  Future<void> _stopPlayback() async {
    if (isPlaying) {
      try {
        await _spotifyService.pauseTrack();
        // Đợi một chút để đảm bảo lệnh pause được thực hiện
        await Future.delayed(Duration(milliseconds: 300));
      } catch (e) {
        print('Error stopping playback: $e');
      }
    }
  }

  // Xây dựng hình ảnh album quay
  Widget _buildRotatingAlbumArt() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationController.value * 2 * 3.14159,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple.withOpacity(0.8),
                  Colors.blue.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                ),
                ClipOval(
                  child: _currentSong.imageUrl != null &&
                          _currentSong.imageUrl!.isNotEmpty
                      ? Image.network(
                          _currentSong.imageUrl!,
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 180,
                          height: 180,
                          color: Colors.white,
                          child: const Icon(
                            Icons.music_note,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                  child: _currentSong.id == 'ads'
                      ? Container(
                          width: 180,
                          height: 180,
                          color: Colors.green,
                          child: const Icon(
                            Icons.campaign,
                            size: 80,
                            color: Colors.white,
                          ),
                        )
                      : _currentSong.imageUrl != null && _currentSong.imageUrl!.isNotEmpty
                          ? Image.network(
                              _currentSong.imageUrl!,
                              width: 180,
                              height: 180,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 180,
                                  height: 180,
                                  color: Colors.grey[800],
                                  child: const Icon(
                                    Icons.music_note,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: 180,
                              height: 180,
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.music_note,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Xây dựng thông tin bài hát
  Widget _buildMusicInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.all(32),
          child: _buildRotatingAlbumArt(),
        ),
        Text(
          _currentSong.title,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _currentSong.artistName,
          style: GoogleFonts.montserrat(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // Xây dựng thanh tiến trình phát nhạc
  Widget _buildProgressBar() {
    String _formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String minutes = twoDigits(duration.inMinutes.remainder(60));
      String seconds = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$seconds";
    }

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.purple,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
            thumbColor: Colors.white,
            trackHeight: 2.0,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 12,
            ),
          ),
          child: Slider(
            value: currentSliderValue.clamp(0, _duration.inSeconds.toDouble()),
            max: _duration.inSeconds.toDouble(),
            onChanged: (value) async {
              final spotifyService =
                  Provider.of<SpotifyProvider>(context, listen: false)
                      .spotifyService;
              setState(() {
                currentSliderValue = value;
                _position = Duration(seconds: value.toInt());
              });
              // Seek to position in milliseconds
              await spotifyService.seekToPosition(value.toInt() * 1000);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_position),
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                _formatDuration(_duration),
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Xây dựng các nút điều khiển
  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Nút thích
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.purple : Colors.white,
            size: 30,
          ),
          onPressed: () async {
            await _toggleFavorite();
            // Cập nhật UI ngay sau khi toggle
            setState(() {});
          },
        ),
        // Nút phát trước
        IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: _playPrevious,
        ),
        // Nút phát/dừng
        GestureDetector(
          onTap: _togglePlayPause,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.8),
                  Colors.blue.withOpacity(0.8)
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
        // Nút phát tiếp
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: _playNext,
        ),
        // Nút lặp lại
        IconButton(
          icon: Icon(
            _getRepeatIcon(),
            color: _getRepeatColor(),
            size: 30,
          ),
          onPressed: () {
            setState(() {
              switch (_playMode) {
                case PlayMode.none:
                  _playMode = PlayMode.sequential;
                  break;
                case PlayMode.sequential:
                  _playMode = PlayMode.shuffle;
                  break;
                case PlayMode.shuffle:
                  _playMode = PlayMode.repeatOne;
                  break;
                case PlayMode.repeatOne:
                  _playMode = PlayMode.none;
                  break;
              }
            });
          },
        ),
      ],
    );
  }

  // Xây dựng các nút hành động bên dưới
  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(Icons.queue_music, 'Danh sách phát'),
          _buildActionButton(Icons.share, 'Chia sẻ'),
          _buildActionButton(Icons.playlist_add, 'Thêm vào playlist'),
          _buildActionButton(Icons.timer, 'Hẹn giờ'),
        ],
      ),
    );
  }

  // Xây dựng nút hành động
  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white70),
          onPressed: () {
            // Xử lý sự kiện cho từng nút
            if (icon == Icons.queue_music) {
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else if (icon == Icons.playlist_add) {
              _showAddToPlaylistBottomSheet();
            } else if (icon == Icons.timer) {
              _showTimerBottomSheet();
            }
          },
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Xây dựng view lời bài hát
  Widget _buildLyricsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lời bài hát',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _currentSong.lyrics ?? 'Đang tải lời bài hát...',
            style: GoogleFonts.montserrat(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Xây dựng header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'Đang phát',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  IconData _getRepeatIcon() {
    switch (_playMode) {
      case PlayMode.none:
        return Icons.repeat;
      case PlayMode.sequential:
        return Icons.repeat;
      case PlayMode.shuffle:
        return Icons.shuffle;
      case PlayMode.repeatOne:
        return Icons.repeat_one;
    }
  }

  Color _getRepeatColor() {
    return _playMode == PlayMode.none
        ? Colors.white
        : AppColors.glowColors['blue']!;
  }

  // Toggle phát/dừng bài hát
  Future<void> _togglePlayPause() async {
    try {
      if (isPlaying) {
        await _spotifyService.pauseTrack();
        if (mounted) {
          setState(() {
            isPlaying = false;
            _rotationController.stop();
          });
        }
      } else {
        if (_position.inSeconds == 0) {
          await _initializeAudio();
        } else {
          await _spotifyService.resumeTrack();
          if (mounted) {
            setState(() {
              isPlaying = true;
              _rotationController.repeat();
            });
          }
        }
      }
    } catch (e) {
      print('Error toggling play/pause: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Không thể ${isPlaying ? "dừng" : "phát"} bài hát')),
        );
      }
    }
  }

  // Phát bài hát tiếp theo
  Future<void> _playNext() async {
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
      setState(() {
        _currentSong = _playlist[_currentIndex];
      });
      await _initializeAudio();
    }
  }

  // Phát bài hát trước
  Future<void> _playPrevious() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      setState(() {
        _currentSong = _playlist[_currentIndex];
      });
      await _initializeAudio();
    }
  }

  // Xây dựng danh sách phát
  Widget _buildPlaylistView() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 200),
      itemCount: _playlist.length,
      itemBuilder: (context, index) {
        final song = _playlist[index];
        final isPlaying = index == _currentIndex;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color:
                isPlaying ? Colors.purple.withOpacity(0.3) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: song.id == 'ads'
                  ? Container(
                      width: 48,
                      height: 48,
                      color: Colors.purple.withOpacity(0.3),
                      child: const Icon(Icons.campaign, color: Colors.white),
                    )
                  : song.imageUrl != null && song.imageUrl!.isNotEmpty
                      ? Image.network(
                          song.imageUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 48,
                          height: 48,
                          color: Colors.grey[800],
                          child: const Icon(Icons.music_note, color: Colors.white),
                        ),
            ),
            title: Text(
              song.title,
              style: TextStyle(
                color: isPlaying ? Colors.purple : Colors.white,
                fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              song.artistName,
              style: TextStyle(
                color: isPlaying ? Colors.purple.withOpacity(0.7) : Colors.grey,
              ),
            ),
            onTap: () {
              setState(() {
                _currentIndex = index;
                _currentSong = _playlist[index];
              });
              _initializeAudio();
            },
          ),
        );
      },
    );
  }

  void _showAddToPlaylistBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      builder: (context) => AddToPlaylistBottomSheet(song: _currentSong),
    );
  }

  // Kiểm tra trạng thái yêu thích
  Future<void> _checkFavoriteStatus() async {
    try {
      final favorites = await _playHistoryService.getFavorites();
      print('Current favorites: ${favorites.map((s) => s.spotifyId).toList()}');
      print('Checking favorite for spotifyId: ${_currentSong.spotifyId}');

      if (mounted) {
        setState(() {
          isFavorite =
              favorites.any((song) => song.spotifyId == _currentSong.spotifyId);
        });
        print('Is favorite: $isFavorite');
      }
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  // Toggle yêu thích bài hát
  Future<void> _toggleFavorite() async {
    try {
      print('Current song spotifyId: ${_currentSong.spotifyId}');

      // Kiểm tra và lưu bài hát nếu chưa có
      try {
        final songService = SongService();
        await songService.getSongBySpotifyId(_currentSong.spotifyId);
      } catch (e) {
        print('Song not found, saving to database first');
        final songService = SongService();
        await songService.saveSongToDatabase(_currentSong);
      }

      final result =
          await _playHistoryService.toggleFavorite(_currentSong.spotifyId);
      print('Toggle favorite result: $result');

      if (mounted) {
        setState(() {
          isFavorite = result;
        });

        await _checkFavoriteStatus();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                result ? 'Đã thêm vào yêu thích' : 'Đã xóa khỏi yêu thích'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  void _showTimerBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hẹn giờ tắt nhạc',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [15, 30, 45, 60].map((minutes) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _sleepMinutes == minutes
                        ? Colors.purple
                        : Colors.grey[800],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    _setSleepTimer(minutes);
                    Navigator.pop(context);
                  },
                  child: Text('$minutes phút'),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (_sleepTimer != null)
              TextButton(
                onPressed: _cancelSleepTimer,
                child: const Text(
                  'Hủy hẹn giờ',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _setSleepTimer(int minutes) {
    _cancelSleepTimer();
    setState(() => _sleepMinutes = minutes);

    _sleepTimer = Timer(Duration(minutes: minutes), () {
      _stopPlayback();
      setState(() {
        isPlaying = false;
        _sleepTimer = null;
        _sleepMinutes = null;
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã đặt hẹn giờ sau $minutes phút')),
    );
  }

  void _cancelSleepTimer() {
    _sleepTimer?.cancel();
    setState(() {
      _sleepTimer = null;
      _sleepMinutes = null;
    });
  }

  Song _createAdsSong() {
    return Song(
      id: 'ads',
      title: 'Quảng cáo',
      artistName: 'Trải nghiệm premium không quảng cáo',
      artistId: 0,
      genreName: 'Advertisement',
      genreId: 0,
      duration: 30,
      filePath: 'assets/mp3ads/ads.mp3',
      imageUrl: 'assets/images/ads_image.png',
      albumTitle: 'Advertisement',
      albumId: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    children: [
                      // Trang 1: Danh sách phát
                      _buildPlaylistView(),

                      // Trang 2: Album art
                      Column(
                        children: [
                          _buildMusicInfo(),
                        ],
                      ),

                      // Trang 3: Lyrics
                      _buildLyricsView(),
                    ],
                  ),

                  // Điều chỉnh vị trí controls
                  AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      final page = _pageController.page ?? 1;
                      final distance =
                          (page - 1).abs(); // Khoảng cách so với trang giữa

                      // Vị trí cao nhất khi ở trang giữa
                      final topPosition =
                          MediaQuery.of(context).size.height * 0.50;
                      // Vị trí thấp nhất khi ở trang bên
                      final bottomPosition =
                          MediaQuery.of(context).size.height * 0.65;

                      // Tính toán vị trí dựa trên khoảng cách
                      final top = topPosition +
                          (bottomPosition - topPosition) * distance;

                      return Positioned(
                        left: 0,
                        right: 0,
                        top: top,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          color: AppColors.background,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: _buildProgressBar(),
                              ),
                              const SizedBox(height: 32),
                              _buildControls(),
                              const SizedBox(height: 16),
                              _buildBottomActions(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
