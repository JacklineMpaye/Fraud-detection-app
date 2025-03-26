import 'package:flutter/material.dart';
import 'package:fraud_dashboard/Responsive.dart';
import 'package:fraud_dashboard/model/health_model.dart';
import 'package:fraud_dashboard/widgets/custom_card.dart';
import 'package:flutter_svg/svg.dart';

class ActivityDetailsCard extends StatelessWidget {
  const ActivityDetailsCard({super.key});

  final List<HealthModel> healthDetails = const [
    HealthModel(
        icon: 'assets/svg/transaction.svg', value: "5000", title: "Transactions monitored"),
    HealthModel(icon: 'assets/svg/anomalies detected.svg', value: "83", title: "Anomalies Detected"),
    HealthModel(
        icon: 'assets/svg/report.svg', value: "83", title: "Alerts Generated"),
    HealthModel(icon: 'assets/svg/Response time.svg', value: "100s", title: "Response Time"),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: healthDetails.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
          crossAxisSpacing: !Responsive.isMobile(context) ? 15 : 12,
          mainAxisSpacing: 12.0),
      itemBuilder: (context, i) {
        return CustomCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Sized SVG with dynamic width and height
              SizedBox(
                width: Responsive.isMobile(context) ? 30 : 40, // Adjust size for mobile/desktop
                height: Responsive.isMobile(context) ? 30 : 40, // Adjust size for mobile/desktop
                child: SvgPicture.asset(
                  healthDetails[i].icon,
                  fit: BoxFit.contain, // Ensures the SVG fits within the SizedBox
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 4),
                child: Text(
                  healthDetails[i].value,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                healthDetails[i].title,
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        );
      },
    );
  }
}