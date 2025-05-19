class MealEaten {
  dynamic idPatient;
  dynamic idMeal;
  dynamic dateTime;

  MealEaten({
    this.idPatient,
    this.idMeal,
    this.dateTime,
  });

  factory MealEaten.fromJson(Map<String, dynamic> json) {
    return MealEaten(
      idPatient: json['id_patient'],
      idMeal: json['id_meal'],
      dateTime: json['date_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_patient': idPatient,
      'id_meal': idMeal,
      'date_time': dateTime,
    };
  }
}
