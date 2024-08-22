
import 'package:currency_converter_app/widget/historical_rates_widget.dart';
import 'package:flutter/material.dart';
import 'package:currency_converter_app/model/currency.dart';
import 'package:currency_converter_app/service/currency_service.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:currency_converter_app/model/chart.dart';
import 'package:currency_converter_app/model/currency_info.dart';
import 'package:currency_converter_app/model/exchange_rate.dart';
import 'package:currency_converter_app/responsive.dart';
import 'package:currency_converter_app/widget/chart_widget.dart';
import 'package:flutter/services.dart';
import '../helper/database_helper.dart';
import '../model/conversion_history.dart';

class ConverterWidget extends StatefulWidget {
  const ConverterWidget({Key? key}) : super(key: key);

  @override
  _ConverterWidgetState createState() => _ConverterWidgetState();
}

class _ConverterWidgetState extends State<ConverterWidget> {


  final TextEditingController _textEditingController = TextEditingController(text: '1');
  double _amount = 1;
  String _fromCurrency = 'EUR';
  String _toCurrency = 'USD';

  Future<void> _loadBaseCurrencies() async {
    final baseCurrencies = await DatabaseHelper().getBaseCurrencies();
    setState(() {
      _fromCurrency = baseCurrencies['baseCurrency'] ?? 'USD'; // Default to 'USD' if no base currency is set
      _toCurrency = baseCurrencies['secondaryBaseCurrency'] ?? 'EUR'; // Default to 'EUR' if no secondary base currency is set
      generateChartData(_fromCurrency); // Generate chart data with the updated from currency
    });
  }

  Future<List<Currency>> getCurrencyForDropdown = CurrencyService().getCurrencyList();
  Future<Map<String, double?>>? exchangeRatesFuture;
  List<Indicator> chartData = [];

  @override
  void initState() {
    super.initState();
    _loadBaseCurrencies(); // Load base currencies and initialize chart data
  }

  Future<void> generateChartData(String from) async {
    try {
      List<Indicator> indicators = await CurrencyService().getCurrencyChart(from);
      setState(() {
        chartData = indicators;
      });
    } catch (e) {
      print('Error fetching chart data: $e');
    }
  }

  Future<Map<String, double?>> getExchangeRates() async {
    try {
      final forwardRate = await CurrencyService().getExchangeRate(_fromCurrency, _toCurrency, _amount);
      final reverseRate = await CurrencyService().getReverseExchangeRate(_fromCurrency, _toCurrency, _amount);

      return {
        'forwardRate': forwardRate,
        'reverseRate': reverseRate,
      };
    } catch (e) {
      print('Error fetching exchange rates: $e');
      return {'forwardRate': null, 'reverseRate': null};
    }
  }

  Future<void> _saveConversionHistory(double amount, String fromCurrency, String toCurrency, double convertedAmount, double rate) async {
    final history = ConversionHistory(
      date: DateTime.now().toIso8601String(),
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      amount: amount,
      convertedAmount: convertedAmount,
      rate: rate,
    );
    await DatabaseHelper().insertConversionHistory(history);
  }

