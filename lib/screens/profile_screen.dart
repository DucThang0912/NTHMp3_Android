import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import '../widgets/main_screen_bottom_nav.dart';
import 'profile_details_screen.dart';
import 'upgrade_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return _buildAuthenticatedProfile(context, authProvider);
        }
        return _buildUnauthenticatedProfile(context);
      },
    );
  }

  Widget _buildAuthenticatedProfile(
      BuildContext context, AuthProvider authProvider) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'Xin chào, ${authProvider.username}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            _buildProfileMenuItem(
              icon: Icons.person_outline,
              title: 'Thông tin cá nhân',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileDetailsScreen(),
                  ),
                );
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.favorite_outline,
              title: 'Bài hát yêu thích',
              onTap: () {
                // TODO: Navigate to favorite songs
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.playlist_play,
              title: 'Playlist của tôi',
              onTap: () {
                // TODO: Navigate to my playlists
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.workspace_premium,
              title: 'Nâng cấp tài khoản',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpgradeScreen(),
                  ),
                );
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.settings_outlined,
              title: 'Cài đặt',
              onTap: () {
                // TODO: Navigate to settings
              },
            ),
            const Divider(color: Colors.white24),
            _buildProfileMenuItem(
              icon: Icons.logout,
              title: 'Đăng xuất',
              onTap: () async {
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainScreenBottomNav(selectedIndex: 3),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.white54,
      ),
      onTap: onTap,
    );
  }

  Widget _buildUnauthenticatedProfile(BuildContext context) {
    // Widget hiện tại của bạn cho người dùng chưa đăng nhập
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/musicDisc.json',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 32),
              const Text(
                'Đăng nhập để trải nghiệm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tạo playlist, lưu bài hát yêu thích\nvà đồng bộ trên mọi thiết bị',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  gradient: AppColors.mainGradient,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainScreenBottomNav(selectedIndex: 3),
    );
  }
}
