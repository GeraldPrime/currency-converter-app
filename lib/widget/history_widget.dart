import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/database_helper.dart';
import '../model/conversion_history.dart';

class HistoryWidget extends StatefulWidget {
  @override
  _HistoryWidgetState createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  late Future<List<ConversionHistory>> _history;

  @override
  void initState() {
    super.initState();
    _history = DatabaseHelper().getConversionHistory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ConversionHistory>>(
      future: _history,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No history found'));
        } else {
          final history = snapshot.data!;
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                title: Text('${item.amount} ${item.fromCurrency} = ${item.convertedAmount} ${item.toCurrency}'),
                subtitle: Text('Rate: ${item.rate} | Date: ${item.date}'),
              );
            },
          );
        }
      },
    );
  }
}
