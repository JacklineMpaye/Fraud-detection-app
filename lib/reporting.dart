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

class ReportingPage extends StatefulWidget {
  const ReportingPage({super.key});

  @override
  _ReportingPageState createState() => _ReportingPageState();
}

class _ReportingPageState extends State<ReportingPage> {
  String selectedTransactionType = 'All';
  String selectedFraudPattern = 'All';
  bool showFraudTrendsChart = true;
  bool showHighRiskAreasChart = false;
  bool showTransactionStatusChart = true;
  bool showReportPreview = false;

  final List<Map<String, String>> transactions = [
    {'date': '12 May 2024', 'time': '04:49 PM', 'status': 'Flagged', 'confidence': '40%', 'fraudType': 'Phishing'},
    {'date': '12 May 2024', 'time': '05:49 PM', 'status': 'Successful', 'confidence': '100%', 'fraudType': 'None'},
    {'date': '13 May 2024', 'time': '06:49 PM', 'status': 'Flagged', 'confidence': '20%', 'fraudType': 'Identity Theft'},
    {'date': '14 May 2024', 'time': '07:49 PM', 'status': 'Flagged', 'confidence': '60%', 'fraudType': 'Card Fraud'},
  ];

  List<Map<String, String>> get filteredTransactions {
    return transactions.where((transaction) {
      final matchesTransactionType = selectedTransactionType == 'All' || transaction['status'] == selectedTransactionType;
      final matchesFraudPattern = selectedFraudPattern == 'All' || transaction['fraudType'] == selectedFraudPattern;
      return matchesTransactionType && matchesFraudPattern;
    }).toList();
  }

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
        'mostCommonFraudPattern': 'Phishing',
      },
      'trends': {
        'fraudTrend': 'Decreasing',
        'highRiskAreas': ['Region X', 'Region Y'],
      },
    };
  }

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

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV exported successfully!')));
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

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excel exported successfully!')));
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

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF exported successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    final report = generateReport();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporting and Trend Analysis'),
        backgroundColor: const Color(0xFF1F2029),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Transaction Type'),
                    value: selectedTransactionType,
                    items: ['All', 'Successful', 'Flagged', 'Rejected']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
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
                    items: ['All', 'Phishing', 'Identity Theft', 'Card Fraud']
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showReportPreview = !showReportPreview;
                });
              },
              child: Text(showReportPreview ? 'Hide Report Preview' : 'Generate Report'),
            ),
            if (showReportPreview) ...[
              const SizedBox(height: 16),
              Card(
                elevation: 5,
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Uptime: ${report['systemCondition']['uptime']}'),
                      Text('Alerts: ${report['systemCondition']['alerts']}'),
                      Text('Total Transactions: ${report['transactionAnalysis']['totalTransactions']}'),
                      Text('Flagged: ${report['transactionAnalysis']['flaggedTransactions']}'),
                      Text('Successful: ${report['transactionAnalysis']['successfulTransactions']}'),
                      Text('Total Anomalies: ${report['anomalies']['totalAnomalies']}'),
                      Text('Fraud Pattern: ${report['anomalies']['mostCommonFraudPattern']}'),
                      Text('Fraud Trend: ${report['trends']['fraudTrend']}'),
                      Text('High-Risk Areas: ${report['trends']['highRiskAreas'].join(', ')}'),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: exportToPdf,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('PDF'),
                ),
                ElevatedButton.icon(
                  onPressed: exportToCsv,
                  icon: const Icon(Icons.table_chart),
                  label: const Text('CSV'),
                ),
                ElevatedButton.icon(
                  onPressed: exportToExcel,
                  icon: const Icon(Icons.table_view),
                  label: const Text('Excel'),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF1F2029),
    );
  }
}
