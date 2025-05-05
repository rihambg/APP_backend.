// blood_sugar_model.dart
class BloodSugarReading {
  final int id;
  final double value;
  final String readingType;
  final DateTime date;
  final String? notes;

  BloodSugarReading({
    required this.id,
    required this.value,
    required this.readingType,
    required this.date,
    this.notes,
  });

  factory BloodSugarReading.fromJson(Map<String, dynamic> json) {
    return BloodSugarReading(
      id: json['reading_id'],
      value: json['value'].toDouble(),
      readingType: json['reading_type'],
      date: DateTime.parse(json['measured_at']),
      notes: json['notes'],
    );
  }
}
