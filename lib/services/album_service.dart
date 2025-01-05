import '../models/album.dart';
import 'api_service.dart';

class AlbumService {
  final ApiService _apiService = ApiService();

  // Lấy tất cả album
  Future<List<Album>> getAllAlbums() async {
    try {
      final json = await _apiService.get('albums/list');
      return (json as List).map((item) => Album.fromJson(item)).toList();
    } catch (e) {
      print('Error in getAllAlbums: $e');
      return [];
    }
  }

  // Lấy album theo id
  Future<Album?> getAlbumById(int id) async {
    try {
      final json = await _apiService.get('albums/get-by/$id');
      return Album.fromJson(json);
    } catch (e) {
      print('Error in getAlbumById: $e');
      return null;
    }
  }

  // Lấy album theo nghệ sĩ
  Future<List<Album>> getAlbumsByArtist(int artistId) async {
    try {
      final json = await _apiService.get('albums/artist/$artistId');
      return (json as List).map((item) => Album.fromJson(item)).toList();
    } catch (e) {
      print('Error in getAlbumsByArtist: $e');
      return [];
    }
  }

  // Lấy album theo năm
  Future<List<Album>> getAlbumsByYear(int year) async {
    try {
      final json = await _apiService.get('albums/year/$year');
      return (json as List).map((item) => Album.fromJson(item)).toList();
    } catch (e) {
      print('Error in getAlbumsByYear: $e');
      return [];
    }
  }
} 