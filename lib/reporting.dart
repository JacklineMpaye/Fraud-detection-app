<<<<<<< HEAD
import 'dart:io' as io show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:html' as html;
=======
import 'package:flutter/material.dart';
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f

class ReportingPage extends StatefulWidget {
  const ReportingPage({super.key});

  @override
  _ReportingPageState createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage> {
  String selectedTransactionType = 'All';
  String selectedFraudPattern = 'All';
<<<<<<< HEAD
  bool showFraudTrendsChart = true;
  bool showHighRiskAreasChart = false;
  bool showTransactionStatusChart = true;
  bool showReportPreview = false;

=======

  // Chart selection state
  bool showFraudTrendsChart = true;
  bool showHighRiskAreasChart = false;
  bool showTransactionStatusChart = true;

  // Toggle report preview visibility
  bool showReportPreview = false;

  // Example data (replace with real data from your backend)
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
  final List<Map<String, String>> transactions = [
    {'date': '12 May 2024', 'time': '04:49 PM', 'status': 'Flagged', 'confidence': '40%', 'fraudType': 'Phishing'},
    {'date': '12 May 2024', 'time': '05:49 PM', 'status': 'Successful', 'confidence': '100%', 'fraudType': 'None'},
    {'date': '13 May 2024', 'time': '06:49 PM', 'status': 'Flagged', 'confidence': '20%', 'fraudType': 'Identity Theft'},
    {'date': '14 May 2024', 'time': '07:49 PM', 'status': 'Flagged', 'confidence': '60%', 'fraudType': 'Card Fraud'},
  ];

<<<<<<< HEAD
=======
  // Filtered transactions based on user selections
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
  List<Map<String, String>> get filteredTransactions {
    return transactions.where((transaction) {
      final matchesTransactionType = selectedTransactionType == 'All' || transaction['status'] == selectedTransactionType;
      final matchesFraudPattern = selectedFraudPattern == 'All' || transaction['fraudType'] == selectedFraudPattern;
      return matchesTransactionType && matchesFraudPattern;
    }).toList();
  }

<<<<<<< HEAD
  Map<String, dynamic> generateReport() {
    return {
      'title': 'System and Transaction Report',
=======
  // Generate a sample report
  Map<String, dynamic> generateReport() {
    return {
      'title': 'System and Transaction Report', 
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
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
<<<<<<< HEAD
        'mostCommonFraudPattern': 'Phishing',
=======
        'mostCommonFraudPattern': 'Phishing', // Updated to use the new pattern
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
      },
      'trends': {
        'fraudTrend': 'Decreasing',
        'highRiskAreas': ['Region X', 'Region Y'],
      },
    };
  }

<<<<<<< HEAD
  Future<void> exportToCsv() async {
    List<List<String>> csvData = [
      ['Date', 'Time', 'Status', 'Confidence', 'Fraud Type'],
      ...filteredTransactions.map((transaction) => [
        transaction['date'] ?? '',
        transaction['time'] ?? '',
        transaction['status'] ?? '',
        transaction['confidence'] ?? '',
        transaction['fraudType'] ?? '',
      ]),
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    if (kIsWeb) {
      final bytes = Uint8List.fromList(csv.codeUnits);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'report.csv')
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/report.csv';
      final file = io.File(path);
      await file.writeAsString(csv);
      await Share.shareXFiles([XFile(file.path)], text: 'Exported CSV report.');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV exported successfully!')),
    );
  }

  Future<void> exportToExcel() async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    sheetObject.appendRow(['Date', 'Time', 'Status', 'Confidence', 'Fraud Type']);
    for (var transaction in filteredTransactions) {
      sheetObject.appendRow([
        transaction['date'] ?? '',
        transaction['time'] ?? '',
        transaction['status'] ?? '',
        transaction['confidence'] ?? '',
        transaction['fraudType'] ?? '',
      ]);
    }

    final bytes = excel.encode()!;
    if (kIsWeb) {
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'report.xlsx')
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/report.xlsx';
      final file = io.File(path);
      await file.writeAsBytes(bytes);
      await Share.shareXFiles([XFile(file.path)], text: 'Exported Excel report.');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Excel exported successfully!')),
    );
  }

