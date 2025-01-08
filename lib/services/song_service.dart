import '../models/song.dart';
import 'api_service.dart';

class SongService {
  final ApiService _apiService = ApiService();

  // Lưu bài hát Spotify vào CSDL
  Future<int> saveSongToDatabase(Song song) async {
    try {
      final response = await _apiService.post('songs', {
        'spotifyId': song.spotifyId,
        'title': song.title,
        'artistName': song.artistName,
        'albumTitle': song.albumTitle,
        'genreName': song.genreName,
        'duration': song.duration,
        'filePath': song.filePath,
        'imageUrl': song.imageUrl,
        'playCount': 0,
        'lyrics': song.lyrics,
      });

      if (response != null) {
        return response['id'];
      }
      throw Exception('Không thể lưu bài hát');
    } catch (e) {
      print('Error saving song: $e');
      rethrow;
    }
  }

  // Cập nhật số lần phát
  Future<void> incrementPlayCount(String spotifyId) async {
    try {
      await _apiService.put('songs/play-count/$spotifyId', {});
    } catch (e) {
      print('Error incrementing play count: $e');
      rethrow;
    }
  }

  // Lấy thông tin bài hát theo spotifyId
  Future<Song> getSongBySpotifyId(String spotifyId) async {
    try {
      final response = await _apiService.get('songs/spotify/$spotifyId');
      return Song.fromJson(response);
    } catch (e) {
      print('Error getting song: $e');
      rethrow;
    }
  }
}
