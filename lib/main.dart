import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_dotenv/flutter_dotenv.dart';
=======
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Add this import
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
import 'package:fraud_dashboard/dashboard.dart';
import 'package:fraud_dashboard/login_page.dart';
import 'package:fraud_dashboard/register_page.dart';
import 'package:fraud_dashboard/landing_page.dart';
import 'package:fraud_dashboard/transaction_monitoring_page.dart';
import 'package:fraud_dashboard/alert_management.dart';

Future<void> main() async {
<<<<<<< HEAD
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

=======
  // Ensure Widgets binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
   await dotenv.load(fileName: "assets/.env");  // Updated path
  
  
  print("My API is at: ${dotenv.env['API_URL']}");
  runApp(MyApp());
}
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final apiUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
    
=======
    // Access API_URL anywhere in your app
    final apiUrl = dotenv.env['API_URL'] ?? 'http://10.0.2.2:3000';
    debugPrint('API URL: $apiUrl'); // Verify in console

>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
    return MaterialApp(
      title: 'FraudSense',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
<<<<<<< HEAD
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.cyanAccent,
        ),
=======
      theme: ThemeData(
        // ... (keep your existing theme data)
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
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
<<<<<<< HEAD
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
=======
>>>>>>> 002338a766dcd3a3ddd3168266534321a68e063f
}