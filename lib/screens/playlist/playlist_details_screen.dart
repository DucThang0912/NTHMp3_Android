import 'package:flutter/material.dart';
import 'package:nthmusicmp3/models/song.dart';
import '../../models/playlist.dart';
import '../../constants/colors.dart';
import '../../services/playlist_service.dart';
import '../../screens/now_playing_screen.dart';

class PlaylistDetailsScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailsScreen({
    super.key,
    required this.playlist,
  });

  @override
  State<PlaylistDetailsScreen> createState() => _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState extends State<PlaylistDetailsScreen> {
  final PlaylistService _playlistService = PlaylistService();
  List<Song> _songs = [];
  bool _isLoading = true;
  int _currentPlayingIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadPlaylistSongs();
  }

  Future<void> _loadPlaylistSongs() async {
    try {
      final songs =
          await _playlistService.getPlaylistSongs(widget.playlist.id!);
      if (mounted) {
        setState(() {
          _songs = songs;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading playlist songs: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải danh sách bài hát: $e')),
        );
      }
    }
  }

  Future<void> _removeSongFromPlaylist(Song song, int index) async {
    try {
      if (song.id == null) {
        throw Exception('Không tìm thấy ID bài hát');
      }

      await _playlistService.removeSongFromPlaylist(
        widget.playlist.id!,
        song.id.toString(),
      );

      setState(() {
        _songs.removeAt(index);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xóa "${song.title}" khỏi playlist')),
        );
      }
    } catch (e) {
      print('Error removing song: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa bài hát: $e')),
        );
      }
    }
  }

  void _playPlaylist(int index) {
    setState(() => _currentPlayingIndex = index);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NowPlayingScreen(
          song: _songs[index],
          playlist: _songs,
          currentIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.playlist.name ?? 'Playlist'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary,
                      AppColors.background,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.music_note,
                    size: 80,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_songs.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'Chưa có bài hát nào trong playlist',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final song = _songs[index];
                  return Dismissible(
                    key: Key(song.id.toString()),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) =>
                        _removeSongFromPlaylist(song, index),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song.imageUrl ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.music_note),
                        ),
                      ),
                      title: Text(
                        song.title,
                        style: TextStyle(
                          color: _currentPlayingIndex == index
                              ? AppColors.primary
                              : Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        song.artistName,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: AppColors.surface,
                            builder: (context) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.delete,
                                      color: Colors.white),
                                  title: const Text('Xóa khỏi playlist',
                                      style: TextStyle(color: Colors.white)),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _removeSongFromPlaylist(song, index);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      onTap: () => _playPlaylist(index),
                    ),
                  );
                },
                childCount: _songs.length,
              ),
            ),
        ],
      ),
      floatingActionButton: _songs.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _playPlaylist(0),
              child: const Icon(Icons.play_arrow),
            )
          : null,
    );
  }
}
