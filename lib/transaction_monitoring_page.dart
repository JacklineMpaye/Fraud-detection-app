import 'package:flutter/material.dart';
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
        elevation: 0,
      ),
      drawer: !Responsive.isDesktop(context)
          ? SizedBox(
              width: 250,
              child: Menu(
                scaffoldKey: GlobalKey(),
                changePage: (newPage) {},
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTransactionOverviewSection(context),
              const SizedBox(height: 20),
              _buildRecentTransactionsSection(context),
            ],
          ),
        ),
      ),
    );
  }

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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildAggregate(BuildContext context, {required String function, required String field, required List<String> filters}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('FUNCTION', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 10),
        Text('• $function ▼\n  $field', style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 10),
        for (var filter in filters)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text('• and $filter', style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ),
      ],
    );
  }

  Widget _buildInquiryStatus(String status, String value, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Text(status, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

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
