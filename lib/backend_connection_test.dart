import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  // Try all possible URLs
  final possibleUrls = [
    'http://10.0.2.2:8080', // Android emulator
    'http://localhost:8080', // iOS simulator/desktop
    'http://192.168.1.10:8080', // Replace with your computer's IP
  ];

  for (var baseUrl in possibleUrls) {
    print('\nAttempting connection to: $baseUrl');

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/departments'))
          .timeout(Duration(seconds: 5));

      print('✅ Success! Status: ${response.statusCode}');
      print('Response: ${response.body}');
      return;
    } on SocketException catch (e) {
      print('🔴 Connection failed: ${e.message}');
    } on TimeoutException catch (_) {
      print('🕒 Request timed out');
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  print('\n🔴🔴🔴 All connection attempts failed. Troubleshooting:');
  print('1. Ensure Spring Boot is running');
  print('2. Verify no firewall is blocking connections');
  print('3. For physical device testing:');
  print('   - Use your computer\'s local IP address');
  print('   - Ensure device and computer are on same network');
  print('4. For Android emulator: use 10.0.2.2');
  print('5. For iOS simulator: use localhost');
}