  void _convert() {
    setState(() {
      exchangeRatesFuture = getExchangeRates();
    });
  }
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: [
          Card(
            elevation: 5,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  child: !Responsive.isSmallScreen(context)
                      ? Container(
                    padding: EdgeInsets.only(top: 50, bottom: 50),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                amountInput(_screenSize, false),
                                SizedBox(width: 16),
                                fromCurrencyInput(_screenSize, false),
                                SizedBox(width: 16),
                                toCurrencyInput(_screenSize, false),
                              ],
                            ),
                            SizedBox(height: 25),
                            Container(
                              width: _screenSize.width / 1.61,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          'We use mid-market rates.',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.info_outline,
                                          color: Colors.grey[600],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: _convert,
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      child: Text('Convert'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            converterView(_screenSize),
                          ],
                        ),
                      ],
                    ),
                  )
                      : Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        amountInput(_screenSize, true),
                        SizedBox(height: 16),
                        fromCurrencyInput(_screenSize, true),
                        SizedBox(height: 16),
                        toCurrencyInput(_screenSize, true),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _convert,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text('Convert'),
                            ),
                          ),
                        ),

                        SizedBox(height: 16),
                        Center(
                          child: Text('Press convert to see the result'),

                        ),
                        SizedBox(height: 30),

                        converterView(_screenSize),

                      ],

                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          // Chart
          ChartWidget(fromCurrency: _fromCurrency, chartData: chartData),
          SizedBox(height: 30),

          HistoricalDataWidget(fromCurrency: _fromCurrency,  toCurrency: _toCurrency,),
          SizedBox(height: 30),
          // Trending list

          // Footer
        ],
      ),
    );
  }

  Container converterView(Size _screenSize) {
    return Container(
      child: FutureBuilder<Map<String, double?>>(
        future: exchangeRatesFuture,
        builder: (context, AsyncSnapshot<Map<String, double?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final double? forwardRate = snapshot.data?['forwardRate'];
            final double? reverseRate = snapshot.data?['reverseRate'];

            if (forwardRate == null || reverseRate == null) {
              return Center(child: Text('Conversion failed. Please try again.'));
            }

            // Save conversion history
            _saveConversionHistory(
              _amount,
              _fromCurrency,
              _toCurrency,
              forwardRate,
              forwardRate, // Assuming rate is used for conversion history
            );

            return Container(
              width: _screenSize.width / 1.61,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Card(
                        elevation: 0,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$_amount $_fromCurrency equals',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${forwardRate.toStringAsFixed(5)} $_toCurrency',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '$_amount $_toCurrency equals',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${reverseRate.toStringAsFixed(5)} $_fromCurrency',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('Press convert to see the result'));
          }
        },
      ),
    );
  }

  Container amountInput(Size _screenSize, bool isSmallScreen) {
    return Container(
      width: !isSmallScreen ? _screenSize.width / 6.5 : double.infinity,
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
        ],
        controller: _textEditingController,
        onChanged: (value) {
          setState(() {
            _amount = double.tryParse(value) ?? 0.0;
          });
        },
        decoration: InputDecoration(
          labelText: 'Amount',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Container fromCurrencyInput(Size _screenSize, bool isSmallScreen) {
    return Container(
      width: !isSmallScreen ? _screenSize.width / 5 : double.infinity,
      child: FutureBuilder<List<Currency>>(
        future: getCurrencyForDropdown,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading currencies'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No currencies available'));
          } else {
            final currencies = snapshot.data!;
            return DropdownSearch<Currency>(
              selectedItem: currencies.firstWhere((c) => c.code == _fromCurrency),
              itemAsString: (Currency c) => '${c.name ?? 'Unknown'} (${c.code ?? 'N/A'})',
              onChanged: (Currency? currency) {
                if (currency != null) {
                  setState(() {
                    _fromCurrency = currency.code ?? 'USD'; // Default to 'USD' if null
                    generateChartData(_fromCurrency);
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
            );
          }
        },
      ),
    );
  }

  Container toCurrencyInput(Size _screenSize, bool isSmallScreen) {
    return Container(
      width: !isSmallScreen ? _screenSize.width / 5 : double.infinity,
      child: FutureBuilder<List<Currency>>(
        future: getCurrencyForDropdown,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading currencies'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No currencies available'));
          } else {
            final currencies = snapshot.data!;
            return DropdownSearch<Currency>(
              selectedItem: currencies.firstWhere((c) => c.code == _toCurrency),
              itemAsString: (Currency c) => '${c.name ?? 'Unknown'} (${c.code ?? 'N/A'})',
              onChanged: (Currency? currency) {
                if (currency != null) {
                  setState(() {
                    _toCurrency = currency.code ?? 'EUR'; // Default to 'EUR' if null
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
            );
          }
        },
      ),
    );
  }
}


