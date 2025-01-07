import '../models/playlist.dart';
import '../models/song.dart';
import 'api_service.dart';

class PlaylistService {
  final ApiService _apiService = ApiService();

  // Lấy tất cả playlist của user
  Future<List<Playlist>> getUserPlaylists(int userId) async {
    final json = await _apiService.get('playlists/user/id/$userId');
    return (json as List).map((item) => Playlist.fromJson(item)).toList();
  }

  // Lấy playlist theo username
  Future<List<Playlist>> getUserPlaylistsByUsername(String username) async {
    try {
      print('Getting playlists for username: $username'); // Debug log
      final json = await _apiService.get('playlists/user/name/$username');
      print('Response: $json'); // Debug log
      return (json as List).map((item) => Playlist.fromJson(item)).toList();
    } catch (e) {
      print('Error getting playlists: $e'); // Debug log
      return [];
    }
  }

  // Lấy playlist công khai
  Future<List<Playlist>> getPublicPlaylists() async {
    final json = await _apiService.get('playlists/public');
    return (json as List).map((item) => Playlist.fromJson(item)).toList();
  }

  // Tạo playlist mới
  Future<Playlist> createPlaylist(Map<String, dynamic> playlistData) async {
    try {
      print('Creating playlist with data: $playlistData');
      final response = await _apiService.post('playlists/create', playlistData);

      // Status 201 là Created - thành công
      if (response != null) {
        return Playlist.fromJson(response);
      } else {
        throw Exception('Không thể tạo playlist');
      }
    } catch (e) {
      print('Error in createPlaylist: $e');
      rethrow;
    }
  }

  // Xóa playlist
  Future<void> deletePlaylist(int playlistId) async {
    await _apiService.delete('playlists/delete/$playlistId');
  }

  // ------------------------------------------------------------------------------------

  // Thêm bài hát vào playlist
  Future<void> addSongToPlaylist(int playlistId, int songId) async {
    try {
      print('Adding song $songId to playlist $playlistId'); // Debug log
      final response = await _apiService.post(
          'playlists/$playlistId/songs/$songId', // Sửa lại endpoint theo đúng format
          {} // Body rỗng vì thông tin đã nằm trong URL
          );
      print('Response: $response'); // Debug log
    } catch (e) {
      print('Error adding song to playlist: $e');
      rethrow;
    }
  }

  // Xóa bài hát khỏi playlist
  Future<void> removeSongFromPlaylist(int playlistId, String songId) async {
    try {
      print('Removing song $songId from playlist $playlistId'); // Debug log
      await _apiService.delete('playlists/$playlistId/songs/$songId');
    } catch (e) {
      print('Error in removeSongFromPlaylist: $e');
      rethrow;
    }
  }

  // Lấy danh sách bài hát trong playlist
  Future<List<Song>> getPlaylistSongs(int playlistId) async {
    try {
      print('Getting songs for playlist: $playlistId'); // Debug log
      final json = await _apiService.get('playlists/$playlistId/songs');
      print(
          'Response from getPlaylistSongs: $json'); // Thêm log để xem response

      if (json == null) return [];

      return (json as List).map((item) {
        print('Song item from playlist: $item'); // Thêm log để xem từng item
        final song = Song.fromJson(item);
        print('Parsed song id: ${song.id}'); // Kiểm tra id sau khi parse
        return song;
      }).toList();
    } catch (e) {
      print('Error in getPlaylistSongs: $e');
      return [];
    }
  }
}
