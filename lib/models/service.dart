import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  //static const String baseUrl = "http://10.0.2.2:8080"; // Use the working URL
  final possibleUrls = [
    'http://10.0.2.2:8080', // Android emulator
    'http://localhost:8080', // iOS simulator/desktop
    'http://192.168.1.10:8080', // Replace with your computer's IP
  ];

  Future<List<dynamic>> getDepartments() async {
    for (var baseUrl in possibleUrls) {
      final response = await http.get(Uri.parse('$baseUrl/departments'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    }
    throw Exception('Failed to load departments');
  }

  Future<dynamic> createDepartment(String name) async {
    for (var baseUrl in possibleUrls) {
      final response = await http.post(
        Uri.parse('$baseUrl/departments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name}),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
    }
    throw Exception('Failed to create department');
  }
}
