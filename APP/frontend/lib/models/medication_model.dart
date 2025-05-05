// medication_model.dart
class Medication {
  final int id;
  final String name;
  final String dosage;
  final String time;
  final String status;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.status,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['schedule_id'],
      name: json['medication_name'],
      dosage: json['dosage'],
      time: json['specific_times'],
      status: json['status'] ?? 'pending',
    );
  }
}
