import 'package:nthmusicmp3/models/user.dart';
import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final ApiService _apiService = ApiService();

  // Lấy thông tin người dùng
  Future<User> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username == null) {
      throw Exception('Chưa đăng nhập');
    }

    final response = await _apiService.get('users/username/$username');
    return User.fromJson(response);
  }

  // Cập nhật thông tin người dùng
  Future<void> updateProfile(User user) async {
    final response =
        await _apiService.put('users/${user.id}/profile', user.toJson());
    // Không cần xử lý response vì server không trả về data
    print('Response: $response');
  }

  // Thay đổi mật khẩu
  Future<void> changePassword(
      int userId, String oldPassword, String newPassword) async {
    await _apiService.put('users/$userId/change-password', {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
  }
}
