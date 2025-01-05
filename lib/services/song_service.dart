import '../models/song.dart';
import 'api_service.dart';

class SongService {
  final ApiService _apiService = ApiService();

  // Lấy tất cả bài hát
  Future<List<Song>> getAllSongs() async {
    try {
      final json = await _apiService.get('songs/list');
      return (json as List).map((item) => Song.fromJson(item)).toList();
    } catch (e) {
      print('Error in getAllSongs: $e');
      return [];
    }
  }

  // Lấy bài hát theo id
  Future<Song?> getSongById(int id) async {
    try {
      final json = await _apiService.get('songs/get-by/$id');
      return Song.fromJson(json);
    } catch (e) {
      print('Error in getSongById: $e');
      return null;
    }
  }

  // Lấy bài hát theo nghệ sĩ
  Future<List<Song>> getSongsByArtist(int artistId) async {
    try {
      final json = await _apiService.get('songs/artist/$artistId');
      return (json as List).map((item) => Song.fromJson(item)).toList();
    } catch (e) {
      print('Error in getSongsByArtist: $e');
      return [];
    }
  }

  // Lấy bài hát theo album
  Future<List<Song>> getSongsByAlbum(int albumId) async {
    try {
      final json = await _apiService.get('songs/album/$albumId');
      return (json as List).map((item) => Song.fromJson(item)).toList();
    } catch (e) {
      print('Error in getSongsByAlbum: $e');
      return [];
    }
  }

  // Lấy top bài hát được nghe nhiều
  Future<List<Song>> getTopPlayedSongs({int limit = 10}) async {
    try {
      final json = await _apiService.get('songs/top-played?limit=$limit');
      return (json as List).map((item) => Song.fromJson(item)).toList();
    } catch (e) {
      print('Error in getTopPlayedSongs: $e');
      return [];
    }
  }

  // Tăng số lần nghe
  Future<bool> incrementPlayCount(int songId) async {
    try {
      await _apiService.post('songs/$songId/increment-play', {});
      return true;
    } catch (e) {
      print('Error in incrementPlayCount: $e');
      return false;
    }
  }
}
