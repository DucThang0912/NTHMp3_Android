import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  Future<dynamic> get(String endpoint) async {
    try {
      print('GET Request to: $baseUrl/$endpoint'); // Log request
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
      print('Response status: ${response.statusCode}'); // Log status code
      print('Response body: ${response.body}'); // Log response body

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
      throw Exception('Failed to load data: ${response.statusCode}');
    } catch (e) {
      print('Error during GET request: $e'); // Log error
      throw e;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      print('POST Request to: $baseUrl/$endpoint');
      print('Request body: $data');

      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
      throw Exception('Failed to create data: ${response.statusCode}');
    } catch (e) {
      print('Error during POST request: $e');
      throw e;
    }
  }
}
