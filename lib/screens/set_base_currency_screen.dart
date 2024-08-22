import 'package:flutter/material.dart';
import 'package:currency_converter_app/model/currency.dart';
import 'package:currency_converter_app/service/currency_service.dart';
import 'package:currency_converter_app/helper/database_helper.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SetBaseCurrencyScreen extends StatefulWidget {
  @override
  _SetBaseCurrencyScreenState createState() => _SetBaseCurrencyScreenState();
}

class _SetBaseCurrencyScreenState extends State<SetBaseCurrencyScreen> {
  String _selectedBaseCurrency = 'USD';
  String _selectedSecondaryBaseCurrency = 'EUR';
  late Future<List<Currency>> _currencyListFuture;

  @override
  void initState() {
    super.initState();
    _currencyListFuture = CurrencyService().getCurrencyList();
    _loadBaseCurrencies();
  }

  Future<void> _loadBaseCurrencies() async {
    final baseCurrencies = await DatabaseHelper().getBaseCurrencies();
    setState(() {
      _selectedBaseCurrency = baseCurrencies['baseCurrency'] ?? 'USD';
      _selectedSecondaryBaseCurrency = baseCurrencies['secondaryBaseCurrency'] ?? 'EUR';
    });
  }

  Future<void> _setBaseCurrencies() async {
    await DatabaseHelper().setBaseCurrencies(
      _selectedBaseCurrency,
      _selectedSecondaryBaseCurrency,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Base currencies updated successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Restart Required'),
          content: Text('You need to restart the application for changes to take effect.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text('Set Base Currencies')),
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
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Current Base Currency: $_selectedBaseCurrency',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Current Secondary Base Currency: $_selectedSecondaryBaseCurrency',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      DropdownSearch<Currency>(
                        selectedItem: currencies.firstWhere(
                              (c) => c.code == _selectedBaseCurrency,
                          orElse: () => Currency(code: _selectedBaseCurrency, name: 'Unknown'),
                        ),
                        itemAsString: (Currency c) =>
                        '${c.name ?? 'Unknown'} (${c.code ?? 'N/A'})',
                        onChanged: (Currency? currency) {
                          if (currency != null) {
                            setState(() {
                              _selectedBaseCurrency = currency.code ?? 'USD';
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
                          mainAxisAlignment: MainAxisAlignment.center,
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
                              (c) => c.code == _selectedSecondaryBaseCurrency,
                          orElse: () => Currency(code: _selectedSecondaryBaseCurrency, name: 'Unknown'),
                        ),
                        itemAsString: (Currency c) =>
                        '${c.name ?? 'Unknown'} (${c.code ?? 'N/A'})',
                        onChanged: (Currency? currency) {
                          if (currency != null) {
                            setState(() {
                              _selectedSecondaryBaseCurrency = currency.code ?? 'EUR';
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
                          mainAxisAlignment: MainAxisAlignment.center,
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
                      ElevatedButton(
                        onPressed: _setBaseCurrencies,
                        child: Text('Set Base Currencies'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}


