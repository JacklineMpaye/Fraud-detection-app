import 'package:flutter/material.dart';

class ReportingPage extends StatefulWidget {
  const ReportingPage({super.key});

  @override
  _ReportingPageState createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage> {
  String selectedTransactionType = 'All';
  String selectedFraudPattern = 'All';

  // Chart selection state
  bool showFraudTrendsChart = true;
  bool showHighRiskAreasChart = false;
  bool showTransactionStatusChart = true;

  // Toggle report preview visibility
  bool showReportPreview = false;

  // Example data (replace with real data from your backend)
  final List<Map<String, String>> transactions = [
    {'date': '12 May 2024', 'time': '04:49 PM', 'status': 'Flagged', 'confidence': '40%', 'fraudType': 'Phishing'},
    {'date': '12 May 2024', 'time': '05:49 PM', 'status': 'Successful', 'confidence': '100%', 'fraudType': 'None'},
    {'date': '13 May 2024', 'time': '06:49 PM', 'status': 'Flagged', 'confidence': '20%', 'fraudType': 'Identity Theft'},
    {'date': '14 May 2024', 'time': '07:49 PM', 'status': 'Flagged', 'confidence': '60%', 'fraudType': 'Card Fraud'},
  ];

  // Filtered transactions based on user selections
  List<Map<String, String>> get filteredTransactions {
    return transactions.where((transaction) {
      final matchesTransactionType = selectedTransactionType == 'All' || transaction['status'] == selectedTransactionType;
      final matchesFraudPattern = selectedFraudPattern == 'All' || transaction['fraudType'] == selectedFraudPattern;
      return matchesTransactionType && matchesFraudPattern;
    }).toList();
  }

  // Generate a sample report
  Map<String, dynamic> generateReport() {
    return {
      'title': 'System and Transaction Report', 
      'systemCondition': {
        'status': 'Stable',
        'uptime': '99.9%',
        'alerts': 'No critical alerts',
      },
      'transactionAnalysis': {
        'totalTransactions': transactions.length,
        'flaggedTransactions': transactions.where((t) => t['status'] == 'Flagged').length,
        'successfulTransactions': transactions.where((t) => t['status'] == 'Successful').length,
      },
      'anomalies': {
        'totalAnomalies': transactions.where((t) => t['status'] == 'Flagged').length,
        'mostCommonFraudPattern': 'Phishing', // Updated to use the new pattern
      },
      'trends': {
        'fraudTrend': 'Decreasing',
        'highRiskAreas': ['Region X', 'Region Y'],
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final report = generateReport();
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporting and Trend Analysis', style: TextStyle(
    color: Colors.white,  // Set the color here
  ),),
        backgroundColor:
            const Color(0xFF1F2029), // Slightly lighter than background
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Wrap the entire body in a SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters Section
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Transaction Type'),
                    value: selectedTransactionType,
                    items: ['All', 'Successful', 'Flagged', 'Rejected']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type, style: TextStyle(color: Colors.white))))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTransactionType = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Fraud Pattern'),
                    value: selectedFraudPattern,
                    items: ['All', 'Phishing', 'Identity Theft', 'Card Fraud'] // Updated patterns
                        .map((pattern) => DropdownMenuItem(value: pattern, child: Text(pattern)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFraudPattern = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Generate Report Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showReportPreview = !showReportPreview; // Toggle report preview visibility
                });
              },
              child: Text(showReportPreview ? 'Hide Report Preview' : 'Generate Report'),
            ),

            // Chart Selection Section
            const Text('Select Charts to Include:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            CheckboxListTile(
              title: const Text('Fraud Trends Over Time',style: TextStyle(color: Colors.white)),
              value: showFraudTrendsChart,
              onChanged: (value) {
                setState(() {
                  showFraudTrendsChart = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('High-Risk Areas', style: TextStyle(color: Colors.white)),
              value: showHighRiskAreasChart,
              onChanged: (value) {
                setState(() {
                  showHighRiskAreasChart = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Transaction Status Distribution', style: TextStyle(color: Colors.white)),
              value: showTransactionStatusChart,
              onChanged: (value) {
                setState(() {
                  showTransactionStatusChart = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Report Preview Section (Conditionally Visible)
            if (showReportPreview)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Report Preview:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Report Title
                            Center(
                              child: Text(
                                report['title'],
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // System Condition
                            const Text('System Condition:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                            Text('Uptime: ${report['systemCondition']['uptime']}', style: TextStyle(color: Colors.black)),
                            Text('Alerts: ${report['systemCondition']['alerts']}', style:  TextStyle(color: Colors.black)),
                            const SizedBox(height: 20),

                            // Transaction Analysis
                            const Text('Transaction Analysis:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                            Text('Total Transactions: ${report['transactionAnalysis']['totalTransactions']}', style: const TextStyle(color: Colors.black)),
                            Text('Flagged Transactions: ${report['transactionAnalysis']['flaggedTransactions']}', style: const TextStyle(color: Colors.black)),
                            Text('Successful Transactions: ${report['transactionAnalysis']['successfulTransactions']}', style: const TextStyle(color: Colors.black)),
                            const SizedBox(height: 20),

                            // Anomalies
                            const Text('Anomalies:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                            Text('Total Anomalies: ${report['anomalies']['totalAnomalies']}', style: const TextStyle(color: Colors.black)),
                            Text('Most Common Fraud Pattern: ${report['anomalies']['mostCommonFraudPattern']}', style: const TextStyle(color: Colors.black)),
                            const SizedBox(height: 20),

                            // Trends
                            const Text('Trends:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                            Text('Fraud Trend: ${report['trends']['fraudTrend']}', style: TextStyle(color: Colors.black)),
                            Text('High-Risk Areas: ${report['trends']['highRiskAreas'].join(', ')}', style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            // Export Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Export as PDF
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('PDF'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Export as CSV
                  },
                  icon: const Icon(Icons.table_chart),
                  label: const Text('CSV'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Export as Excel
                  },
                  icon: const Icon(Icons.table_view),
                  label: const Text('Excel'),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF1F2029), // Set your desired background color here
    );
  }
}