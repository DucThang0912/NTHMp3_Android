import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';
import '../../models/song.dart';
import '../../services/song_service.dart';
import '../../providers/spotify_provider.dart';
import 'package:provider/provider.dart';

class SongManagementScreen extends StatefulWidget {
  const SongManagementScreen({super.key});

  @override
  State<SongManagementScreen> createState() => _SongManagementScreenState();
}

class _SongManagementScreenState extends State<SongManagementScreen> {
  final SongService _songService = SongService();
  List<Song> _songs = [];
  bool _isLoading = true;
  String _searchQuery = '';
  late final SpotifyProvider _spotifyProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _spotifyProvider = Provider.of<SpotifyProvider>(context, listen: false);
      _loadSongs();
    });
  }

  // Tải danh sách bài hát
  Future<void> _loadSongs() async {
    try {
      setState(() => _isLoading = true);
      final songs =
          await _spotifyProvider.spotifyService.searchSongs('top hits');
      setState(() {
        _songs = songs;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading songs: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải danh sách bài hát: $e')),
        );
      }
    }
  }

  // Tìm kiếm bài hát
  Future<void> _searchSongs(String query) async {
    try {
      setState(() => _isLoading = true);
      final songs = await _spotifyProvider.spotifyService.searchSongs(query);
      setState(() {
        _songs = songs;
        _isLoading = false;
      });
    } catch (e) {
      print('Error searching songs: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 197, 197, 204),
        title: Text(
          'Quản lý bài hát',
          style: GoogleFonts.montserrat(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSongs,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bài hát...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
                if (value.isNotEmpty) {
                  _searchSongs(value);
                } else {
                  _loadSongs();
                }
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _songs.length,
                    itemBuilder: (context, index) {
                      final song = _songs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        color: Colors.white.withOpacity(0.1),
                        child: ListTile(
                          leading: song.imageUrl != null
                              ? Image.network(
                                  song.imageUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.music_note,
                                  color: Colors.white),
                          title: Text(
                            song.title ?? 'Unknown Title',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            song.artistName ?? 'Unknown Artist',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
