import 'package:flutter/material.dart';
import 'package:fraud_dashboard/Responsive.dart';
import 'package:fraud_dashboard/model/menu_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fraud_dashboard/transaction_monitoring_page.dart';
import 'package:fraud_dashboard/pages/home/home_page.dart';
import 'package:fraud_dashboard/reporting.dart';
import 'package:fraud_dashboard/alert_management.dart';
import 'package:fraud_dashboard/services/auth_service.dart';

class Menu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(Widget) changePage;

  const Menu({
    super.key,
    required this.scaffoldKey,
    required this.changePage,
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
    MenuModel(icon: 'assets/svg/signout.svg', title: "Signout"),
  ];

  int selected = 0;

  Future<void> _handleSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        await AuthService.signOut();

        // Navigate to landing page and clear stack
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', // Replace with your landing page route if different
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        Navigator.of(context).pop(); // Dismiss loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signout failed: ${e.toString()}')),
        );
      }
    }
  }

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

                      if (Responsive.isMobile(context)) {
                        widget.scaffoldKey.currentState?.closeDrawer();
                      }

                      switch (menu[i].title) {
                        case "Dashboard":
                          widget.changePage(HomePage(scaffoldKey: widget.scaffoldKey));
                          break;
                        case "Transaction Monitoring":
                          widget.changePage(const TransactionMonitoringPage());
                          break;
                        case "Anomaly Detection":
                          // widget.changePage(AnomalyDetectionPage());
                          break;
                        case "Alert Management":
                          widget.changePage(const AlertManagementPage());
                          break;
                        case "Reporting":
                          widget.changePage(const ReportingPage());
                          break;
                        case "Signout":
                          _handleSignOut(context);
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
                            width: 24,
                            height: 24,
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