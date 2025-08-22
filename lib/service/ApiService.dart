import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:fitness/models/User.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  //TODO maybe different services for different tables?
  final String baseUrl = dotenv.get('API_BASE_URL');
  ApiService();

  Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/app_users'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load departments for users');
  }

  Future<Map<String, dynamic>> fetchUserProfile(String token) async {
    print("token just before sending request is : " + token);
    print("");
    printCurrentOrigin();
    final response = await http.get(
      Uri.parse('$baseUrl/app_users/home'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      String name = responseBody["userName"];
      String birthday = responseBody["birthday"];

      return {'userName': name, 'birthday': birthday};
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<String?> validateLogin(String name, String password) async {
    //this returns the token
    try {
      final credentials = {'userName': name, 'user_password': password};
      final response = await http
          .post(
            Uri.parse('$baseUrl/app_users/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(credentials),
          )
          .timeout(Duration(seconds: 5));

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody["success"] == true) {
          await _storage.write(key: 'jwt', value: responseBody["token"]);
          return responseBody["token"];
        } else {
          print("Login failed: success=false");
          return null;
        }
      } else if (response.statusCode == 401) {
        print("Unauthorized: Invalid credentials");
        return null;
      } else {
        print("Server error: ${response.statusCode}");
        throw Exception('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      print("Request timeout");
      throw Exception('Connection timeout');
    } on http.ClientException catch (e) {
      print("Client exception: $e");
      throw Exception('Network error: $e');
    } catch (e) {
      print("Unexpected error: $e");
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>> validateRegistration(
    String userName,
    String password,
    DateTime date,
  ) async {
    try {
      final credentials = {
        'userName': userName,
        'user_password': password,
        'birthday': date.toIso8601String(),
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

  void printCurrentOrigin() {
    if (kIsWeb) {
      // For web, we need to use dart:html but only in web context
      print('Web app running');
      // Note: We can't directly use window.location in non-web environments
    } else {
      // For mobile/desktop
      print('Mobile/Desktop app running');
    }
    print('App is trying to connect to: http://192.168.1.10:8080');
  }
}
