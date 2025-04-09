import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Add this import
import 'package:fraud_dashboard/dashboard.dart';
import 'package:fraud_dashboard/login_page.dart';
import 'package:fraud_dashboard/register_page.dart';
import 'package:fraud_dashboard/landing_page.dart';
import 'package:fraud_dashboard/transaction_monitoring_page.dart';
import 'package:fraud_dashboard/alert_management.dart';

Future<void> main() async {
  // Ensure Widgets binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
   await dotenv.load(fileName: "assets/.env");  // Updated path
  
  
  print("My API is at: ${dotenv.env['API_URL']}");
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access API_URL anywhere in your app
    final apiUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
    debugPrint('API URL: $apiUrl'); // Verify in console

    return MaterialApp(
      title: 'FraudSense',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        // ... (keep your existing theme data)
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