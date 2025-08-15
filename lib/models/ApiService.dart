import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  //TODO maybe different services for different tables?
  final String baseUrl = dotenv.get('API_BASE_URL');
  ApiService();

  Future<List<dynamic>> getDepartments() async {
    final response = await http.get(Uri.parse('$baseUrl/departments'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load departments');
  }

  Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/app_users'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load departments for users');
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

  //TODO check this part
  Future<dynamic> createUser(
    String name,
    DateTime date,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/app_users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_name': name,
        'user_password': password,
        'birthday': date,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to create USER');
  }

  Future<dynamic> getDepartmentById(int id) async {
    final response = await http
        .get(Uri.parse('$baseUrl/departments/$id'))
        .timeout(Duration(seconds: 5)); //what happens if not found?
    if (response.statusCode == 200) {
      //200 means successfull

      return jsonDecode(response.body);
    }
    throw Exception('Failed to load departments');
  }

  Future<dynamic> getUserbyId(int id) async {
    final response = await http
        .get(Uri.parse('$baseUrl/app_users/$id'))
        .timeout(Duration(seconds: 5)); //what happens if not found?
    if (response.statusCode == 200) {
      //200 means successfull

      return jsonDecode(response.body);
    }
    throw Exception('Failed to load USER');
  }

  Future<dynamic> getUserByName(String name) async {
    final response = await http
        .get(Uri.parse('$baseUrl/app_users/name/$name'))
        .timeout(Duration(seconds: 5)); //what happens if not found?
    if (response.statusCode == 200) {
      //200 means successfull

      return jsonDecode(response.body);
    }
    throw Exception('Failed to load USER');
  }

  Future<bool> validateLogin(String name, String password) async {
    final credentials = {'username': name, 'passwordHash': password};
    final response = await http
        .post(
          Uri.parse('$baseUrl/app_users/login'),
          body: jsonEncode(credentials),
        )
        .timeout(Duration(seconds: 5));
    if (response.statusCode == 200) return json.decode(response.body);
    return false;
  }
}
