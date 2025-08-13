import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  String baseUrl = dotenv.get('API_BASE_URL');

  Future<List<dynamic>> getDepartments() async {
    final response = await http.get(Uri.parse('$baseUrl/departments'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load departments');
  }

  Future<dynamic> createDepartment(String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/departments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to create department');
  }
}
