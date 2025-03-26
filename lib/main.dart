import 'package:flutter/material.dart';
import 'package:fraud_dashboard/const.dart';
import 'package:fraud_dashboard/dashboard.dart';
import 'package:fraud_dashboard/login_page.dart';
import 'package:fraud_dashboard/register_page.dart';
import 'package:fraud_dashboard/landing_page.dart';
import 'package:fraud_dashboard/transaction_monitoring_page.dart';
import 'package:fraud_dashboard/alert_management.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FraudSense',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: MaterialColor(
          primaryColorCode,
          <int, Color>{
            50: Color(primaryColorCode).withOpacity(0.1),
            100: Color(primaryColorCode).withOpacity(0.2),
            200: Color(primaryColorCode).withOpacity(0.3),
            300: Color(primaryColorCode).withOpacity(0.4),
            400: Color(primaryColorCode).withOpacity(0.5),
            500: Color(primaryColorCode).withOpacity(0.6),
            600: Color(primaryColorCode).withOpacity(0.7),
            700: Color(primaryColorCode).withOpacity(0.8),
            800: Color(primaryColorCode).withOpacity(0.9),
            900: Color(primaryColorCode).withOpacity(1.0),
          },
        ),
        scaffoldBackgroundColor: const Color(0xFF171821),
        fontFamily: 'IBMPlexSans',
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(primaryColorCode),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => DashBoard(),
        '/transaction-monitoring': (context) => const TransactionMonitoringPage(),
        '/alert-management': (context) => const AlertManagementPage(),
      },
    );
  }
}