import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transactions_screen.dart';

final Map<String, WidgetBuilder> routes = {
  "/": (context) => LoginScreen(),
  "/dashboard": (context) => DashboardScreen(),
  "/transactions": (context) => TransactionsScreen(),
};
