import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants/colors.dart';
import '../screens/now_playing_screen.dart';
import '../screens/artist_screen.dart';
import '../widgets/main_screen_bottom_nav.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/search_screen.dart';
import '../models/genre.dart';
import '../models/song.dart';
import '../models/artist.dart';
import 'package:provider/provider.dart';
import '../providers/spotify_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AppBar(),
              _FeaturedBanner(),
              _RecentlyPlayed(),
              _TopTrending(),
              _Genres(),
              _NewReleases(),
              _TopArtists(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainScreenBottomNav(selectedIndex: 0),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xin chào!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Khám phá âm nhạc của bạn',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const SearchScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeaturedBanner extends StatefulWidget {
  const _FeaturedBanner();

  @override
  State<_FeaturedBanner> createState() => _FeaturedBannerState();
}

class _FeaturedBannerState extends State<_FeaturedBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<Map<String, dynamic>> _bannerData = [
    {
      'title': 'Discover Music',
      'subtitle': 'Let the rhythm move you',
      'colors': [Color(0xFF6A3093), Color(0xFFA044FF)],
      'icon': Icons.music_note,
    },
    {
      'title': 'Top Charts',
      'subtitle': 'What\'s hot right now',
      'colors': [Color(0xFF1D976C), Color(0xFF93F9B9)],
      'icon': Icons.trending_up,
    },
    {
      'title': 'For You',
      'subtitle': 'Personalized picks',
      'colors': [Color(0xFFFF416C), Color(0xFFFF4B2B)],
      'icon': Icons.favorite,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment(
                      math.cos(_animation.value) * 1,
                      math.sin(_animation.value) * 1,
                    ),
                    end: Alignment(
                      math.cos(_animation.value + math.pi) * 1,
                      math.sin(_animation.value + math.pi) * 1,
                    ),
                    colors: _bannerData[index]['colors'],
                  ),
                ),
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size.infinite,
                      painter: index == 0 
                          ? WavePainter(animation: _animation.value, color: Colors.white.withOpacity(0.1))
                          : index == 1 
                              ? CirclePainter(animation: _animation.value, color: Colors.white.withOpacity(0.1))
                              : BubblePainter(animation: _animation.value, color: Colors.white.withOpacity(0.1)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [Colors.white, Colors.white.withOpacity(0.7)],
                                  ).createShader(bounds),
                                  child: Text(
                                    _bannerData[index]['title'],
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _bannerData[index]['subtitle'],
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _animation.value,
                                child: Icon(
                                  _bannerData[index]['icon'],
                                  color: Colors.white.withOpacity(0.8),
                                  size: 50,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animation;
  final Color color;

  WavePainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    var y = size.height / 2;
    
    path.moveTo(0, y);
    
    for (var i = 0.0; i < size.width; i++) {
      y = size.height / 2 +
          math.sin((i / 30) + animation) * 20 +
          math.cos((i / 50) + animation) * 20;
      path.lineTo(i, y);
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}

class CirclePainter extends CustomPainter {
  final double animation;
  final Color color;

  CirclePainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var i = 0; i < 5; i++) {
      final radius = (size.width / 4) * (i + 1) + (math.sin(animation + i) * 20);
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}

class BubblePainter extends CustomPainter {
  final double animation;
  final Color color;

  BubblePainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 10; i++) {
      final x = math.cos(animation * 2 + i) * size.width / 2 + size.width / 2;
      final y = math.sin(animation * 3 + i) * size.height / 2 + size.height / 2;
      canvas.drawCircle(
        Offset(x, y),
        10 + math.sin(animation + i) * 5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) => true;
}

class _Genres extends StatefulWidget {
  const _Genres();

  @override
  State<_Genres> createState() => _GenresState();
}

class _GenresState extends State<_Genres> {
  List<Genre> genres = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  Future<void> _loadGenres() async {
    try {
      final spotifyProvider = Provider.of<SpotifyProvider>(context, listen: false);
      final loadedGenres = await spotifyProvider.spotifyService.getGenres();
      setState(() {
        genres = loadedGenres;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading genres: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Thể loại',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: genres.length,
              itemBuilder: (context, index) {
                final genre = genres[index];
                // Tạo màu ngẫu nhiên cho mỗi thể loại
                final color = Colors.primaries[index % Colors.primaries.length];
                
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        genre.name ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
}

class _RecentlyPlayed extends StatefulWidget {
  const _RecentlyPlayed();

  @override
  State<_RecentlyPlayed> createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<_RecentlyPlayed> {
  List<Song> recentSongs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentSongs();
  }

  Future<void> _loadRecentSongs() async {
    try {
      final spotifyProvider = Provider.of<SpotifyProvider>(context, listen: false);
      final songs = await spotifyProvider.spotifyService.searchSongs('recent popular vietnam');
      setState(() {
        recentSongs = songs.take(10).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading recent songs: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Gần đây',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          SizedBox(
            height: 220,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: recentSongs.length,
              itemBuilder: (context, index) {
                final song = recentSongs[index];
                return _RecentlyPlayedItem(song: song);
              },
            ),
          ),
      ],
    );
  }
}

class _RecentlyPlayedItem extends StatelessWidget {
  final Song song;
  
  const _RecentlyPlayedItem({required this.song});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NowPlayingScreen(song: song),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purple.withOpacity(0.7),
                      Colors.blue.withOpacity(0.7),
                    ],
                  ),
                ),
                child: song.imageUrl != null && song.imageUrl!.isNotEmpty
                    ? Image.network(
                        song.imageUrl!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.music_note, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artistName,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _TopTrending extends StatefulWidget {
  const _TopTrending();

  @override
  State<_TopTrending> createState() => _TopTrendingState();
}

class _TopTrendingState extends State<_TopTrending> {
  List<Song> trendingSongs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrendingSongs();
  }

  Future<void> _loadTrendingSongs() async {
    try {
      final spotifyProvider = Provider.of<SpotifyProvider>(context, listen: false);
      final songs = await spotifyProvider.spotifyService.searchSongs('top trending vietnam');
      setState(() {
        trendingSongs = songs.take(10).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading trending songs: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Thịnh hành',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: trendingSongs.length,
              itemBuilder: (context, index) {
                return _TopTrendingItem(song: trendingSongs[index]);
              },
            ),
          ),
      ],
    );
  }
}

class _TopTrendingItem extends StatelessWidget {
  final Song song;
  const _TopTrendingItem({required this.song});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NowPlayingScreen(song: song),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: song.imageUrl != null && song.imageUrl!.isNotEmpty
                  ? Image.network(
                      song.imageUrl!,
                      height: 160,
                      width: 160,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.purple.withOpacity(0.7),
                            Colors.blue.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: const Icon(Icons.music_note, color: Colors.white, size: 50),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artistName,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _NewReleases extends StatefulWidget {
  const _NewReleases();

  @override
  State<_NewReleases> createState() => _NewReleasesState();
}

class _NewReleasesState extends State<_NewReleases> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Mới phát hành', 'BXH', 'V-Pop', 'K-Pop'];
  List<Song> songs = [];
  List<Song> vPopSongs = [];
  List<Song> kPopSongs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadSongs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSongs() async {
    try {
      final spotifyProvider = Provider.of<SpotifyProvider>(context, listen: false);
      
      // Load new releases
      final newReleases = await spotifyProvider.spotifyService.getNewReleases();
      print('New Releases loaded: ${newReleases.length} songs');
      
      // Load top charts Vietnam
      final topCharts = await spotifyProvider.spotifyService.searchSongs('top vietnam', market: 'VN');
      print('Top Charts loaded: ${topCharts.length} songs');
      
      // Load V-Pop với query mới
      final vPop = await spotifyProvider.spotifyService.searchSongs('Son Tung MTP Vu My Tam', market: 'VN');
      print('V-Pop loaded: ${vPop.length} songs');
      print('V-Pop songs: ${vPop.map((s) => s.title).toList()}');
      
      // Load K-Pop
      final kPop = await spotifyProvider.spotifyService.searchSongsByGenre('k-pop');
      print('K-Pop loaded: ${kPop.length} songs');

      if (mounted) {
        setState(() {
          songs = newReleases;
          vPopSongs = vPop;
          kPopSongs = kPop;
          isLoading = false;
        });
        print('State updated - vPopSongs length: ${vPopSongs.length}');
      }
    } catch (e) {
      print('Error loading songs: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: Colors.purple,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
        SizedBox(
          height: 300,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildNewReleasesList(),
              _buildRankingList(),
              _buildVPopList(),
              _buildKPopList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewReleasesList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlayingScreen(song: song),
                ),
              );
            },
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: song.imageUrl != null && song.imageUrl!.isNotEmpty
                  ? Image.network(
                      song.imageUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.purple.withOpacity(0.7),
                            Colors.blue.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: const Icon(Icons.music_note, color: Colors.white, size: 24),
                    ),
            ),
            title: Text(
              song.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              song.artistName,
              style: TextStyle(
                color: Colors.grey[400],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              _formatDate(song.createdDate!),
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hôm nay';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildRankingList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 35,
                  alignment: Alignment.center,
                  child: Text(
                    '#${index + 1}',
                    style: TextStyle(
                      color: index < 3 ? Colors.purple : Colors.grey[400],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: song.imageUrl != null && song.imageUrl!.isNotEmpty
                      ? Image.network(
                          song.imageUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.purple.withOpacity(0.7),
                                Colors.blue.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: const Icon(Icons.music_note, color: Colors.white),
                        ),
                ),
              ],
            ),
            title: Text(
              song.title,
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              song.artistName,
              style: TextStyle(color: Colors.grey[400]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlayingScreen(song: song),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildVPopList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vPopSongs.length,
      itemBuilder: (context, index) {
        final song = vPopSongs[index];
        return _buildSongListItem(song);
      },
    );
  }

  Widget _buildKPopList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: kPopSongs.length,
      itemBuilder: (context, index) {
        final song = kPopSongs[index];
        return _buildSongListItem(song);
      },
    );
  }

  Widget _buildSongListItem(Song song) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: song.imageUrl != null && song.imageUrl!.isNotEmpty
              ? Image.network(
                  song.imageUrl!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.purple.withOpacity(0.7),
                        Colors.blue.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: const Icon(Icons.music_note, color: Colors.white, size: 24),
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
          style: TextStyle(color: Colors.grey[400]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NowPlayingScreen(song: song),
            ),
          );
        },
      ),
    );
  }
}

