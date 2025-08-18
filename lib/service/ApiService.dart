import 'dart:async';
import 'dart:convert';
import 'package:fitness/models/User.dart';
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

  Future<User> getCurrentUser(String sessionId) async {
    try {
      try {
        final testResponse = await http
            .get(Uri.parse('$baseUrl/'))
            .timeout(Duration(seconds: 5));
        print("Backend reachable: ${testResponse.statusCode}");
      } catch (e) {
        print("Cannot reach backend: $e");
      }
      final response = await http
          .get(
            Uri.parse('$baseUrl/current-user'),
            headers: {'Session-ID': sessionId}, // Critical: Include session ID
          )
          .timeout(const Duration(seconds: 5));

      switch (response.statusCode) {
        case 200:
          print("I have successfully reached here");
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          return User.fromJson(json);

        default:
          throw Exception(
            'Server error=====================================0: ${response.statusCode}',
          );
      }
    } on TimeoutException {
      throw TimeoutException('Connection timed out');
    } on http.ClientException {
      throw Exception('Network error');
    }
  }

  Future<dynamic> getUserByName(String name) async {
    final response = await http
        .get(Uri.parse('$baseUrl/app_users/name/$name'))
        .timeout(Duration(seconds: 5)); //what happens if not found?
    if (response.statusCode == 200) {
      //200 means successfull
      print("successfully fetched the user");
      return jsonDecode(response.body);
    }
    print("status code === ");
    print(response.statusCode);
    throw Exception('Failed to load USER');
  }

  Future<Map<String, dynamic>> validateLogin(
    String name,
    String password,
  ) async {
    final credentials = {'username': name, 'password': password};
    final response = await http
        .post(
          Uri.parse('$baseUrl/app_users/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(credentials),
        )
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      final responseBody = json.decode(
        response.body,
      ); //responseda boolean key var onu çekiyor
      final userId = responseBody['userId']; // Extract user ID
      return {
        'success': true,
        'userId': userId,
        'sessionId': responseBody['sessionId'],
      };
      //return responseBody['success'] as bool; // Extract the boolean
    } else if (response.statusCode == 401) {
      return {
        'success': false,
        'userId': -1,
        'sessionId': "-1",
      }; //this means wrong something
    } else {
      return {
        'success': false,
        'userId': -1,
        'sessionId': "-1",
      }; //this means wrong something
    }
  }

  Future<Map<String, dynamic>> validateRegistration(
    String name,
    String password,
    DateTime date,
  ) async {
    try {
      final credentials = {
        'username': name,
        'password': password,
        'date': date.toIso8601String(),
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/app_users/register'), // Use the correct IP
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(credentials),
          )
          .timeout(Duration(seconds: 10)); // Increase timeout

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return {'success': true, 'userId': responseBody['userId']};
      } else if (response.statusCode == 401) {
        return {'success': false, 'userId': -1};
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timed out. Check server or network.');
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }
}
