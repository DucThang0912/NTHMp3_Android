import 'package:flutter/material.dart';
import 'package:nthmusicmp3/models/playlist.dart';
import 'package:nthmusicmp3/models/song.dart';
import 'package:nthmusicmp3/services/playlist_service.dart';
import 'package:nthmusicmp3/services/spotify_service.dart';
import '../constants/colors.dart';
import '../models/album.dart';
import '../models/artist.dart';
import '../screens/playlist/playlist_screen.dart';
import '../screens/album_screen.dart';
import '../widgets/main_screen_bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nthmusicmp3/services/play_history_service.dart';
import '../screens/now_playing_screen.dart';
import 'package:provider/provider.dart';
import 'package:nthmusicmp3/providers/spotify_provider.dart';

class LibraryScreen extends StatefulWidget {
  final int initialTabIndex;

  const LibraryScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.index = widget.initialTabIndex;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.background,
        title: const Text(
          'Thư viện',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Playlist'),
            Tab(text: 'Bài hát'),
            Tab(text: 'Album'),
            Tab(text: 'Nghệ sĩ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PlaylistTab(),
          _SongsTab(),
          _AlbumsTab(),
          _ArtistsTab(),
        ],
      ),
      bottomNavigationBar: const MainScreenBottomNav(selectedIndex: 2),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _PlaylistTab extends StatefulWidget {
  @override
  State<_PlaylistTab> createState() => _PlaylistTabState();
}

class _PlaylistTabState extends State<_PlaylistTab> {
  final PlaylistService _playlistService = PlaylistService();
  List<Playlist> _playlists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username') ?? '';
      final playlists =
          await _playlistService.getUserPlaylistsByUsername(username);
      if (mounted) {
        setState(() {
          _playlists = playlists;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading playlists: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _refreshPlaylists() {
    setState(() => _isLoading = true);
    _loadPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _playlists.length,
          itemBuilder: (context, index) {
            return PlaylistScreen(
              playlist: _playlists[index],
              onDeleted: _refreshPlaylists,
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () => _showCreatePlaylistDialog(context),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Tạo Playlist Mới',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Tên playlist',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Mô tả (tùy chọn)',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await _createPlaylist(
                  nameController.text,
                  descriptionController.text,
                );
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }

  Future<void> _createPlaylist(String name, String description) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        throw Exception('Vui lòng đăng nhập để tạo playlist');
      }

      if (mounted) Navigator.pop(context);

      final playlist = await _playlistService.createPlaylist({
        'name': name,
        'description': description,
        'isPublic': true,
        'user_id': userId,
      });

      if (mounted) {
        await _loadPlaylists();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã tạo playlist thành công')),
        );
      }
    } catch (e) {
      print('Error creating playlist: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tạo playlist: $e')),
        );
      }
    }
  }
}

class _SongsTab extends StatefulWidget {
  @override
  State<_SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<_SongsTab> {
  final PlayHistoryService _playHistoryService = PlayHistoryService();
  List<Song> _favoriteSongs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteSongs();
  }

  Future<void> _loadFavoriteSongs() async {
    try {
      setState(() => _isLoading = true);
      final songs = await _playHistoryService.getFavorites();
      if (mounted) {
        setState(() {
          _favoriteSongs = songs;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading favorite songs: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_favoriteSongs.isEmpty) {
      return const Center(
        child: Text(
          'Chưa có bài hát yêu thích nào',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favoriteSongs.length,
      itemBuilder: (context, index) {
        final song = _favoriteSongs[index];
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
                  ? Image.network(song.imageUrl!,
                      width: 48, height: 48, fit: BoxFit.cover)
                  : Container(
                      width: 48,
                      height: 48,
                      color: Colors.grey,
                      child: const Icon(Icons.music_note),
                    ),
            ),
            title:
                Text(song.title, style: const TextStyle(color: Colors.white)),
            subtitle: Text(song.artistName,
                style: const TextStyle(color: Colors.grey)),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlayingScreen(
                    song: song,
                    playlist: _favoriteSongs,
                    currentIndex: index,
                  ),
                ),
              );
              // Refresh danh sách khi quay lại
              _loadFavoriteSongs();
            },
          ),
        );
      },
    );
  }
}

class _AlbumsTab extends StatefulWidget {
  @override
  State<_AlbumsTab> createState() => _AlbumsTabState();
}

class _AlbumsTabState extends State<_AlbumsTab> {
  late final SpotifyService _spotifyService;
  List<Album> _albums = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _spotifyService =
        Provider.of<SpotifyProvider>(context, listen: false).spotifyService;
    _loadAlbums();
  }

  Future<void> _loadAlbums() async {
    try {
      setState(() => _isLoading = true);
      final albums =
          await _spotifyService.getArtistAlbums('1dfeR4HaWDbWqFHLkxsg1d');
      if (mounted) {
        setState(() {
          _albums = albums;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading albums: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _albums.length,
      itemBuilder: (context, index) {
        final album = _albums[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlbumScreen(
                  album: album,
                  spotifyService: _spotifyService,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      image: album.coverImageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(album.coverImageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: album.coverImageUrl == null
                        ? const Icon(Icons.album, color: Colors.white, size: 40)
                        : null,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          album.title ?? 'Unknown Title',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          album.artist?.name ?? 'Unknown Artist',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${album.releaseYear}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ArtistsTab extends StatefulWidget {
  @override
  State<_ArtistsTab> createState() => _ArtistsTabState();
}

class _ArtistsTabState extends State<_ArtistsTab> {
  late final SpotifyService _spotifyService;
  List<Artist> _artists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _spotifyService =
        Provider.of<SpotifyProvider>(context, listen: false).spotifyService;
    _loadArtists();
  }

  Future<void> _loadArtists() async {
    try {
      setState(() => _isLoading = true);
      final artists = await _spotifyService.getTopArtists();
      if (mounted) {
        setState(() {
          _artists = artists;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading artists: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _artists.length,
      itemBuilder: (context, index) {
        final artist = _artists[index];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: artist.avatarUrl != null
                    ? NetworkImage(artist.avatarUrl!)
                    : null,
                child: artist.avatarUrl == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                artist.name ?? 'Unknown Artist',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
