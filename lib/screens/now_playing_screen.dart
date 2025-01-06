import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/song.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../providers/spotify_provider.dart';

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
  
  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    
    _currentSong = widget.song;
    
    _setupAudioPlayer();
    
    // Load song details when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final spotifyService = Provider.of<SpotifyProvider>(context, listen: false).spotifyService;
        final updatedSong = await spotifyService.loadSongDetails(_currentSong);
        
        if (mounted) {
          setState(() {
            _currentSong = updatedSong;
          });
          _initializeAudio();
        }
      }
    });
  }

  Future<void> _initializeAudio() async {
    try {
      print("Current song path: ${_currentSong.filePath}"); // Debug log
      
      if (_currentSong.filePath.isEmpty) {
        throw Exception('No preview available');
      }

      // Đặt lại trạng thái
      await _audioPlayer.stop();
      await _audioPlayer.setUrl(_currentSong.filePath);
      
      // Lấy duration thực tế
      final duration = await _audioPlayer.duration;
      print("Audio duration: $duration"); // Debug log
      
      if (mounted) {
        setState(() {
          _duration = duration ?? const Duration(seconds: 30);
          isPlaying = true;
        });
        
        // Bắt đầu phát nhạc và animation
        _rotationController.repeat();
        await _audioPlayer.play();
      }
    } catch (e) {
      print('Error initializing audio: $e');
      if (mounted) {
        setState(() => isPlaying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('preview') 
                ? 'Bài hát này không có bản preview' 
                : 'Không thể phát bài hát này: ${e.toString()}'
            ),
          ),
        );
      }
    }
  }

  void _setupAudioPlayer() {
    _audioPlayer.durationStream.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration ?? Duration.zero);
      }
    });

    _audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
          currentSliderValue = position.inSeconds.toDouble();
        });
      }
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          _handleSongEnd();
        }
      }
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
    _audioPlayer.dispose();
    _rotationController.dispose();
    super.dispose();
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
            value: currentSliderValue,
            max: _duration.inSeconds.toDouble(),
            onChanged: (value) {
              setState(() {
                currentSliderValue = value;
                _position = Duration(seconds: value.toInt());
              });
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
          onTap: () async {
            if (_currentSong.filePath.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Không có bản preview cho bài hát này')),
              );
              return;
            }
            
            setState(() {
              isPlaying = !isPlaying;
            });
            
            if (isPlaying) {
              await _audioPlayer.play();
              _rotationController.repeat();
            } else {
              await _audioPlayer.pause();
              _rotationController.stop();
            }
          },
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
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 200),
      child: Column(
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
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  widget.song.lyrics ?? 'Chưa có lời bài hát',
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
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