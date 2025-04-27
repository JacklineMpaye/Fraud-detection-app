import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// FraudAlert Model
class FraudAlert {
  final String transactionId;
  final double amount;
  final double fraudProbability;
  final DateTime timestamp;
  final bool resolved;

  FraudAlert({
    required this.transactionId,
    required this.amount,
    required this.fraudProbability,
    required this.timestamp,
    required this.resolved,
  });

  String get alertType => fraudProbability > 0.85 ? 'Fraud Detected' : 'Suspicious Activity';
  String get status => resolved ? 'Resolved' : 'Unresolved';

  factory FraudAlert.fromJson(Map<String, dynamic> json) {
    return FraudAlert(
      transactionId: (json['transaction_id'] ?? json['transactionId'] ?? 'Unknown').toString(),
      amount: (json['amount'] is int || json['amount'] is double)
          ? json['amount'].toDouble()
          : double.tryParse(json['amount'].toString()) ?? 0.0,
      fraudProbability: (json['fraud_prob'] is int || json['fraud_prob'] is double)
          ? json['fraud_prob'].toDouble()
          : double.tryParse(json['fraud_prob'].toString()) ?? 0.0,
      timestamp: DateTime.tryParse(json['timestamp'] ?? json['created_at'] ?? '') ?? DateTime.now(),
      resolved: json['resolved'] ?? false,
    );
  }
}

// Alert Management Page
class AlertManagementPage extends StatefulWidget {
  const AlertManagementPage({super.key});

  @override
  State<AlertManagementPage> createState() => _AlertManagementPageState();
}

class _AlertManagementPageState extends State<AlertManagementPage> {
  String selectedAlertType = 'All';
  String selectedAlertStatus = 'All';
  final List<String> _alertTypes = ['All', 'Fraud Detected', 'Suspicious Activity'];
  final List<String> _statusTypes = ['All', 'Resolved', 'Unresolved'];

  // 📡 Fetch Alerts from Backend
  Future<List<FraudAlert>> fetchAlerts() async {
    final response = await http.get(Uri.parse('http://159.203.99.109:8000/alerts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => FraudAlert.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load alerts');
    }
  }

  List<FraudAlert> _filter(List<FraudAlert> alerts) {
    return alerts.where((alert) {
      final matchesType = selectedAlertType == 'All' || alert.alertType == selectedAlertType;
      final matchesStatus = selectedAlertStatus == 'All' || alert.status == selectedAlertStatus;
      return matchesType && matchesStatus;
    }).toList();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getProbabilityColor(double prob) {
    if (prob > 0.85) return Colors.red;
    if (prob > 0.7) return Colors.orange;
    return Colors.yellow;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2029),
      appBar: AppBar(
        title: const Text('Fraud Alert Management'),
        backgroundColor: const Color(0xFF1F2029),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
            tooltip: 'Refresh alerts',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF2D2F3D),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    dropdownColor: const Color(0xFF2D2F3D),
                    decoration: const InputDecoration(
                      labelText: 'Alert Type',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    value: selectedAlertType,
                    items: _alertTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAlertType = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    dropdownColor: const Color(0xFF2D2F3D),
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    value: selectedAlertStatus,
                    items: _statusTypes.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAlertStatus = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Alert List
          Expanded(
            child: FutureBuilder<List<FraudAlert>>(
              future: fetchAlerts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                } else if (snapshot.hasData) {
                  final filtered = _filter(snapshot.data!);
                  if (filtered.isEmpty) {
                    return const Center(child: Text('No alerts found', style: TextStyle(color: Colors.white70)));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final alert = filtered[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        color: const Color(0xFF2D2F3D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: alert.fraudProbability > 0.85
                                ? Colors.red.withOpacity(0.5)
                                : Colors.orange.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: const Color(0xFF2D2F3D),
                                title: Text(
                                  alert.alertType,
                                  style: TextStyle(
                                    color: alert.fraudProbability > 0.85 ? Colors.red : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Transaction ID: ${alert.transactionId}", style: const TextStyle(color: Colors.white70)),
                                    Text("Amount: GHS${alert.amount}", style: const TextStyle(color: Colors.white)),
                                    Text("Confidence: ${(alert.fraudProbability * 100).toStringAsFixed(1)}%", style: TextStyle(color: _getProbabilityColor(alert.fraudProbability))),
                                    Text("Status: ${alert.status}", style: TextStyle(color: alert.resolved ? Colors.green : Colors.red)),
                                    Text("Date: ${_formatDate(alert.timestamp)}", style: const TextStyle(color: Colors.white70)),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(alert.alertType, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text("Transaction ID: ${alert.transactionId}", style: const TextStyle(color: Colors.white70)),
                                const SizedBox(height: 4),
                                Text("Amount: GHS${alert.amount}", style: const TextStyle(color: Colors.white70)),
                                const SizedBox(height: 4),
                                Text("Confidence: ${(alert.fraudProbability * 100).toStringAsFixed(1)}%", style: const TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
