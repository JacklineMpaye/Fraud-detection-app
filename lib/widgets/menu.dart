import 'package:flutter/material.dart';
import 'package:fraud_dashboard/Responsive.dart';
import 'package:fraud_dashboard/model/menu_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fraud_dashboard/transaction_monitoring_page.dart'; // Import the TransactionMonitoringPage
import 'package:fraud_dashboard/pages/home/home_page.dart'; // Import the HomePage
import 'package:fraud_dashboard/reporting.dart'; // Import the ReportingPage
import 'package:fraud_dashboard/alert_management.dart';

class Menu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(Widget) changePage; // Add changePage parameter

  const Menu({
    super.key,
    required this.scaffoldKey,
    required this.changePage, // Require changePage
  });

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<MenuModel> menu = [
    MenuModel(icon: 'assets/svg/home.svg', title: "Dashboard"),
    MenuModel(icon: 'assets/svg/transaction.svg', title: "Transaction Monitoring"),
    MenuModel(icon: 'assets/svg/anomaly.svg', title: "Anomaly Detection"),
    MenuModel(icon: 'assets/svg/alert.svg', title: "Alert Management"),
    MenuModel(icon: 'assets/svg/report.svg', title: "Reporting"),
    MenuModel(icon: 'assets/svg/setting.svg', title: "System Configuration"),
    MenuModel(icon: 'assets/svg/data-management.svg', title: "Data Management"),
    MenuModel(icon: 'assets/svg/profile.svg', title: "Profile"),
    MenuModel(icon: 'assets/svg/signout.svg', title: "Signout"),
  ];

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey[800]!,
            width: 1,
          ),
        ),
        color: const Color(0xFF171821),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Responsive.isMobile(context) ? 40 : 80,
              ),
              for (var i = 0; i < menu.length; i++)
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(6.0),
                    ),
                    color: selected == i
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selected = i;
                      });

                      // Close the drawer on mobile after navigation
                      if (Responsive.isMobile(context)) {
                        widget.scaffoldKey.currentState?.closeDrawer();
                      }

                      // Use the changePage callback to update the main content
                      switch (menu[i].title) {
                        
                        case "Dashboard":
                          widget.changePage(HomePage(scaffoldKey: widget.scaffoldKey));
                          break;
                        case "Transaction Monitoring":
                          widget.changePage(const TransactionMonitoringPage());
                          break;
                        case "Anomaly Detection":
                          // widget.changePage(AnomalyDetectionPage()); // Add this page if it exists
                          break;
                        case "Alert Management":
                          widget.changePage(const AlertManagementPage()); // Add this page if it exists
                          break;
                        case "Reporting":
                          widget.changePage(const ReportingPage()); // Navigate to ReportingPage
                          break;
                        case "System Configuration":
                          // widget.changePage(SystemConfigurationPage()); // Add this page if it exists
                          break;
                        case "Data Management":
                          // widget.changePage(DataManagementPage()); // Add this page if it exists
                          break;
                        case "Profile":
                          // widget.changePage(ProfilePage()); // Add this page if it exists
                          break;
                        case "Signout":
                          // Handle signout logic here
                          break;
                        default:
                          break;
                      }
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 7),
                          child: SvgPicture.asset(
                            menu[i].icon,
                            width: 24, // Set a fixed width
                            height: 24, // Set a fixed height
                            color: selected == i ? Colors.black : Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            menu[i].title,
                            style: TextStyle(
                                fontSize: 16,
                                color: selected == i ? Colors.black : Colors.grey,
                                fontWeight: selected == i
                                    ? FontWeight.w600
                                    : FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}