import 'package:flutter/material.dart';
import 'package:fraud_dashboard/pages/home/home_page.dart';
import 'package:fraud_dashboard/widgets/menu.dart';
import 'package:fraud_dashboard/Responsive.dart';
import 'package:fraud_dashboard/widgets/profile/profile.dart';
import 'package:fraud_dashboard/transaction_monitoring_page.dart'; // Import the TransactionMonitoringPage

class DashBoard extends StatefulWidget {
  DashBoard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Widget _currentPage = HomePage(scaffoldKey: GlobalKey()); // Default page

  void _changePage(Widget newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: !Responsive.isDesktop(context)
          ? SizedBox(
              width: 250, // Fixed width for the drawer
              child: Menu(
                scaffoldKey: _scaffoldKey,
                changePage: _changePage, // Pass the changePage function
              ),
            )
          : null,
      endDrawer: Responsive.isMobile(context) && _currentPage is HomePage
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const Profile(),
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (Responsive.isDesktop(context))
              SizedBox(
                width: 250, // Fixed width for the menu
                child: Menu(
                  scaffoldKey: _scaffoldKey,
                  changePage: _changePage, // Pass the changePage function
                ),
              ),
            Expanded(
              flex: 8,
              child: _currentPage,
            ),
            if (!Responsive.isMobile(context) && _currentPage is HomePage)
              const Expanded(
                flex: 4,
                child: Profile(),
              ),
          ],
        ),
      ),
    );
  }
}