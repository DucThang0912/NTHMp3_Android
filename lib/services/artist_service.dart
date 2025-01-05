import '../models/artist.dart';
import '../models/album.dart';
import '../models/song.dart';
import 'api_service.dart';

class ArtistService {
  final ApiService _apiService = ApiService();

  // Lấy tất cả nghệ sĩ
  Future<List<Artist>> getAllArtists() async {
    try {
      final json = await _apiService.get('artists/list');
      return (json as List).map((item) => Artist.fromJson(item)).toList();
    } catch (e) {
      print('Error in getAllArtists: $e');
      return [];
    }
  }

  // Lấy nghệ sĩ theo id
  Future<Artist?> getArtistById(int id) async {
    try {
      final json = await _apiService.get('artists/get-by/$id');
      return Artist.fromJson(json);
    } catch (e) {
      print('Error in getArtistById: $e');
      return null;
    }
  }

  // Lấy danh sách bài hát của nghệ sĩ
  Future<List<Song>> getArtistSongs(int artistId) async {
    try {
      final json = await _apiService.get('artists/$artistId/songs');
      return (json as List).map((item) => Song.fromJson(item)).toList();
    } catch (e) {
      print('Error in getArtistSongs: $e');
      return [];
    }
  }

  // Lấy danh sách album của nghệ sĩ
  Future<List<Album>> getArtistAlbums(int artistId) async {
    try {
      final json = await _apiService.get('artists/$artistId/albums');
      return (json as List).map((item) => Album.fromJson(item)).toList();
    } catch (e) {
      print('Error in getArtistAlbums: $e');
      return [];
    }
  }
} 