class _TopGridItem extends StatelessWidget {
  const _TopGridItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Lottie.asset(
                'assets/animations/musicDisc.json',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewReleasesItem extends StatelessWidget {
  final Song? song;
  const _NewReleasesItem({this.song});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.withOpacity(0.7),
                Colors.blue.withOpacity(0.7),
              ],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.music_note,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      title: Text(
        song?.title ?? 'Chưa có tên bài hát',
        style: const TextStyle(color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song?.artistName ?? 'Chưa có tên nghệ sĩ',
        style: const TextStyle(color: Colors.grey),
      ),
      onTap: song != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlayingScreen(song: song!),
                ),
              );
            }
          : null,
    );
  }
}

class _TopArtists extends StatefulWidget {
  const _TopArtists();

  @override
  State<_TopArtists> createState() => _TopArtistsState();
}

class _TopArtistsState extends State<_TopArtists> {
  List<Artist> artists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArtists();
  }

  Future<void> _loadArtists() async {
    try {
      final spotifyProvider = Provider.of<SpotifyProvider>(context, listen: false);
      final loadedArtists = await spotifyProvider.spotifyService.getTopArtists();
      setState(() {
        artists = loadedArtists;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading artists: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Nghệ sĩ nổi bật',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: artists.length,
              itemBuilder: (context, index) {
                return _ArtistItem(artist: artists[index]);
              },
            ),
          ),
      ],
    );
  }
}

class _ArtistItem extends StatelessWidget {
  final Artist artist;
  const _ArtistItem({required this.artist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistScreen(artistId: artist.spotifyId),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: artist.avatarUrl != null && artist.avatarUrl!.isNotEmpty
                  ? Image.network(
                      artist.avatarUrl!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.purple.withOpacity(0.7),
                            Colors.blue.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 50),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              artist.name ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}