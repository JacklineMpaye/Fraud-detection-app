import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fraud_dashboard/model/graph_model.dart'; // Import the GraphModel

class TransactionLineGraph extends StatelessWidget {
  TransactionLineGraph({super.key});

  // Sample data for the line graph
  final List<GraphModel> approvedData = [
    GraphModel(x: 0, y: 20), // Jan
    GraphModel(x: 1, y: 15), // Feb
    GraphModel(x: 2, y: 10), // Mar
    GraphModel(x: 3, y: 50), // Apr
    GraphModel(x: 4, y: 30), // May
  ];

  final List<GraphModel> reviewData = [
    GraphModel(x: 0, y: 10), // Jan
    GraphModel(x: 1, y: 20), // Feb
    GraphModel(x: 2, y: 15), // Mar
    GraphModel(x: 3, y: 40), // Apr
    GraphModel(x: 4, y: 25), // May
  ];

  final List<GraphModel> declinedData = [
    GraphModel(x: 0, y: 5), // Jan
    GraphModel(x: 1, y: 10), // Feb
    GraphModel(x: 2, y: 8),  // Mar
    GraphModel(x: 3, y: 20), // Apr
    GraphModel(x: 4, y: 15), // May
  ];

  // Labels for the x-axis
  final List<String> labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 26, 28, 54), // Match the background color
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // fl
            const SizedBox(height: 20),
            SizedBox(
              height: 200, // Fixed height for the graph
              child: LineChart(
                LineChartData(
                  minY: 0, // Set the minimum y-axis value
                  maxY: 60, // Set the maximum y-axis value (adjust based on your data)
                  lineBarsData: [
                    // Approved Transactions
                    LineChartBarData(
                      spots: approvedData.map((point) => FlSpot(point.x, point.y)).toList(),
                      isCurved: true,
                      color: Colors.green, // Color for approved transactions
                      barWidth: 3,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: true),
                    ),
                    // Review Transactions
                    LineChartBarData(
                      spots: reviewData.map((point) => FlSpot(point.x, point.y)).toList(),
                      isCurved: true,
                      color: Colors.orange, // Color for review transactions
                      barWidth: 3,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: true),
                    ),
                    // Declined Transactions
                    LineChartBarData(
                      spots: declinedData.map((point) => FlSpot(point.x, point.y)).toList(),
                      isCurved: true,
                      color: Colors.red, // Color for declined transactions
                      barWidth: 3,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              labels[value.toInt()],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 10, // Set y-axis intervals (e.g., 10, 20, 30, etc.)
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Legend for the graph
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Approved', Colors.green),
                const SizedBox(width: 20),
                _buildLegendItem('Review', Colors.orange),
                const SizedBox(width: 20),
                _buildLegendItem('Declined', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a legend item
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}