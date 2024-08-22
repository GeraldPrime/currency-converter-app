import 'dart:convert';

import 'package:currency_converter_app/model/chart.dart';
import 'package:currency_converter_app/model/currency.dart';
import 'package:currency_converter_app/model/currency_info.dart';
import 'package:currency_converter_app/model/exchange_rate.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'dart:convert';

class CurrencyService {
  Dio _dio = Dio();

  Future<List<Currency>> getCurrencyList() async {
    try {
      final response = await rootBundle.loadString('assets/data/currency.json');
      var data = jsonDecode(response) as List;
      List<Currency> currencies =
          data.map((json) => Currency.fromJson(json)).toList();

      return currencies;
    } catch (error) {
      print(error);
      return List.empty();
    }
  }




  final String apiKey = '6aa8c59db4msh49eb09108d8f9fcp145a93jsnb4cded6c285c';
  final String apiHost = 'currency-converter-by-api-ninjas.p.rapidapi.com';

  Future<CurrencyInfo> getCurrencyInfo(String symbol) async {
    final String url =
        'https://currency-converter-by-api-ninjas.p.rapidapi.com/v1/convertcurrency?have=$symbol&want=USD&amount=1';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'x-rapidapi-key': apiKey,
          'x-rapidapi-host': apiHost,
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // Assuming the response contains necessary information for CurrencyInfo
        return CurrencyInfo.fromJson(json);
      } else {
        print('Failed to fetch currency info: ${response.statusCode}');
        return CurrencyInfo();
      }
    } catch (error) {
      print('Error fetching currency info: $error');
      return CurrencyInfo();
    }
  }





  Future<double?> getExchangeRate(String fromCurrency, String toCurrency, double amount) async {
    final String url = 'https://currency-converter18.p.rapidapi.com/api/v1/convert?from=$fromCurrency&to=$toCurrency&amount=$amount';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'x-rapidapi-key': '6aa8c59db4msh49eb09108d8f9fcp145a93jsnb4cded6c285c',
          'x-rapidapi-host': 'currency-converter18.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Debugging: Print the response body to verify structure
        print('Response body: ${response.body}');

        // Extracting the converted amount from the response
        if (data.containsKey('result') && data['result'] is Map<String, dynamic>) {
          final result = data['result'] as Map<String, dynamic>;
          if (result.containsKey('convertedAmount') && result['convertedAmount'] is num) {
            final double convertedAmount = (result['convertedAmount'] as num).toDouble();
            return convertedAmount;
          } else {
            print('Converted amount not found in the result.');
            return null;
          }
        } else {
          print('Unexpected response format: ${data}');
          return null;
        }
      } else {
        print('Failed to fetch exchange rate: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error fetching exchange rate: $error');
      return null;
    }
  }




  Future<double?> getReverseExchangeRate(String fromCurrency, String toCurrency, double amount) async {
    // First, get the forward exchange rate
    final double? forwardAmount = await getExchangeRate(fromCurrency, toCurrency, amount);

    if (forwardAmount != null) {
      // Calculate the forward exchange rate
      final double forwardRate = forwardAmount / amount;

      // Calculate the reverse exchange rate
      final double reverseRate = 1 / forwardRate;

      // Calculate the amount in reverse currency
      final double reverseAmount = amount * reverseRate;
      return reverseAmount;
    }

    return null;
  }












  // ====================Original===========================


  

  Future<List<Indicator>> getCurrencyChart(String symbol) async {
    final String fromDate = '1569880800';
    DateTime date = DateTime.now();
    var now = date.toUtc().millisecondsSinceEpoch;
    final String url =
        'https://query2.finance.yahoo.com/v8/finance/chart/$symbol=X?symbol=$symbol=X&period1=$fromDate&period2=$now&useYfid=true&interval=1d&includePrePost=true';

    try {
      final response = await _dio.get(url);
      final timestamp =
          response.data['chart']['result'][0]['timestamp'] as List;
      final adjclose = response.data['chart']['result'][0]['indicators']
          ['adjclose'][0]['adjclose'] as List;

      Indicator indicator = Indicator();
      List<Indicator> indicatorList = [];
      int index = 0;
      timestamp.forEach((element) {
        indicator = Indicator();
        indicator.timestamp = element;
        indicator.adjclose = adjclose[index];
        indicatorList.add(indicator);
        index++;
      });

      return indicatorList;
    } catch (error) {
      print(error);
      return List.empty();
    }
  }







// Fetch historical data
  Future<List<Indicator>> getHistoricalData(String symbol, String toCurrency) async {
    final data = await getCurrencyChart(symbol);
    return data;
  }

// Calculate statistics for given historical data
  Map<String, Map<String, double>> calculateStatistics(List<Indicator> data) {
    Map<String, Map<String, double>> stats = {
      '30_days': {'high': double.negativeInfinity, 'low': double.infinity, 'average': 0, 'volatility': 0},
      '90_days': {'high': double.negativeInfinity, 'low': double.infinity, 'average': 0, 'volatility': 0},
    };

    List<double> last30Days = [];
    List<double> last90Days = [];

    // Assume data is sorted by timestamp in ascending order
    for (var indicator in data) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(indicator.timestamp! * 1000);
      if (DateTime.now().difference(date).inDays <= 30) {
        last30Days.add(indicator.adjclose!.toDouble());
      }
      if (DateTime.now().difference(date).inDays <= 90) {
        last90Days.add(indicator.adjclose!.toDouble());
      }
    }

    // Calculate statistics for 30 days
    if (last30Days.isNotEmpty) {
      stats['30_days']!['high'] = last30Days.reduce((a, b) => a > b ? a : b);
      stats['30_days']!['low'] = last30Days.reduce((a, b) => a < b ? a : b);
      stats['30_days']!['average'] = last30Days.reduce((a, b) => a + b) / last30Days.length;
      stats['30_days']!['volatility'] = calculateVolatility(last30Days);
    }

    // Calculate statistics for 90 days
    if (last90Days.isNotEmpty) {
      stats['90_days']!['high'] = last90Days.reduce((a, b) => a > b ? a : b);
      stats['90_days']!['low'] = last90Days.reduce((a, b) => a < b ? a : b);
      stats['90_days']!['average'] = last90Days.reduce((a, b) => a + b) / last90Days.length;
      stats['90_days']!['volatility'] = calculateVolatility(last90Days);
    }

    return stats;
  }

  double calculateVolatility(List<double> data) {
    double mean = data.reduce((a, b) => a + b) / data.length;
    double variance = data.map((x) => (x - mean) * (x - mean)).reduce((a, b) => a + b) / data.length;
    return (sqrt(variance) / mean) * 100;
  }




}

