class RateAlert {
  final int? id;
  final String fromCurrency;
  final String toCurrency;
  final double threshold;
  final bool notify;

  RateAlert({
    this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.threshold,
    this.notify = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'threshold': threshold,
      'notify': notify,
    };
  }

  factory RateAlert.fromJson(Map<String, dynamic> json) {
    return RateAlert(
      id: json['id'],
      fromCurrency: json['fromCurrency'],
      toCurrency: json['toCurrency'],
      threshold: json['threshold'],
      notify: json['notify'] == 1,
    );
  }
}
