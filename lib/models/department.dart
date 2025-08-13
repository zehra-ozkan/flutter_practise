import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

class Department {
  final String uri = "";
  final int id;
  final String name;
  static String baseUrl = dotenv.get('API_BASE_URL');

  Department({required this.id, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  static Future<Department> getDepartmentById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/departments/$id'))
          .timeout(Duration(seconds: 5));

      final obj = jsonDecode(response.body);

      Department dp = Department(id: obj['id'], name: obj['name']);

      print('✅ Success! Status: ${response.statusCode}');
      print('Response: ${response.body}');
      return dp;
    } on SocketException catch (e) {
      print('🔴 Connection failed: ${e.message}');
    } on TimeoutException catch (_) {
      print('🕒 Request timed out');
    } catch (e) {
      print('❌ Error: $e');
    }
    throw "Unable to retrieve stock data.";
  }

  static Future<bool> isValid(int id, String name) async {
    try {
      Department dp = await getDepartmentById(id);
      return name == dp.name;
    } catch (e) {
      print('❌ Error in isValid: $e');
      return false;
    }
  }
}
