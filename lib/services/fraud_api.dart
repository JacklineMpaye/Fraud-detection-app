// lib/services/fraud_api.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class FraudAPI {
  static const String _baseUrl = "http://your-fastapi-ip:8000";

  static Future<double> checkFraud(Map<String, dynamic> transaction) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transaction),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['fraud_probability'];
    } else {
      throw Exception('Failed to detect fraud');
    }
  }
}