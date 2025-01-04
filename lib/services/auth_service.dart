import '../models/auth/login_request.dart';
import '../models/auth/signup_request.dart';
import '../models/auth/jwt_response.dart';
import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String TOKEN_KEY = 'jwt_token';
  final SharedPreferences _prefs;
  final ApiService _apiService = ApiService();

  AuthService(this._prefs);

  Future<JwtResponse> login(LoginRequest request) async {
    final response = await _apiService.post('auth/login', request.toJson());
    return JwtResponse.fromJson(response);
  }

  Future<bool> register(SignupRequest request) async {
    try {
      final response = await _apiService.post('auth/signup', request.toJson());
      // Kiểm tra response là String hay Map
      if (response is String) {
        return response.contains("successfully");
      } else if (response is Map) {
        return response['message']?.contains("successfully") ?? false;
      }
      return false;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  // Lưu token vào local storage
  Future<void> saveToken(String token) async {
    await _prefs.setString(TOKEN_KEY, token);
  }

  // Kiểm tra token có hợp lệ không
  Future<bool> isAuthenticated() async {
    final token = _prefs.getString(TOKEN_KEY);
    return token != null && token.isNotEmpty;
  }

  // Lấy token
  String? getToken() {
    return _prefs.getString(TOKEN_KEY);
  }

  // Đăng xuất
  Future<void> logout() async {
    await _prefs.remove(TOKEN_KEY);
  }
}
