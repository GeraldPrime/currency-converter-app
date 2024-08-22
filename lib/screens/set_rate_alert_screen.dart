

import 'package:flutter/material.dart';
import 'package:currency_converter_app/model/currency.dart';
import 'package:currency_converter_app/model/rate_alert.dart';
import 'package:currency_converter_app/service/currency_service.dart';
// import 'package:currency_converter_app/service/database_helper.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../helper/database_helper.dart';

class SetRateAlertScreen extends StatefulWidget {
  @override
  _SetRateAlertScreenState createState() => _SetRateAlertScreenState();
}

class _SetRateAlertScreenState extends State<SetRateAlertScreen> {
  String _selectedFromCurrency = 'USD';
  String _selectedToCurrency = 'EUR';
  double _threshold = 0.0;
  late Future<List<Currency>> _currencyListFuture;
  late Future<List<RateAlert>> _rateAlertsFuture;

  @override
  void initState() {
    super.initState();
    _currencyListFuture = CurrencyService().getCurrencyList();
    _rateAlertsFuture = DatabaseHelper().getRateAlerts();
  }

  Future<void> _setRateAlert() async {
    final newAlert = RateAlert(
      fromCurrency: _selectedFromCurrency,
      toCurrency: _selectedToCurrency,
      threshold: _threshold,
      notify: true,
    );

    await DatabaseHelper().insertRateAlert(newAlert);

    // Refresh the list of alerts
    setState(() {
      _rateAlertsFuture = DatabaseHelper().getRateAlerts();
    });

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rate alert set successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _deleteRateAlert(int id) async {
    await DatabaseHelper().deleteRateAlert(id);

    // Refresh the list of alerts
    setState(() {
      _rateAlertsFuture = DatabaseHelper().getRateAlerts();
    });

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rate alert deleted successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     resizeToAvoidBottomInset: true,
  //     extendBodyBehindAppBar: true,
  //     appBar: AppBar(title: Text('Set Rate Alert')),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: FutureBuilder<List<Currency>>(
  //         future: _currencyListFuture,
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return Center(child: CircularProgressIndicator());
  //           } else if (snapshot.hasError) {
  //             return Center(child: Text('Error loading currencies'));
  //           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //             return Center(child: Text('No currencies available'));
  //           } else {
  //             final currencies = snapshot.data!;
  //             return Column(
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [
  //                 DropdownSearch<Currency>(
  //                   selectedItem: currencies.firstWhere(
  //                           (c) => c.code == _selectedFromCurrency),
  //                   itemAsString: (Currency c) =>
  //                   '${c.name ?? 'Unknown'} (${c.code ?? 'N/A'})',
  //                   onChanged: (Currency? currency) {
  //                     if (currency != null) {
  //                       setState(() {
  //                         _selectedFromCurrency = currency.code ?? 'USD';
  //                       });
  //                     }
  //                   },
  //                   asyncItems: (String filter) async {
  //                     return currencies
  //                         .where((c) =>
  //                     (c.name?.toLowerCase().contains(filter.toLowerCase()) ?? false) ||
  //                         (c.code?.toLowerCase().contains(filter.toLowerCase()) ?? false))
  //                         .toList();
  //                   },
  //                   dropdownBuilder: (context, currency) => Row(
  //                     children: [
  //                       ConstrainedBox(
  //                         constraints: BoxConstraints(
  //                           minWidth: 22,
  //                           minHeight: 22,
  //                           maxWidth: 22,
  //                           maxHeight: 22,
  //                         ),
  //                         child: Image.asset(
  //                           'assets/images/${currency?.code?.toLowerCase() ?? 'default'}.png',
  //                           errorBuilder: (context, error, stackTrace) {
  //                             return Icon(Icons.error, size: 22);
  //                           },
  //                         ),
  //                       ),
  //                       SizedBox(width: 5),
  //                       Text('${currency?.name ?? 'Unknown'} (${currency?.code ?? 'N/A'})'),
  //                     ],
  //                   ),
  //                   popupProps: PopupProps.menu(
  //                     showSearchBox: true,
  //                     searchFieldProps: TextFieldProps(
  //                       decoration: InputDecoration(
  //                         hintText: 'Search currency',
  //                         border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 16),
  //                 DropdownSearch<Currency>(
  //                   selectedItem: currencies.firstWhere(
  //                           (c) => c.code == _selectedToCurrency),
  //                   itemAsString: (Currency c) =>
  //                   '${c.name ?? 'Unknown'} (${c.code ?? 'N/A'})',
  //                   onChanged: (Currency? currency) {
  //                     if (currency != null) {
  //                       setState(() {
  //                         _selectedToCurrency = currency.code ?? 'EUR';
  //                       });
  //                     }
  //                   },
  //                   asyncItems: (String filter) async {
  //                     return currencies
  //                         .where((c) =>
  //                     (c.name?.toLowerCase().contains(filter.toLowerCase()) ?? false) ||
  //                         (c.code?.toLowerCase().contains(filter.toLowerCase()) ?? false))
  //                         .toList();
  //                   },
  //                   dropdownBuilder: (context, currency) => Row(
  //                     children: [
  //                       ConstrainedBox(
  //                         constraints: BoxConstraints(
  //                           minWidth: 22,
  //                           minHeight: 22,
  //                           maxWidth: 22,
  //                           maxHeight: 22,
  //                         ),
  //                         child: Image.asset(
  //                           'assets/images/${currency?.code?.toLowerCase() ?? 'default'}.png',
  //                           errorBuilder: (context, error, stackTrace) {
  //                             return Icon(Icons.error, size: 22);
  //                           },
  //                         ),
  //                       ),
  //                       SizedBox(width: 5),
  //                       Text('${currency?.name ?? 'Unknown'} (${currency?.code ?? 'N/A'})'),
  //                     ],
  //                   ),
  //                   popupProps: PopupProps.menu(
  //                     showSearchBox: true,
  //                     searchFieldProps: TextFieldProps(
  //                       decoration: InputDecoration(
  //                         hintText: 'Search currency',
  //                         border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 16),
  //                 TextField(
  //                   decoration: InputDecoration(
  //                     labelText: 'Threshold Rate',
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                   ),
  //                   keyboardType: TextInputType.number,
  //                   onChanged: (value) {
  //                     setState(() {
  //                       _threshold = double.tryParse(value) ?? 0.0;
  //                     });
  //                   },
  //                 ),
  //                 SizedBox(height: 16),
  //                 ElevatedButton(
  //                   onPressed: _setRateAlert,
  //                   child: Text('Set Alert'),
  //                 ),
  //                 SizedBox(height: 16),
  //                 FutureBuilder<List<RateAlert>>(
  //                   future: _rateAlertsFuture,
  //                   builder: (context, snapshot) {
  //                     if (snapshot.connectionState == ConnectionState.waiting) {
  //                       return Center(child: CircularProgressIndicator());
  //                     } else if (snapshot.hasError) {
  //                       return Center(child: Text('Error loading alerts'));
  //                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //                       return Center(child: Text('No rate alerts set'));
  //                     } else {
  //                       final rateAlerts = snapshot.data!;
  //                       return Column(
  //                         children: rateAlerts.map((alert) {
  //                           return ListTile(
  //                             title: Text(
  //                                 '${alert.fromCurrency} to ${alert.toCurrency} at ${alert.threshold}'),
  //                             trailing: IconButton(
  //                               icon: Icon(Icons.delete),
  //                               onPressed: () => _deleteRateAlert(alert.id!),
  //                             ),
  //                           );
  //                         }).toList(),
  //                       );
  //                     }
  //                   },
  //                 ),
  //               ],
  //             );
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text('Set Rate Alert')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Currency>>(
            future: _currencyListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error loading currencies');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No currencies available');
              } else {
                final currencies = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the content
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownSearch<Currency>(
                      selectedItem: currencies.firstWhere(
                              (c) => c.code == _selectedFromCurrency),
                      itemAsString: (Currency c) =>
                      '${c.name ?? 'Unknown'} (${c.code ?? 'N/A'})',
                      onChanged: (Currency? currency) {
                        if (currency != null) {
                          setState(() {
                            _selectedFromCurrency = currency.code ?? 'USD';
                          });
                        }
                      },
                      asyncItems: (String filter) async {
                        return currencies
                            .where((c) =>
                        (c.name?.toLowerCase().contains(filter.toLowerCase()) ?? false) ||
                            (c.code?.toLowerCase().contains(filter.toLowerCase()) ?? false))
                            .toList();
                      },
                      dropdownBuilder: (context, currency) => Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 22,
                              minHeight: 22,
                              maxWidth: 22,
                              maxHeight: 22,
                            ),
                            child: Image.asset(
                              'assets/images/${currency?.code?.toLowerCase() ?? 'default'}.png',
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error, size: 22);
                              },
                            ),
                          ),
                          SizedBox(width: 5),
                          Text('${currency?.name ?? 'Unknown'} (${currency?.code ?? 'N/A'})'),
                        ],
                      ),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search currency',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownSearch<Currency>(
                      selectedItem: currencies.firstWhere(
                              (c) => c.code == _selectedToCurrency),
                      itemAsString: (Currency c) =>
                      '${c.name ?? 'Unknown'} (${c.code ?? 'N/A'})',
                      onChanged: (Currency? currency) {
                        if (currency != null) {
                          setState(() {
                            _selectedToCurrency = currency.code ?? 'EUR';
                          });
                        }
                      },
                      asyncItems: (String filter) async {
                        return currencies
                            .where((c) =>
                        (c.name?.toLowerCase().contains(filter.toLowerCase()) ?? false) ||
                            (c.code?.toLowerCase().contains(filter.toLowerCase()) ?? false))
                            .toList();
                      },
                      dropdownBuilder: (context, currency) => Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 22,
                              minHeight: 22,
                              maxWidth: 22,
                              maxHeight: 22,
                            ),
                            child: Image.asset(
                              'assets/images/${currency?.code?.toLowerCase() ?? 'default'}.png',
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error, size: 22);
                              },
                            ),
                          ),
                          SizedBox(width: 5),
                          Text('${currency?.name ?? 'Unknown'} (${currency?.code ?? 'N/A'})'),
                        ],
                      ),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search currency',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Threshold Rate',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _threshold = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _setRateAlert,
                      child: Text('Set Alert'),
                    ),
                    SizedBox(height: 16),
                    FutureBuilder<List<RateAlert>>(
                      future: _rateAlertsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error loading alerts');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Text('No rate alerts set');
                        } else {
                          final rateAlerts = snapshot.data!;
                          return Column(
                            children: rateAlerts.map((alert) {
                              return ListTile(
                                title: Text(
                                    '${alert.fromCurrency} to ${alert.toCurrency} at ${alert.threshold}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _deleteRateAlert(alert.id!),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

}
