import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:fraud_dashboard/const.dart';
import 'package:fraud_dashboard/pages/home/widgets/transaction_bar_graph.dart';
import 'package:fraud_dashboard/widgets/menu.dart';
import 'package:fraud_dashboard/Responsive.dart';
import 'package:fraud_dashboard/services/alert_service.dart';

class TransactionMonitoringPage extends StatefulWidget {
  const TransactionMonitoringPage({super.key});

  @override
  State<TransactionMonitoringPage> createState() => _TransactionMonitoringPageState();
}

class _TransactionMonitoringPageState extends State<TransactionMonitoringPage> {
  late Future<List<Map<String, dynamic>>> _alertsFuture;

  @override
  void initState() {
    super.initState();
    _alertsFuture = fetchAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171821),
      appBar: AppBar(
        title: const Text('Transaction Monitoring', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1F2029),
=======
import 'package:fraud_dashboard/const.dart'; // Import for colors
import 'package:fraud_dashboard/pages/home/widgets/transaction_bar_graph.dart';
import 'package:fraud_dashboard/widgets/menu.dart'; // Import the Menu widget
import 'package:fraud_dashboard/Responsive.dart'; // Import the Responsive utility

class TransactionMonitoringPage extends StatelessWidget {
  const TransactionMonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171821), // Match dashboard background
      appBar: AppBar(
        title: const Text('Transaction Monitoring', style: TextStyle(
    color: Colors.white,  // Set the color here
  ),),
        backgroundColor:
            const Color(0xFF1F2029), // Slightly lighter than background
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
        elevation: 0,
      ),
      drawer: !Responsive.isDesktop(context)
          ? SizedBox(
<<<<<<< HEAD
              width: 250,
              child: Menu(
                scaffoldKey: GlobalKey(),
                changePage: (newPage) {},
=======
              width: 250, // Fixed width for the drawer
              child: Menu(
                scaffoldKey: GlobalKey(),
                changePage: (newPage) {
                  // Handle page change logic
                },
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              _buildTransactionOverviewSection(context),
              const SizedBox(height: 20),
              _buildRecentTransactionsSection(context),
=======
              // Row for Average Amount and Inquiries Overview
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Average Amount Section (Left)
                  Expanded(
                    flex: 1,
                    child: _buildCard(
                      context,
                      title: 'Average Amount',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAggregate(
                            context,
                            function: 'Average',
                            field: 'Transaction.amount',
                            filters: [
                              'Date is 7 days ago',
                              'Type is SEPA',
                            ],
                          ),
                          const SizedBox(height: 60),
                          ElevatedButton(
                            onPressed: () {
                              // Add logic to show High Velocity Transfers
                              _showHighVelocityTransfers(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 26, 28, 54),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Add Rule',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // Spacing between sections

                  // Inquiries Overview Section (Right)
                  Expanded(
                    flex: 1,
                    child: _buildCard(
                      context,
                      title: 'Inquiries Overview',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '0%',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '144 in Total',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 100, // Adjust as needed
                                width: 100, // Adjust as needed
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Green outer progress bar
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: CircularProgressIndicator(
                                        value: 0.68, // 68% Accepted
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.3),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.green),
                                        strokeWidth: 10,
                                      ),
                                    ),

                                    // Red inner progress bar
                                    SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator(
                                        value: 0.31, // 31% Rejected
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.3),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                        strokeWidth: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildInquiryStatus(
                              'Successful', '98/144 (68%)', Colors.green),
                          const SizedBox(height: 10),
                          _buildInquiryStatus(
                              'Flagged', '46/144 (31%)', Colors.red),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Row for Graph and Recent Transactions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Graph Section (Left)
                  Expanded(
                    flex: 1,
                    child: _buildCard(
                      context,
                      title: 'Transaction Trends',
                      child: TransactionLineGraph(), // Use your graph here
                    ),
                  ),
                  const SizedBox(width: 15), // Spacing between sections

                  // Recent Transactions Section (Right)
                  Expanded(
                    flex: 1,
                    child: _buildCard(
                      context,
                      title: 'Recent Transactions',
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20,
                          columns: const [
                            DataColumn(
                                label: Text('Transaction Date',
                                    style: TextStyle(fontSize: 13, color: Colors.white))),
                            DataColumn(
                                label: Text('Transaction Time',
                                    style: TextStyle(fontSize: 13, color: Colors.white))),
                            DataColumn(
                                label: Text('Transaction Status',
                                    style: TextStyle(fontSize: 13, color: Colors.white))),
                            DataColumn(
                                label: Text('Confidence %',
                                    style: TextStyle(fontSize: 13, color: Colors.white))),
                          ],
                          rows: [
                            _buildDataRow('12 May, 2024', '02:49 PM',
                                '✅ Successful', '40%'),
                            _buildDataRow('12 May, 2024', '03:49 PM',
                                '❌ Flagged', '10%'),
                            _buildDataRow('12 May, 2024', '04:49 PM',
                                '✅ Successful', '100%'),
                            _buildDataRow('12 May, 2024', '05:49 PM',
                                '✅ Successful', '100%'),
                            _buildDataRow('12 May, 2024', '06:49 PM',
                                '❌ Flagged', '20%'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildTransactionOverviewSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildCard(
            context,
            title: 'Average Amount',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAggregate(
                  context,
                  function: 'Average',
                  field: 'Transaction.amount',
                  filters: ['Date is 7 days ago', 'Type is SEPA'],
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () => _showHighVelocityTransfers(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 26, 28, 54),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Add Rule', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: _buildCard(
            context,
            title: 'Inquiries Overview',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('0%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 10),
                const Text('144 in Total', style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 10),
                _buildInquiryProgressBar(),
                const SizedBox(height: 20),
                _buildInquiryStatus('Successful', '98/144 (68%)', Colors.green),
                const SizedBox(height: 10),
                _buildInquiryStatus('Flagged', '46/144 (31%)', Colors.red),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildCard(
            context,
            title: 'Transaction Trends',
            child: TransactionLineGraph(),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 1,
          child: _buildCard(
            context,
            title: 'Recent Transactions',
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _alertsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No alerts available.', style: TextStyle(color: Colors.grey));
                } else {
                  final alerts = snapshot.data!.take(7).toList(); // Only show first 7 alerts
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(label: Text('Transaction ID', style: TextStyle(fontSize: 13, color: Colors.white))),
                        DataColumn(label: Text('Status', style: TextStyle(fontSize: 13, color: Colors.white))),
                        DataColumn(label: Text('Amount', style: TextStyle(fontSize: 13, color: Colors.white))),
                        DataColumn(label: Text('Confidence', style: TextStyle(fontSize: 13, color: Colors.white))),
                      ],
                      rows: alerts.map((alert) {
                        String label = _mapFraudProbabilityToLabel(alert['fraud_prob']);
                        return DataRow(cells: [
                          DataCell(Text(alert['transactionId'].toString(), style: const TextStyle(color: Colors.grey))),
                          DataCell(Text(label, style: const TextStyle(color: Colors.grey))),
                          DataCell(Text('\$${alert['amount'].toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey))),
                          DataCell(Text('${(alert['fraud_prob'] * 100).toStringAsFixed(1)}%', style: const TextStyle(color: Colors.grey))),
                        ]);
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  String _mapFraudProbabilityToLabel(double prob) {
    if (prob > 0.90) {
      return '✅ Flagged (High)';
    } else if (prob > 0.60) {
      return '⚠️ Medium Risk';
    } else {
      return '✅ Likely Legit';
    }
  }

  Widget _buildInquiryProgressBar() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value: 0.68,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  strokeWidth: 10,
                ),
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  value: 0.31,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  strokeWidth: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showHighVelocityTransfers(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2029),
        title: const Text('High Velocity Transfers', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCondition(context, condition: 'Transaction amount > 7 last days transactions'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 26, 28, 54),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: const Text('Create Rule', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required Widget child}) {
    return Card(
      color: cardBackgroundColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
=======
  // Helper method to show High Velocity Transfers
  void _showHighVelocityTransfers(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F2029),
          title: const Text(
            'High Velocity Transfers',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCondition(
                context,
                condition: 'Transaction amount > 7 last days transactions',
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Add logic to create a new rule
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 26, 28, 54),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Create Rule',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build a card
  Widget _buildCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Card(
      color: cardBackgroundColor, // Slightly lighter than background
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
=======
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildAggregate(BuildContext context, {required String function, required String field, required List<String> filters}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('FUNCTION', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 10),
        Text('• $function ▼\n  $field', style: const TextStyle(fontSize: 13, color: Colors.grey)),
=======
  // Helper method to build an aggregate
  Widget _buildAggregate(
    BuildContext context, {
    required String function,
    required String field,
    required List<String> filters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FUNCTION',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '• $function ▼\n  $field',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
        const SizedBox(height: 10),
        for (var filter in filters)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
<<<<<<< HEAD
            child: Text('• and $filter', style: const TextStyle(fontSize: 13, color: Colors.grey)),
=======
            child: Text(
              '• and $filter',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
          ),
      ],
    );
  }

<<<<<<< HEAD
  Widget _buildInquiryStatus(String status, String value, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Text(status, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13, color: Colors.grey)),
=======
  // Helper method to build inquiry status
  Widget _buildInquiryStatus(String status, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          status,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
      ],
    );
  }

<<<<<<< HEAD
  Widget _buildCondition(BuildContext context, {required String condition}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('CONDITIONS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 10),
        Text('• $condition', style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}
=======
  // Helper method to build a data row for the table
  DataRow _buildDataRow(
      String date, String time, String status, String confidence) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            date,
            style: const TextStyle(
              fontSize: 13, // Adjust font size
              color: Colors.grey, // Adjust text color
            ),
          ),
        ),
        DataCell(
          Text(
            time,
            style: const TextStyle(
              fontSize: 13, // Adjust font size
              color: Colors.grey, // Adjust text color
            ),
          ),
        ),
        DataCell(
          Text(
            status,
            style: TextStyle(
              fontSize: 13, // Adjust font size
              color: status == '✅ Successful' ? Colors.green : Colors.red, // Conditional color
            ),
          ),
        ),
        DataCell(
          Text(
            confidence,
            style: const TextStyle(
              fontSize: 13, // Adjust font size
              color: Colors.grey, // Adjust text color
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build a condition
  Widget _buildCondition(
    BuildContext context, {
    required String condition,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CONDITIONS',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '• $condition',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
