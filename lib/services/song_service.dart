import '../models/song.dart';
import 'api_service.dart';

class SongService {
  final ApiService _apiService = ApiService();

  Future<List<Song>> getAllSongs() async {
    final json = await _apiService.get('songs');
    return (json as List).map((item) => Song.fromJson(item)).toList();
  }

  Future<Song> getSongById(int id) async {
    final json = await _apiService.get('songs/$id');
    return Song.fromJson(json);
  }

  Future<List<Song>> getSongsByArtist(int artistId) async {
    final json = await _apiService.get('artists/$artistId/songs');
    return (json as List).map((item) => Song.fromJson(item)).toList();
  }
}
