
import 'package:flutter/material.dart';
import 'package:currency_converter_app/service/currency_service.dart';
import '../model/chart.dart'; // Update to your actual path

class HistoricalDataWidget extends StatefulWidget {
  final String fromCurrency;
  final String toCurrency;

  HistoricalDataWidget({required this.fromCurrency, required this.toCurrency});

  @override
  _HistoricalDataWidgetState createState() => _HistoricalDataWidgetState();
}

class _HistoricalDataWidgetState extends State<HistoricalDataWidget> {
  bool _showFullHistory = false;

  Future<List<Indicator>> _fetchHistoricalData() async {
    try {
      return await CurrencyService().getHistoricalData(widget.fromCurrency, widget.toCurrency);
    } catch (e) {
      print('Error fetching historical data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Indicator>>(
      future: _fetchHistoricalData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading historical data: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final List<Indicator>? data = snapshot.data;
          if (data == null || data.isEmpty) {
            return Center(child: Text('No historical data available'));
          }

          // Sort the data in reverse order (most recent first)
          data.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

          // Display the historical data in a table format
          return Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Historical Rates from ${widget.fromCurrency} to ${widget.toCurrency}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                DataTable(
                  columns: [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Rate')),
                  ],
                  rows: data
                      .take(_showFullHistory ? data.length : 20) // Show full history or first 20 records
                      .map((indicator) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(indicator.timestamp! * 1000);
                    return DataRow(
                      cells: [
                        DataCell(Text('${date.toLocal()}')),
                        DataCell(Text(indicator.adjclose?.toStringAsFixed(2) ?? 'N/A')),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                if (data.length > 20)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showFullHistory = !_showFullHistory;
                      });
                    },
                    child: Text(
                      _showFullHistory ? 'Show Less' : 'View Full History',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No historical data available'));
        }
      },
    );
  }
}
