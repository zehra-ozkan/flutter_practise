import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:fitness/models/User.dart';
import 'package:fitness/models/friends_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  final String baseUrl = dotenv.get('API_BASE_URL');
  ApiService();

  Future<Map<String, dynamic>> fetchUserProfile(String token) async {
    print("token just before sending request is : " + token);
    print("");
    _printCurrentOrigin();

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

      String str = responseBody["picture"];
      Uint8List? bytes;
      if (str != "") {
        bytes = base64Decode(str);
      } else {
        bytes = null;
      }

      return {'userName': name, 'birthday': birthday, 'picture': bytes};
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<String?> validateLogin(String name, String password) async {
    //this returns the token
    _printCurrentOrigin();
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

  Future<void> uploadProfileImage(String token, String path) async {
    print("token just before sending request is : $token");
    print("");

    try {
      final uri = Uri.parse("$baseUrl/user_profiles/updatePic");
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';

      var pic = await http.MultipartFile.fromPath("file", path);
      request.files.add(pic);

      var response = await request.send();

      if (response.statusCode == 200) {
        print("Image uploaded");
      } else {
        print("Image not uploaded");
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<Map<String, dynamic>> getUserFriends(String token) async {
    _printCurrentOrigin();
    print("token just before sending request is : " + token);
    print("");

    final response = await http.get(
      Uri.parse('$baseUrl/app_users/friends/top'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      int count = responseBody["count"];

      List<dynamic> bb = responseBody["friends"];
      return {'count': count, 'friends': bb};
    } else {
      throw Exception('Failed to load user friends');
    }
  }

  void _printCurrentOrigin() {
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

  Future<Map<String, dynamic>> getUserPosts(String token) async {
    _printCurrentOrigin();
    print("token just before sending MY POSTS request is : " + token);
    print("");

    final response = await http.get(
      Uri.parse('$baseUrl/posts/my_posts'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      int count = responseBody["count"];

      List<dynamic> bb = responseBody["posts"];
      return {'count': count, 'posts': bb};
    } else {
      throw Exception('Failed to load user friends');
    }
  }

  addNewPost(String token, String path, String text) async {
    try {
      final uri = Uri.parse("$baseUrl/posts/new_post");
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';

      var pic = await http.MultipartFile.fromPath("file", path);
      request.files.add(pic);
      request.fields["postText"] = text;

      var response = await request.send();

      if (response.statusCode == 200) {
        //final responseBody = json.decode(response.body);
        return {'success': true};
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
