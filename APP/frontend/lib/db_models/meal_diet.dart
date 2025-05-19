class MealDiet {
  dynamic idMeal;
  dynamic idDietPlan;

  MealDiet({
    this.idMeal,
    this.idDietPlan,
  });

  factory MealDiet.fromJson(Map<String, dynamic> json) {
    return MealDiet(
      idMeal: json['id_meal'],
      idDietPlan: json['id_diet_plan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_meal': idMeal,
      'id_diet_plan': idDietPlan,
    };
  }
}
