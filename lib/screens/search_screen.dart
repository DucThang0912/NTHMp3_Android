import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:lottie/lottie.dart';
import '../screens/now_playing_screen.dart';
import '../widgets/main_screen_bottom_nav.dart';
import 'package:provider/provider.dart';
import '../services/spotify_service.dart';
import '../models/genre.dart';
import '../models/song.dart';
import '../providers/spotify_provider.dart';

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
  late SpotifyService _spotifyService;
  List<Genre> _genres = [];
  List<Song> _trendingSongs = [];
  bool _isLoading = true;
  List<Song> _searchResults = [];
  bool _isSearchLoading = false;

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

    _spotifyService = Provider.of<SpotifyProvider>(context, listen: false).spotifyService;
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final genres = await _spotifyService.getGenres();
      final trendingSongs = await _spotifyService.searchSongs('tag:hipster');
      
      setState(() {
        _genres = genres;
        _trendingSongs = trendingSongs.take(5).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() => _isLoading = false);
    }
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
            onChanged: (value) async {
              setState(() {
                _isSearching = value.isNotEmpty;
                _isSearchLoading = value.isNotEmpty;
              });
              
              if (value.isNotEmpty) {
                try {
                  final results = await _spotifyService.searchSongs(value);
                  setState(() {
                    _searchResults = results;
                    _isSearchLoading = false;
                  });
                } catch (e) {
                  print('Error searching songs: $e');
                  setState(() => _isSearchLoading = false);
                }
              }
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
            itemCount: _trendingSongs.length,
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
                        _searchController.text = _trendingSongs[index].title;
                        setState(() {
                          _isSearching = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Text(
                          _trendingSongs[index].title,
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
          itemCount: _genres.length,
          itemBuilder: (context, index) {
            final color = Colors.primaries[index % Colors.primaries.length];
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withOpacity(0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
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
                        _searchController.text = _genres[index].name ?? '';
                        setState(() {
                          _isSearching = true;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 40 * (0.8 + (_animation.value * 0.2)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _genres[index].name ?? '',
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
    if (_isSearchLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final song = _searchResults[index];
        return ListTile(
          leading: Hero(
            tag: 'song_${song.id ?? DateTime.now().millisecondsSinceEpoch}_$index',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: song.imageUrl != null && song.imageUrl!.isNotEmpty
                  ? Image.network(
                      song.imageUrl!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
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
          ),
          title: Text(
            song.title,
            style: const TextStyle(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            song.artistName,
            style: const TextStyle(color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NowPlayingScreen(
                  song: song,
                  playlist: _searchResults,
                  currentIndex: _searchResults.indexOf(song),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
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