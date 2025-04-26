import 'dart:convert';
import 'package:http/http.dart' as http;

class Alert {
  final String timestamp;
  final String status;
  final String description;
  final double confidence;

  Alert(this.timestamp, this.status, this.description, this.confidence);

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      json['timestamp'],
      json['status'],
      json['description'],
      json['confidence'].toDouble(),
    );
  }
}


Future<List<Map<String, dynamic>>> fetchAlerts() async {
  final url = Uri.parse('http://127.0.0.1:8000/alerts');  // Adjust if different port or route
  final response = await http.get(url);
  // print('🔍 Alert Response: ${response.body}');


  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load alerts');
  }
}



