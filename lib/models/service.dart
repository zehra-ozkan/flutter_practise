import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080"; // Use the working URL

  Future<List<dynamic>> getDepartments() async {
    final response = await http.get(Uri.parse('$baseUrl/departments'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load departments');
    }
  }

  Future<dynamic> createDepartment(String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/departments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create department');
    }
  }
}
