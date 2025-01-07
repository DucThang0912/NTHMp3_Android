import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/song.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../providers/spotify_provider.dart';
import '../services/spotify_service.dart';

enum PlayMode {
  none,        // Phát một lần rồi dừng
  sequential,  // Phát lần lượt
  shuffle,     // Phát ngẫu nhiên
  repeatOne    // Lặp lại một bài
}

class NowPlayingScreen extends StatefulWidget {
  final Song song;
  
  const NowPlayingScreen({
    super.key,
    required this.song,
  });

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> 
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final PageController _pageController = PageController();
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
  
  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    
    _currentSong = widget.song;
    _setupAudioPlayer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _spotifyService = Provider.of<SpotifyProvider>(context, listen: false).spotifyService;
    
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

  Future<void> _initializeAudio() async {
    try {
      // Đảm bảo dừng bài hát đang phát (nếu có)
      await _spotifyService.pauseTrack();
      await Future.delayed(Duration(milliseconds: 500));
      
      await _spotifyService.playSpotifyTrack(_currentSong.spotifyId);
      setState(() {
        isPlaying = true;
        _position = Duration.zero;
        currentSliderValue = 0;
        _duration = Duration(seconds: _currentSong.duration);
        _rotationController.repeat();
      });
    } catch (e) {
      print('Error playing: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể phát bài hát này')),
      );
    }
  }

  void _setupAudioPlayer() {
    // Lắng nghe thời lượng bài hát từ Spotify
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      if (isPlaying) {
        setState(() {
          _position = _position + const Duration(milliseconds: 500);
          currentSliderValue = _position.inSeconds.toDouble();
        });
      }
    });

    // Cập nhật duration khi bài hát được load
    setState(() {
      _duration = Duration(seconds: _currentSong.duration);
    });
  }

  void _handleSongEnd() {
    switch (_playMode) {
      case PlayMode.none:
        setState(() {
          isPlaying = false;
          _rotationController.stop();
        });
        break;
      case PlayMode.sequential:
        // TODO: Chuyển bài tiếp theo
        break;
      case PlayMode.shuffle:
        // TODO: Chuyển bài ngẫu nhiên
        break;
      case PlayMode.repeatOne:
        setState(() {
          _position = Duration.zero;
          currentSliderValue = 0;
        });
        break;
    }
  }
  
  @override
  void dispose() {
    _stopPlayback();
    _audioPlayer.dispose();
    _rotationController.dispose();
    super.dispose();
  }

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
                  child: widget.song.imageUrl != null && widget.song.imageUrl!.isNotEmpty
                      ? Image.network(
                          widget.song.imageUrl!,
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

  Widget _buildMusicInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.all(32),
          child: _buildRotatingAlbumArt(),
        ),
        Text(
          widget.song.title,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.song.artistName,
          style: GoogleFonts.montserrat(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

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
              final spotifyService = Provider.of<SpotifyProvider>(context, listen: false).spotifyService;
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

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.purple : Colors.white,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 35),
          onPressed: () {},
        ),
        GestureDetector(
          onTap: _togglePlayPause,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.purple.withOpacity(0.8), Colors.blue.withOpacity(0.8)],
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
        IconButton(
          icon: const Icon(Icons.skip_next, color: Colors.white, size: 35),
          onPressed: () {},
        ),
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

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(Icons.queue_music, 'Danh sách phát'),
          _buildActionButton(Icons.share, 'Chia sẻ'),
          _buildActionButton(Icons.equalizer, 'Equalizer'),
          _buildActionButton(Icons.timer, 'Hẹn giờ'),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white70),
          onPressed: () {
            // Xử lý sự kiện cho từng nút
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
          SnackBar(content: Text('Không thể ${isPlaying ? "dừng" : "phát"} bài hát')),
        );
      }
    }
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
                      // Trang 1: Album art
                      Column(
                        children: [
                          _buildMusicInfo(),
                        ],
                      ),
                      
                      // Trang 2: Lyrics
                      _buildLyricsView(),
                    ],
                  ),
                  
                  // Điều chỉnh vị trí controls
                  AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      final page = _pageController.page ?? 0;
                      // Điều chỉnh vị trí ban đầu và khoảng cách di chuyển
                      final topPadding = MediaQuery.of(context).size.height * 0.55; // Tăng lên để không che text
                      final bottomPadding = MediaQuery.of(context).size.height * 0.65; // Giảm xuống để không vượt quá màn hình
                      final top = topPadding + (bottomPadding - topPadding) * page;
                      
                      return Positioned(
                        left: 0,
                        right: 0,
                        top: top,
                        child: Container(
                          color: AppColors.background,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: _buildProgressBar(),
                              ),
                              const SizedBox(height: 20),
                              _buildControls(),
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