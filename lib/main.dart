import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fraud_dashboard/dashboard.dart';
import 'package:fraud_dashboard/login_page.dart';
import 'package:fraud_dashboard/register_page.dart';
import 'package:fraud_dashboard/landing_page.dart';
import 'package:fraud_dashboard/transaction_monitoring_page.dart';
import 'package:fraud_dashboard/alert_management.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Load environment variables
    await dotenv.load(fileName: ".env").catchError((error) {
      debugPrint("Error loading .env file: $error");
      return dotenv.load(fileName: "assets/.env");
    });

    
    
    runApp(const MyApp());
  } catch (error, stackTrace) {
    debugPrint("Initialization error: $error");
    debugPrint(stackTrace.toString());
    runApp(const InitializationErrorScreen());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
    
    return MaterialApp(
      title: 'FraudSense',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.cyanAccent,
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

class InitializationErrorScreen extends StatelessWidget {
  const InitializationErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 20),
              const Text('Initialization Error', style: TextStyle(fontSize: 24)),
              ElevatedButton(
                onPressed: () => main(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}