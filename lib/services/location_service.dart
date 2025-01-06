import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static const String apiUrl = 'https://provinces.open-api.vn/api/p';

  Future<List<Province>> getProvinces() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final provinces = data.map((json) => Province.fromJson(json)).toList();
        return provinces;
      }
      throw Exception('Failed to load provinces: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }
}

class Province {
  final int code;
  final String name;

  Province({required this.code, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      code: json['code'],
      name: json['name'],
    );
  }
}
