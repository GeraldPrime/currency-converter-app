

import 'package:currency_converter_app/widget/history_widget.dart';
import 'package:flutter/material.dart';

import '../helper/database_helper.dart'; // Import your DatabaseHelper

class HistoryScreen extends StatelessWidget {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _clearHistory(BuildContext context) async {
    await _dbHelper.clearConversionHistory();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Conversion history cleared!'),
    ));

    // You might want to refresh the history list here
    // This can be done by rebuilding the HistoryWidget or navigating back and forth
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Conversion History'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _clearHistory(context),
            tooltip: 'Clear History',
          ),
        ],
      ),
      body: HistoryWidget(), // Your HistoryWidget goes here
    );
  }
}
