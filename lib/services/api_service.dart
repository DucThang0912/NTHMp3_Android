import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String get baseUrl {
    const bool isPhysicalDevice = bool.fromEnvironment('PHYSICAL_DEVICE');
    if (isPhysicalDevice) {
      return 'http://192.168.1.104:8080/api'; 
    }
    return 'http://10.0.2.2:8080/api'; // Địa chỉ cho máy ảo
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }

  // Lấy dữ liệu từ server
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  // Gửi dữ liệu đến server
  Future<dynamic> post(String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // Cập nhật thông tin người dùng
  Future<dynamic> put(String endpoint, dynamic data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // Xử lý response từ server
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }
    throw Exception('Request failed with status: ${response.statusCode}');
  }
}
