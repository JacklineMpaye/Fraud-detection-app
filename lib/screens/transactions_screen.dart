import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transactions")),
      body: ListView.builder(
        itemCount: 10, // Replace with API data later
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Transaction #$index"),
            subtitle: Text("Status: Pending"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          );
        },
      ),
    );
  }
}
