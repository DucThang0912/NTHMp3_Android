import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants/colors.dart';
import '../screens/playlist_screen.dart';
import '../screens/artist_screen.dart';
import '../widgets/main_screen_bottom_nav.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Thư viện',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // Tạo playlist mới
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
      onTap: () {
        if (title == 'Nghệ sĩ đang theo dõi') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ArtistScreen(),
            ),
          );
        }
      },
    );
  }

  Widget _buildPlaylistItem(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Lottie.asset(
          'assets/animations/musicDisc.json',
          fit: BoxFit.cover,
        ),
      ),
      title: const Text(
        'Tên playlist',
        style: TextStyle(color: Colors.white),
      ),
      subtitle: const Text(
        '10 bài hát',
        style: TextStyle(color: Colors.grey),
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
            builder: (context) => const PlaylistScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const Divider(color: Colors.grey),
              _buildSection(
                context: context,
                title: 'Bài hát đã thích',
                icon: Icons.favorite,
                onTap: () {
                  // Mở danh sách bài hát đã thích
                },
              ),
              _buildSection(
                context: context,
                title: 'Album đã lưu',
                icon: Icons.album,
                onTap: () {
                  // Mở danh sách album đã lưu
                },
              ),
              _buildSection(
                context: context,
                title: 'Nghệ sĩ đang theo dõi',
                icon: Icons.person,
                onTap: () {
                  // Mở danh sách nghệ sĩ đang theo dõi
                },
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Playlist của bạn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) => _buildPlaylistItem(context),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tạo playlist mới
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const MainScreenBottomNav(selectedIndex: 2),
    );
  }
}