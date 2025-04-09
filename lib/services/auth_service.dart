import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final String _baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';

  // Register new user
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'token': responseData['token'],
          'user': responseData['user'],
        };
      } else {
        throw responseData['error'] ?? 'Registration failed';
      }
    } catch (e) {
      throw 'Network error: $e';
    }
  }

  // Login existing user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'token': responseData['token'],
          'user': responseData['user'],
        };
      } else {
        throw responseData['error'] ?? 'Login failed';
      }
    } catch (e) {
      throw 'Network error: $e';
    }
  }
}