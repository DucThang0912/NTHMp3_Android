import '../models/playlist.dart';
import 'api_service.dart';

class PlaylistService {
  final ApiService _apiService = ApiService();

  Future<List<Playlist>> getUserPlaylists(int userId) async {
    final json = await _apiService.get('users/$userId/playlists');
    return (json as List).map((item) => Playlist.fromJson(item)).toList();
  }

  Future<Playlist> createPlaylist(Map<String, dynamic> playlistData) async {
    final json = await _apiService.post('playlists', playlistData);
    return Playlist.fromJson(json);
  }

  Future<void> addSongToPlaylist(int playlistId, int songId) async {
    await _apiService.post('playlists/$playlistId/songs', {'songId': songId});
  }
}
