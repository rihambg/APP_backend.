class Meal {
  dynamic idMeal;
  dynamic name;
  dynamic calories;
  dynamic mealType;
  dynamic carbs;
  dynamic protein;
  dynamic fat;
  dynamic faber;

  Meal({
    this.idMeal,
    this.name,
    this.calories,
    this.mealType,
    this.carbs,
    this.protein,
    this.fat,
    this.faber,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      idMeal: json['id_meal'],
      name: json['name'],
      calories: json['calories'],
      mealType: json['meal_type'],
      carbs: json['carbs'],
      protein: json['protein'],
      fat: json['fat'],
      faber: json['faber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_meal': idMeal,
      'name': name,
      'calories': calories,
      'meal_type': mealType,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'faber': faber,
    };
  }
}
