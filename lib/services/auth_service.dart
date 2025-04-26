import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static final String _baseUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';

  // Register new user (original working version)
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/register');
    final body = {
      'fullName': fullName,
      'email': email,
      'password': password,
    };

    final stopwatch = Stopwatch()..start();
    try {
      if (kDebugMode) {
        print('➡️ [REGISTER] Calling: $uri');
        print('➡️ [REGISTER] Payload: ${jsonEncode(body)}');
      }

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      stopwatch.stop();
      if (kDebugMode) {
        print('⬅️ [REGISTER] Status Code: ${response.statusCode}');
        print('⬅️ [REGISTER] Response: ${response.body}');
        print('⏱️ [REGISTER] Time: ${stopwatch.elapsedMilliseconds}ms');
      }

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
      stopwatch.stop();
      if (kDebugMode) {
        print('❌ [REGISTER] Error: $e');
      }
      throw 'Registration error: $e';
    }
  }

  // Login existing user (original working version)
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/login');
    final body = {
      'email': email,
      'password': password,
    };

    final stopwatch = Stopwatch()..start();
    try {
      if (kDebugMode) {
        print('➡️ [LOGIN] Calling: $uri');
        print('➡️ [LOGIN] Payload: ${jsonEncode(body)}');
      }

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      stopwatch.stop();
      if (kDebugMode) {
        print('⬅️ [LOGIN] Status Code: ${response.statusCode}');
        print('⬅️ [LOGIN] Response: ${response.body}');
        print('⏱️ [LOGIN] Time: ${stopwatch.elapsedMilliseconds}ms');
      }

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Store token and user data securely
        await _storage.write(
          key: 'auth_token',
          value: responseData['token'],
        );
        await _storage.write(
          key: 'user_data',
          value: jsonEncode(responseData['user']),
        );
        
        return {
          'success': true,
          'token': responseData['token'],
          'user': responseData['user'],
        };
      } else {
        throw responseData['error'] ?? 'Login failed';
      }
    } catch (e) {
      stopwatch.stop();
      if (kDebugMode) {
        print('❌ [LOGIN] Error: $e');
      }
      throw 'Login error: $e';
    }
  }

  // Sign out user
  static Future<void> signOut() async {
    try {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'user_data');
    } catch (e) {
      if (kDebugMode) {
        print('❌ [SIGNOUT] Error: $e');
      }
      rethrow;
    }
  }

  // Get current auth token
  static Future<String?> getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null;
  }

  // Get current user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final userData = await _storage.read(key: 'user_data');
    return userData != null ? jsonDecode(userData) : null;
  }
}