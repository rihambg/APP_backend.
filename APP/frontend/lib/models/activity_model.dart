// activity_model.dart
class ActivityLog {
  final int id;
  final String activityType;
  final int durationMinutes;
  final int? steps;
  final double? distanceKm;
  final int caloriesBurned;
  final DateTime date;

  ActivityLog({
    required this.id,
    required this.activityType,
    required this.durationMinutes,
    this.steps,
    this.distanceKm,
    required this.caloriesBurned,
    required this.date,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['activity_id'],
      activityType: json['activity_type'],
      durationMinutes: json['duration_minutes'],
      steps: json['steps'],
      distanceKm: json['distance_km']?.toDouble(),
      caloriesBurned: json['calories_burned'],
      date: DateTime.parse(json['logged_at']),
    );
  }

  get calories => null;
}
