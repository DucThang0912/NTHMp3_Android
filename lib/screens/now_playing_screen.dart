import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants/colors.dart';
import '../widgets/main_screen_bottom_nav.dart';
import 'package:google_fonts/google_fonts.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool isFavorite = false;
  double currentSliderValue = 0;
  
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pageController.addListener(() {
      _animationController.value = _pageController.page ?? 0;
    });
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
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
          const Text(
            'Đang phát',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Hiển thị menu tùy chọn
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMusicInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 300,
          height: 300,
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.surface,
          ),
          child: Lottie.asset(
            'assets/animations/musicDisc.json',
            fit: BoxFit.cover,
          ),
        ),
        const Text(
          'Tên bài hát',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tên nghệ sĩ',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
              thumbColor: AppColors.primary,
              trackHeight: 2.0,
            ),
            child: Slider(
              value: currentSliderValue,
              max: 100,
              onChanged: (value) {
                setState(() {
                  currentSliderValue = value;
                });
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0:00',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  '3:45',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? AppColors.primary : Colors.white,
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
          onPressed: () {
            // Chuyển về bài trước
          },
        ),
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.buttonGradient,
          ),
          child: IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () {
              setState(() {
                isPlaying = !isPlaying;
              });
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.skip_next, color: Colors.white, size: 35),
          onPressed: () {
            // Chuyển đến bài tiếp theo
          },
        ),
        IconButton(
          icon: const Icon(Icons.repeat, color: Colors.white, size: 30),
          onPressed: () {
            // Thay đổi chế độ lặp lại
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 200 + bottomPadding),
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
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.only(bottom: 32),
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Chưa có lời bài hát',
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
                      // Trang 1: Album art
                      Column(
                        children: [
                          _buildMusicInfo(),
                          const SizedBox(height: 30),
                          const Spacer(),
                        ],
                      ),
                      
                      // Trang 2: Lyrics
                      _buildLyricsView(),
                    ],
                  ),
                  
                  // Controls
                  Positioned(
                    left: 0,
                    right: 0,
                    top: MediaQuery.of(context).size.height * 0.45,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        color: AppColors.background,
                        padding: const EdgeInsets.only(bottom: 20),
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
                    ),
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