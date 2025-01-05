import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:lottie/lottie.dart';
import '../screens/now_playing_screen.dart';
import '../widgets/main_screen_bottom_nav.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> _trendingSearches = [
    'Sơn Tùng MTP',
    'Taylor Swift',
    'BlackPink',
    'BTS',
    'Jack',
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Pop', 'color': Colors.pink, 'icon': Icons.music_note},
    {'name': 'Rock', 'color': Colors.blue, 'icon': Icons.electric_bolt},
    {'name': 'Jazz', 'color': Colors.orange, 'icon': Icons.piano},
    {'name': 'Classical', 'color': Colors.purple, 'icon': Icons.album},
    {'name': 'Hip Hop', 'color': Colors.green, 'icon': Icons.mic},
    {'name': 'Electronic', 'color': Colors.red, 'icon': Icons.headphones},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildSearchBar() {
    return Hero(
      tag: 'searchBar',
      child: Container(
        height: 45,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: _isSearching ? 15 : 0,
              spreadRadius: _isSearching ? 2 : 0,
            ),
          ],
        ),
        child: Center(
          child: TextField(
            controller: _searchController,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            onChanged: (value) {
              setState(() {
                _isSearching = value.isNotEmpty;
              });
            },
            decoration: InputDecoration(
              hintText: 'Tìm kiếm bài hát, nghệ sĩ...',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
              suffixIcon: _isSearching
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _isSearching = false;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              isDense: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Xu hướng tìm kiếm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _trendingSearches.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.withOpacity(_animation.value * 0.8),
                            Colors.blue.withOpacity(_animation.value * 0.5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: child,
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        _searchController.text = _trendingSearches[index];
                        setState(() {
                          _isSearching = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Text(
                          _trendingSearches[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Khám phá thể loại',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _categories[index]['color'],
                        _categories[index]['color'].withOpacity(0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: _categories[index]['color'].withOpacity(0.3),
                        blurRadius: 10 * _animation.value,
                        spreadRadius: 2 * _animation.value,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        // Navigate to category
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _categories[index]['icon'],
                            color: Colors.white,
                            size: 40 * (0.8 + (_animation.value * 0.2)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _categories[index]['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Hero(
            tag: 'song_$index',
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withOpacity(_animation.value),
                    Colors.blue.withOpacity(_animation.value),
                  ],
                ),
              ),
              child: const Icon(Icons.music_note, color: Colors.white),
            ),
          ),
          title: const Text(
            'Tên bài hát',
            style: TextStyle(color: Colors.white),
          ),
          subtitle: const Text(
            'Tên nghệ sĩ',
            style: TextStyle(color: Colors.grey),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {
              // Show options
            },
          ),
          // onTap: () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const NowPlayingScreen(),
          //     ),
          //   );
          // },
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
              _buildSearchBar(),
              if (_isSearching)
                _buildSearchResults()
              else
                Column(
                  children: [
                    _buildTrendingSearches(),
                    const SizedBox(height: 16),
                    _buildCategories(),
                  ],
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainScreenBottomNav(selectedIndex: 1),
    );
  }
}