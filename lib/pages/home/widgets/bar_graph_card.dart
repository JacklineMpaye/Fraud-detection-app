import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fraud_dashboard/responsive.dart';
import 'package:fraud_dashboard/model/bar_graph_model.dart';
import 'package:fraud_dashboard/model/graph_model.dart';
import 'package:fraud_dashboard/widgets/custom_card.dart';

class BarGraphCard extends StatelessWidget {
  BarGraphCard({super.key});

  final List<BarGraphModel> data = [
    BarGraphModel(
        lable: "Anomaly Detection Rate",
        color: const Color(0xFFFEB95A),
        graph: [
          GraphModel(x: 0, y: 15), // Day 1
          GraphModel(x: 1, y: 20), // Day 2
          GraphModel(x: 2, y: 10), // Day 3
          GraphModel(x: 3, y: 25), // Day 4
          GraphModel(x: 4, y: 18), // Day 5
          GraphModel(x: 5, y: 22), // Day 6
        ]),
    BarGraphModel(
        lable: "System Health",
        color: const Color(0xFFF2C8ED),
        graph: [
          GraphModel(x: 0, y: 80), // CPU Usage (%)
          GraphModel(x: 1, y: 60), // Memory Usage (%)
          GraphModel(x: 2, y: 120), // API Response Time (ms)
          GraphModel(x: 3, y: 90), // CPU Usage (%)
          GraphModel(x: 4, y: 70), // Memory Usage (%)
          GraphModel(x: 5, y: 110), // API Response Time (ms)
        ]),
    BarGraphModel(
        lable: "Fraud Patterns",
        color: const Color(0xFF20AEF3),
        graph: [
          GraphModel(x: 0, y: 12), // Phishing
          GraphModel(x: 1, y: 8),  // Identity Theft
          GraphModel(x: 2, y: 15),  // Card Fraud
          GraphModel(x: 3, y: 10),  // Phishing
          GraphModel(x: 4, y: 5),   // Identity Theft
          GraphModel(x: 5, y: 18),  // Card Fraud
        ]),
  ];

  // Custom labels for each graph
  final Map<String, List<String>> graphLabels = {
    "Anomaly Detection Rate": ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6'],
    "System Health": ['CPU', 'Memory', 'API', 'CPU', 'Memory', 'API'],
    "Fraud Patterns": ['Phishing', 'Identity Theft', 'Card Fraud', 'Phishing', 'Identity Theft', 'Card Fraud'],
  };

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isMobile(context) ? 1 : 3,
          crossAxisSpacing: !Responsive.isMobile(context) ? 15 : 12,
          mainAxisSpacing: 12.0,
          childAspectRatio: Responsive.isMobile(context) ? 16 / 9 : 5 / 4),
      itemBuilder: (context, i) {
        return CustomCard(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data[i].lable,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      barGroups: _chartGroups(
                          points: data[i].graph, color: data[i].color),
                      borderData: FlBorderData(border: const Border()),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Transform.rotate(
                              angle: -0.4, // Rotate labels by -0.4 radians (approx. -23 degrees)
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  graphLabels[data[i].lable]![value.toInt()],
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                          },
                        )),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  List<BarChartGroupData> _chartGroups(
      {required List<GraphModel> points, required Color color}) {
    return points
        .map((point) => BarChartGroupData(x: point.x.toInt(), barRods: [
              BarChartRodData(
                toY: point.y,
                width: 12,
                color: color.withOpacity(point.y.toInt() > 4 ? 1 : 0.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3.0),
                  topRight: Radius.circular(3.0),
                ),
              )
            ]))
        .toList();
  }
}