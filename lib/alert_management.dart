import 'package:flutter/material.dart';

class AlertManagementPage extends StatefulWidget {
  const AlertManagementPage({super.key});

  @override
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onChanged: (value) {
                      setState(() {
                        selectedAlertType = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Alert Status'),
                    value: selectedAlertStatus,
                    items: ['All', 'Resolved', 'Unresolved']
                        .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAlertStatus = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
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