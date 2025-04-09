import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final String _baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';

  static Future<Map<String, dynamic>> register(
    String fullName, 
    String email, 
    String password
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Registration failed');
    }
  }

  static Future<Map<String, dynamic>> login(
    String email, 
    String password
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Login failed');
    }
  }
}