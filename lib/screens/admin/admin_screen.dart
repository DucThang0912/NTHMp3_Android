import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'user_management_screen.dart';
import 'song_management_screen.dart';
import 'playlist_management_screen.dart';
import 'statistics_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 197, 197, 204),
        title: const Text('Admin Dashboard'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildAdminCard(
            context,
            'Quản lý người dùng',
            Icons.people,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserManagementScreen()),
            ),
          ),
          _buildAdminCard(
            context,
            'Quản lý bài hát',
            Icons.music_note,
            Colors.purple,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SongManagementScreen()),
            ),
          ),
          _buildAdminCard(
            context,
            'Quản lý playlist',
            Icons.playlist_play,
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const PlaylistManagementScreen()),
            ),
          ),
          _buildAdminCard(
            context,
            'Thống kê',
            Icons.bar_chart,
            Colors.green,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return Card(
      color: color.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
