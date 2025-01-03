import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants/colors.dart';
import 'now_playing_screen.dart';
import '../widgets/main_screen_bottom_nav.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        // Album Cover
        Container(
          height: 300,
          width: double.infinity,
          color: AppColors.surface
        ),
        // Back Button
        Positioned(
          top: 40,
          left: 16,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        // Album Info
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tên Album',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Tên Nghệ Sĩ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• 12 bài hát',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSongList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          title: const Text(
            'Tên bài hát',
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Row(
            children: [
              Icon(Icons.play_circle_filled, 
                   color: Colors.grey, size: 16),
              const SizedBox(width: 4),
              Text(
                '1.5M lượt nghe',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {
              // Hiển thị menu tùy chọn
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NowPlayingScreen(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.shuffle, color: Colors.white, size: 30),
            onPressed: () {
              // Phát ngẫu nhiên
            },
          ),
          Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              gradient: AppColors.mainGradient,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                // Phát tất cả
              },
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              label: const Text(
                'Phát tất cả',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white, size: 30),
            onPressed: () {
              // Thêm vào yêu thích
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildControls(),
            _buildSongList(context),
          ],
        ),
      ),
      bottomNavigationBar: const MainScreenBottomNav(selectedIndex: -1),
    );
  }
} 