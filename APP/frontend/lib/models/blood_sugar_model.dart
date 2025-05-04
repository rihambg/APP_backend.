class BloodSugarReading {
  final DateTime date;
  final double value;

  BloodSugarReading({
    required this.date,
    required this.value,
  });

  factory BloodSugarReading.fromJson(Map<String, dynamic> json) {
    return BloodSugarReading(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
    );
  }

  static List<BloodSugarReading> listFromJson(List<dynamic> list) {
    return list
        .map((e) => BloodSugarReading.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}