  Future<void> exportToPdf() async {
    final pdf = pw.Document();
    final report = generateReport();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('System and Transaction Report', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Text('System Condition:', style: pw.TextStyle(fontSize: 18)),
            pw.Text('Uptime: ${report['systemCondition']['uptime']}'),
            pw.Text('Alerts: ${report['systemCondition']['alerts']}'),
            pw.SizedBox(height: 20),
            pw.Text('Transaction Analysis:', style: pw.TextStyle(fontSize: 18)),
            pw.Text('Total Transactions: ${report['transactionAnalysis']['totalTransactions']}'),
            pw.Text('Flagged Transactions: ${report['transactionAnalysis']['flaggedTransactions']}'),
            pw.Text('Successful Transactions: ${report['transactionAnalysis']['successfulTransactions']}'),
            pw.SizedBox(height: 20),
            pw.Text('Anomalies:', style: pw.TextStyle(fontSize: 18)),
            pw.Text('Total Anomalies: ${report['anomalies']['totalAnomalies']}'),
            pw.Text('Most Common Fraud Pattern: ${report['anomalies']['mostCommonFraudPattern']}'),
            pw.SizedBox(height: 20),
            pw.Text('Trends:', style: pw.TextStyle(fontSize: 18)),
            pw.Text('Fraud Trend: ${report['trends']['fraudTrend']}'),
            pw.Text('High Risk Areas: ${report['trends']['highRiskAreas'].join(', ')}'),
          ],
        ),
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'report.pdf');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF exported successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final report = generateReport();

    return Scaffold(
      appBar: AppBar(title: const Text("Reporting")),
      body: SingleChildScrollView(
=======
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
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
=======
            // Filters Section
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Transaction Type'),
                    value: selectedTransactionType,
                    items: ['All', 'Successful', 'Flagged', 'Rejected']
<<<<<<< HEAD
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
=======
                        .map((type) => DropdownMenuItem(value: type, child: Text(type, style: TextStyle(color: Colors.white))))
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
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
<<<<<<< HEAD
                    items: ['All', 'Phishing', 'Identity Theft', 'Card Fraud']
=======
                    items: ['All', 'Phishing', 'Identity Theft', 'Card Fraud'] // Updated patterns
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
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
<<<<<<< HEAD
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showReportPreview = !showReportPreview;
=======

            // Generate Report Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showReportPreview = !showReportPreview; // Toggle report preview visibility
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
                });
              },
              child: Text(showReportPreview ? 'Hide Report Preview' : 'Generate Report'),
            ),
<<<<<<< HEAD
            CheckboxListTile(
              title: const Text('Fraud Trends Over Time'),
=======

            // Chart Selection Section
            const Text('Select Charts to Include:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            CheckboxListTile(
              title: const Text('Fraud Trends Over Time',style: TextStyle(color: Colors.white)),
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
              value: showFraudTrendsChart,
              onChanged: (value) {
                setState(() {
                  showFraudTrendsChart = value!;
                });
              },
            ),
            CheckboxListTile(
<<<<<<< HEAD
              title: const Text('High-Risk Areas'),
=======
              title: const Text('High-Risk Areas', style: TextStyle(color: Colors.white)),
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
              value: showHighRiskAreasChart,
              onChanged: (value) {
                setState(() {
                  showHighRiskAreasChart = value!;
                });
              },
            ),
            CheckboxListTile(
<<<<<<< HEAD
              title: const Text('Transaction Status Distribution'),
=======
              title: const Text('Transaction Status Distribution', style: TextStyle(color: Colors.white)),
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
              value: showTransactionStatusChart,
              onChanged: (value) {
                setState(() {
                  showTransactionStatusChart = value!;
                });
              },
            ),
            const SizedBox(height: 16),
<<<<<<< HEAD
            if (showReportPreview)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Report Preview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('System Condition:\n- Uptime: ${report['systemCondition']['uptime']}\n- Alerts: ${report['systemCondition']['alerts']}'),
                    const SizedBox(height: 10),
                    Text('Transaction Analysis:\n- Total: ${report['transactionAnalysis']['totalTransactions']}\n- Flagged: ${report['transactionAnalysis']['flaggedTransactions']}\n- Successful: ${report['transactionAnalysis']['successfulTransactions']}'),
                    const SizedBox(height: 10),
                    Text('Anomalies:\n- Total: ${report['anomalies']['totalAnomalies']}\n- Common Fraud: ${report['anomalies']['mostCommonFraudPattern']}'),
                    const SizedBox(height: 10),
                    Text('Trends:\n- Fraud Trend: ${report['trends']['fraudTrend']}\n- High Risk Areas: ${report['trends']['highRiskAreas'].join(', ')}'),
                  ],
                ),
              ),
            const SizedBox(height: 16),
=======

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
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
<<<<<<< HEAD
                  onPressed: exportToPdf,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Export PDF'),
                ),
                ElevatedButton.icon(
                  onPressed: exportToCsv,
                  icon: const Icon(Icons.table_chart),
                  label: const Text('Export CSV'),
                ),
                ElevatedButton.icon(
                  onPressed: exportToExcel,
                  icon: const Icon(Icons.table_view),
                  label: const Text('Export Excel'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
=======
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
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
