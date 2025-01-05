import '../models/genre.dart';
import 'api_service.dart';

class GenreService {
  final ApiService _apiService = ApiService();

  // Lấy tất cả thể loại
  Future<List<Genre>> getAllGenres() async {
    final json = await _apiService.get('genres/list');
    return (json as List).map((item) => Genre.fromJson(item)).toList();
  }

  // Lấy thể loại theo id
  Future<Genre> getGenreById(int id) async {
    final json = await _apiService.get('genres/get-by/$id');
    return Genre.fromJson(json);
  }

  // Tạo thể loại mới (Yêu cầu quyền Admin)
  Future<Genre> createGenre(Genre genre) async {
    final json = await _apiService.post('genres', genre.toJson());
    return Genre.fromJson(json);
  }

  // Cập nhật thể loại (Yêu cầu quyền Admin)
  Future<Genre> updateGenre(int id, Genre genre) async {
    final json = await _apiService.post('genres/$id', genre.toJson());
    return Genre.fromJson(json);
  }

  // Xóa thể loại (Yêu cầu quyền Admin) 
  Future<void> deleteGenre(int id) async {
    await _apiService.post('genres/$id', {});
  }
}