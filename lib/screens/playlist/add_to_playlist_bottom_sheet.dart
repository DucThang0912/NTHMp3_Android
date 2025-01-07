import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/song.dart';
import '../../models/playlist.dart';
import '../../services/playlist_service.dart';
import '../../constants/colors.dart';
import '../../services/song_service.dart';

class AddToPlaylistBottomSheet extends StatefulWidget {
  final Song song;

  const AddToPlaylistBottomSheet({
    super.key,
    required this.song,
  });

  @override
  State<AddToPlaylistBottomSheet> createState() =>
      _AddToPlaylistBottomSheetState();
}

class _AddToPlaylistBottomSheetState extends State<AddToPlaylistBottomSheet> {
  final PlaylistService _playlistService = PlaylistService();
  final SongService _songService = SongService();
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

  Future<void> _addToPlaylist(Playlist playlist) async {
    try {
      // Lưu bài hát vào CSDL trước
      final songId = await _songService.saveSongToDatabase(widget.song);

      // Sau đó thêm vào playlist
      await _playlistService.addSongToPlaylist(playlist.id!, songId);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Đã thêm "${widget.song.title}" vào playlist ${playlist.name}')),
        );
      }
    } catch (e) {
      print('Error adding to playlist: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi thêm vào playlist: $e')),
        );
      }
    }
  }

  void _showCreatePlaylistDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Tạo Playlist Mới',
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Tên playlist',
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Mô tả (tùy chọn)',
                labelStyle: TextStyle(color: Colors.grey),
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
                await _createAndAddToPlaylist(
                  nameController.text,
                  descriptionController.text,
                );
              }
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }

  Future<void> _createAndAddToPlaylist(String name, String description) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        throw Exception('Vui lòng đăng nhập để tạo playlist');
      }

      final playlist = await _playlistService.createPlaylist({
        'name': name,
        'description': description,
        'isPublic': true,
        'user_id': userId,
      });

      await _playlistService.addSongToPlaylist(playlist.id!, widget.song.id!);

      if (mounted) {
        Navigator.pop(context); // Đóng dialog tạo playlist
        Navigator.pop(context); // Đóng bottom sheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã tạo playlist và thêm bài hát')),
        );
      }
    } catch (e) {
      print('Error creating playlist: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Thêm vào Playlist',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const CircularProgressIndicator()
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _playlists.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      leading: const Icon(Icons.add, color: Colors.white),
                      title: const Text(
                        'Tạo playlist mới',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: _showCreatePlaylistDialog,
                    );
                  }
                  final playlist = _playlists[index - 1];
                  return ListTile(
                    leading: const Icon(Icons.queue_music, color: Colors.white),
                    title: Text(
                      playlist.name ?? 'Untitled Playlist',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () => _addToPlaylist(playlist),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
