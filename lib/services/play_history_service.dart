import 'api_service.dart';
import '../models/song.dart';

class PlayHistoryService {
  final ApiService _apiService = ApiService();

  // Thêm bài hát vào lịch sử nghe
  Future<void> addToHistory(int songId) async {
    try {
      await _apiService.post('history/add/$songId', {});
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
  Future<bool> toggleFavorite(int songId) async {
    try {
      final response =
          await _apiService.post('history/favorite/toggle/$songId', {});
      return response as bool;
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }

  // Lấy danh sách bài hát yêu thích
  Future<List<Song>> getFavorites() async {
    try {
      final json = await _apiService.get('history/favorites');
      return (json as List).map((item) => Song.fromJson(item['song'])).toList();
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }
}
