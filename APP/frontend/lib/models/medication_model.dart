class Medication {
  final String name;
  final String dose;
  final String time;
  final String status;

  Medication({
    required this.name,
    required this.dose,
    required this.time,
    required this.status,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      name: json['name'] as String,
      dose: json['dose'] as String,
      time: json['time'] as String,
      status: json['status'] as String,
    );
  }

  static List<Medication> listFromJson(List<dynamic> list) {
    return list.map((e) => Medication.fromJson(e as Map<String, dynamic>)).toList();
  }
}