class BloodSugarReading {
  final DateTime date;
  final double value;

  BloodSugarReading({required this.date, required this.value});

  factory BloodSugarReading.fromJson(Map<String, dynamic> json) {
    return BloodSugarReading(
      date: DateTime.parse(json['date']),
      value: (json['value'] as num).toDouble(),
    );
  }
}