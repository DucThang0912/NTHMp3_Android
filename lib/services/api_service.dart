import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String get baseUrl {
    print('Platform.isAndroid: ${Platform.isAndroid}');

    if (Platform.isAndroid) {
      try {
        // Thử kết nối với localhost trước
        return 'http://10.0.2.2:8080/api';
      } catch (e) {
        // Nếu không kết nối được, sử dụng IP thật
        return 'http://192.168.1.104:8080/api';
      }
    }
    return 'http://localhost:8080/api';
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
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );

      // Chấp nhận cả status 200 và 201
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in POST request: $e');
      rethrow;
    }
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

  // Xóa dữ liệu
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _getHeaders(),
      );
      // Chấp nhận cả status 200 và 204 cho DELETE request
      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body.isEmpty ? null : jsonDecode(response.body);
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in DELETE request: $e');
      rethrow;
    }
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
