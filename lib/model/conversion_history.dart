class ConversionHistory {
  final String date;
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double convertedAmount;
  final double rate;

  ConversionHistory({
    required this.date,
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.convertedAmount,
    required this.rate,
  });

  factory ConversionHistory.fromJson(Map<String, dynamic> json) {
    return ConversionHistory(
      date: json['date'] as String,
      fromCurrency: json['fromCurrency'] as String,
      toCurrency: json['toCurrency'] as String,
      amount: json['amount'] as double,
      convertedAmount: json['convertedAmount'] as double,
      rate: json['rate'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'amount': amount,
      'convertedAmount': convertedAmount,
      'rate': rate,
    };
  }
}
