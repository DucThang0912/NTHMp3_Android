import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/library_screen.dart';
import '../screens/profile_screen.dart';

class MainScreenBottomNav extends StatelessWidget {
  final int selectedIndex;

  const MainScreenBottomNav({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index == selectedIndex) return;
        
        Widget screen;
        switch (index) {
          case 0:
            screen = const HomeScreen();
            break;
          case 1:
            screen = const SearchScreen();
            break;
          case 2:
            screen = const LibraryScreen();
            break;
          case 3:
            screen = const ProfileScreen();
            break;
          default:
            return;
        }
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => screen,
          ),
        );
      },
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Tìm kiếm',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_music),
          label: 'Thư viện',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Tài khoản',
        ),
      ],
    );
  }
} 