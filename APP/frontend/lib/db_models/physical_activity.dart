class PhysicalActivity {
  dynamic idActivity;
  dynamic activityType;
  dynamic period;
  dynamic burnedCalories;
  dynamic dateTimeActivity;
  dynamic idDietPlan;

  PhysicalActivity({
    this.idActivity,
    this.activityType,
    this.period,
    this.burnedCalories,
    this.dateTimeActivity,
    this.idDietPlan,
  });

  factory PhysicalActivity.fromJson(Map<String, dynamic> json) {
    return PhysicalActivity(
      idActivity: json['id_activity'],
      activityType: json['activity_type'],
      period: json['period'],
      burnedCalories: json['burned_calories'],
      dateTimeActivity: json['date_time_activity'],
      idDietPlan: json['id_diet_plan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_activity': idActivity,
      'activity_type': activityType,
      'period': period,
      'burned_calories': burnedCalories,
      'date_time_activity': dateTimeActivity,
      'id_diet_plan': idDietPlan,
    };
  }
}
