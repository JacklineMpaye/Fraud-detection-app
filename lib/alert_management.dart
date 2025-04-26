<<<<<<< HEAD
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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



=======
import 'package:flutter/material.dart';
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f

class AlertManagementPage extends StatefulWidget {
  const AlertManagementPage({super.key});

  @override
<<<<<<< HEAD
  State<AlertManagementPage> createState() => _AlertManagementPageState();
}

class _AlertManagementPageState extends State<AlertManagementPage> {
  String selectedAlertType = 'All';
  String selectedAlertStatus = 'All';
  final List<String> _alertTypes = ['All', 'Fraud Detected', 'Suspicious Activity'];
  final List<String> _statusTypes = ['All', 'Resolved', 'Unresolved'];

  Future<List<FraudAlert>> fetchAlerts() async {
    final response = await http.get(Uri.parse('http://localhost:8000/alerts'));

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
=======
  _AlertManagementPageState createState() => _AlertManagementPageState();
}

class _AlertManagementPageState extends State<AlertManagementPage> {
  // Filter states
  String selectedAlertType = 'All';
  String selectedAlertStatus = 'All';

  // Example alert data (replace with real data from your backend)
  final List<Map<String, String>> alerts = [
    {
      'id': '1',
      'date': '12 May 2024',
      'time': '04:49 PM',
      'type': 'Flagged Transaction',
      'status': 'Unresolved',
      'description': 'Transaction flagged as potential phishing.',
    },
    {
      'id': '2',
      'date': '12 May 2024',
      'time': '05:49 PM',
      'type': 'System Warning',
      'status': 'Resolved',
      'description': 'High CPU usage detected.',
    },
    {
      'id': '3',
      'date': '13 May 2024',
      'time': '06:49 PM',
      'type': 'Flagged Transaction',
      'status': 'Unresolved',
      'description': 'Transaction flagged as potential identity theft.',
    },
    {
      'id': '4',
      'date': '14 May 2024',
      'time': '07:49 PM',
      'type': 'System Warning',
      'status': 'Unresolved',
      'description': 'Low disk space on server.',
    },
  ];

  // Filtered alerts based on user selections
  List<Map<String, String>> get filteredAlerts {
    return alerts.where((alert) {
      final matchesAlertType = selectedAlertType == 'All' || alert['type'] == selectedAlertType;
      final matchesAlertStatus = selectedAlertStatus == 'All' || alert['status'] == selectedAlertStatus;
      return matchesAlertType && matchesAlertStatus;
    }).toList();
  }

  // Function to resolve an alert
  void resolveAlert(String alertId) {
    setState(() {
      final alert = alerts.firstWhere((alert) => alert['id'] == alertId);
      alert['status'] = 'Resolved';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alert resolved successfully!')),
    );
  }

  // Function to dismiss an alert
  void dismissAlert(String alertId) {
    setState(() {
      alerts.removeWhere((alert) => alert['id'] == alertId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alert dismissed successfully!')),
    );
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
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
=======
      appBar: AppBar(
        title: const Text('Alert Management'),
      ),
      body: Container(
        color: const Color(0xFF1F2029), 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters Section
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Alert Type'),
                    value: selectedAlertType,
                    items: ['All', 'Flagged Transaction', 'System Warning']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
                    onChanged: (value) {
                      setState(() {
                        selectedAlertType = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
<<<<<<< HEAD
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
=======
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Alert Status'),
                    value: selectedAlertStatus,
                    items: ['All', 'Resolved', 'Unresolved']
                        .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                        .toList(),
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
                    onChanged: (value) {
                      setState(() {
                        selectedAlertStatus = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
<<<<<<< HEAD
          ),
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
                          borderRadius: BorderRadius.circular(8),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      alert.alertType,
                                      style: TextStyle(
                                        color: alert.fraudProbability > 0.85 ? Colors.red : Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: alert.resolved ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        alert.status,
                                        style: TextStyle(
                                          color: alert.resolved ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('Transaction ID: ${alert.transactionId}', style: const TextStyle(color: Colors.white70)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.attach_money, size: 16, color: Colors.white70),
                                    const SizedBox(width: 4),
                                    Text('GHS${alert.amount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                                    const Spacer(),
                                    const Icon(Icons.timelapse, size: 16, color: Colors.white70),
                                    const SizedBox(width: 4),
                                    Text(_formatDate(alert.timestamp), style: const TextStyle(color: Colors.white70)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: alert.fraudProbability,
                                  backgroundColor: Colors.grey[800],
                                  color: _getProbabilityColor(alert.fraudProbability),
                                ),
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
=======
            const SizedBox(height: 16),

            // Alert List
            Expanded(
              child: ListView.builder(
                itemCount: filteredAlerts.length,
                itemBuilder: (context, index) {
                  final alert = filteredAlerts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(alert['type']!),
                      subtitle: Text('${alert['date']} • ${alert['time']}\nStatus: ${alert['status']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          _showAlertActions(context, alert['id']!);
                        },
                      ),
                      onTap: () {
                        _showAlertDetails(context, alert);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show alert actions (resolve, dismiss)
  void _showAlertActions(BuildContext context, String alertId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Resolve Alert'),
              onTap: () {
                resolveAlert(alertId);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Dismiss Alert'),
              onTap: () {
                dismissAlert(alertId);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Show alert details
  void _showAlertDetails(BuildContext context, Map<String, String> alert) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(alert['type']!),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${alert['date']}'),
              Text('Time: ${alert['time']}'),
              Text('Status: ${alert['status']}'),
              const SizedBox(height: 16),
              Text('Description: ${alert['description']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
