import 'package:flutter/material.dart';
import 'package:nthmusicmp3/models/playlist.dart';
import '../../constants/colors.dart';
import 'playlist_details_screen.dart';
import 'package:nthmusicmp3/services/playlist_service.dart';

class PlaylistScreen extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback onDeleted;
  final PlaylistService _playlistService = PlaylistService();

  PlaylistScreen({
    super.key,
    required this.playlist,
    required this.onDeleted,
  });

  Future<void> _deletePlaylist(BuildContext context) async {
    try {
      await _playlistService.deletePlaylist(playlist.id!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa playlist')),
        );
        onDeleted();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa playlist: $e')),
        );
      }
    }
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title:
            const Text('Xóa Playlist', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Bạn có chắc chắn muốn xóa playlist này?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePlaylist(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistDetailsScreen(playlist: playlist),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppColors.mainGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.queue_music,
              color: Colors.white,
              size: 30,
            ),
          ),
          title: Text(
            playlist.name ?? 'Untitled Playlist',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            playlist.description ?? '',
            style: TextStyle(color: Colors.grey[400]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () => _showDeleteConfirmDialog(context),
          ),
        ),
      ),
    );
  }
}
