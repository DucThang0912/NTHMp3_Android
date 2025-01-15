import 'api_service.dart';
import '../models/song.dart';

class PlayHistoryService {
  final ApiService _apiService = ApiService();

  // Thêm bài hát vào lịch sử nghe
  Future<void> addToHistory(String spotifyId) async {
    try {
      await _apiService.post('history/add/$spotifyId', {});
    } catch (e) {
      print('Error adding to history: $e');
      rethrow;
    }
  }

  // Lấy lịch sử nghe của người dùng
  Future<List<Song>> getUserHistory() async {
    try {
      final json = await _apiService.get('history/user');
      return (json as List).map((item) => Song.fromJson(item['song'])).toList();
    } catch (e) {
      print('Error getting user history: $e');
      return [];
    }
  }

  // Xóa lịch sử nghe
  Future<void> clearHistory() async {
    try {
      await _apiService.delete('history/clear');
    } catch (e) {
      print('Error clearing history: $e');
      rethrow;
    }
  }

  // Toggle yêu thích bài hát
  Future<bool> toggleFavorite(String spotifyId) async {
    try {
      if (spotifyId.isEmpty) {
        throw Exception('SpotifyId không được rỗng');
      }

      final response = await _apiService.post(
        'history/favorite/toggle/$spotifyId',
        {},
      );

      return response == true;
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }

  // Lấy danh sách bài hát yêu thích
  Future<List<Song>> getFavorites() async {
    try {
      final json = await _apiService.get('history/favorites');
      print('Raw favorites response: $json'); // Debug log

      if (json == null) return [];

      final List<Song> favorites = [];
      for (var item in json) {
        if (item is Map) {
          // Nếu response có cấu trúc { song: {...} }
          final songData = item.containsKey('song') ? item['song'] : item;
          try {
            final song = Song.fromJson(songData);
            if (song.spotifyId.isNotEmpty) {
              favorites.add(song);
            }
          } catch (e) {
            print('Error parsing song: $e');
          }
        }
      }

      print('Parsed favorites: ${favorites.map((s) => s.spotifyId).toList()}');
      return favorites;
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }
}
