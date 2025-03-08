// import 'package:english_words/english_words.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'routes.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => MyAppState(),
//       child: MaterialApp(
//         title: 'Namer App',
//         theme: ThemeData(
//           useMaterial3: true,
//           primarySwatch: Colors.blue,
//           //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
//         ),
//         home: const MyHomePage(),
//       ),
//     );
//   }
// }

// // class MyAppState extends ChangeNotifier {
// //   var current = WordPair.random();

// //   void generateNewWord() {
// //     current = WordPair.random();
// //     notifyListeners(); // Notify the UI to rebuild
// //   }
// // }

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Random Namer')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('A random idea:'),
//             Text(
//               appState.current.asLowerCase(), // Fixed function call
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 appState.generateNewWord(); // Generate a new word
//               },
//               child: const Text('New Word'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Financial Security App',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: HomePage(),
// //     );
// //   }
// // }

// // class HomePage extends StatefulWidget {
// //   @override
// //   _HomePageState createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage> {
// //   int _selectedIndex = 0;

// //   static List<Widget> _widgetOptions = <Widget>[
// //     TransactionMonitoringPage(),
// //     AnomalyDetectionPage(),
// //     AlertManagementPage(),
// //     ReportingPage(),
// //   ];

// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Financial Security App'),
// //       ),
// //       body: Center(
// //         child: _widgetOptions.elementAt(_selectedIndex),
// //       ),
// //       bottomNavigationBar: BottomNavigationBar(
// //         items: const <BottomNavigationBarItem>[
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.monitor),
// //             label: 'Transaction Monitoring',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.search),
// //             label: 'Anomaly Detection',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.notifications),
// //             label: 'Alert Management',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.report),
// //             label: 'Reporting',
// //           ),
// //         ],
// //         currentIndex: _selectedIndex,
// //         selectedItemColor: Colors.blue,
// //         onTap: _onItemTapped,
// //       ),
// //     );
// //   }
// // }

// // class TransactionMonitoringPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: Colors.red[100],
// //       child: Center(
// //         child: Text(
// //           'Transaction Monitoring',
// //           style: TextStyle(fontSize: 24, color: Colors.red),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class AnomalyDetectionPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: Colors.blue[100],
// //       child: Center(
// //         child: Text(
// //           'Anomaly Detection',
// //           style: TextStyle(fontSize: 24, color: Colors.blue),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class AlertManagementPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: Colors.green[100],
// //       child: Center(
// //         child: Text(
// //           'Alert Management',
// //           style: TextStyle(fontSize: 24, color: Colors.green),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class ReportingPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: Colors.orange[100],
// //       child: Center(
// //         child: Text(
// //           'Reporting',
// //           style: TextStyle(fontSize: 24, color: Colors.orange),
// //         ),
// //       ),
// //     );
// //   }
// // }


// // // This code sets up a basic Flutter app with a bottom navigation bar to switch between different pages. Each page corresponds to one of the services mentioned in your architecture:

// // // - **Transaction Monitoring (Red)**
// // // - **Anomaly Detection (Blue)**
// // // - **Alert Management (Green)**
// // // - **Reporting (Orange)**

// // // Each page is color-coded as per your description. You can expand each page with more detailed UI and functionality as needed.

import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(FraudDetectionApp());
}

class FraudDetectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fraud Detection System',
      initialRoute: '/',
      routes: routes,
    );
  }
}
