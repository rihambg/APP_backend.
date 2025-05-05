// meal_model.dart
class MealLog {
  final int id;
  final String mealType;
  final String name;
  final DateTime date;
  final int? calories;
  final int? carbs;
  final int? protein;
  final int? fat;
  final int? sugar;
  final String? notes;

  MealLog({
    required this.id,
    required this.mealType,
    required this.name,
    required this.date,
    this.calories,
    this.carbs,
    this.protein,
    this.fat,
    this.sugar,
    this.notes,
  });

  factory MealLog.fromJson(Map<String, dynamic> json) {
    return MealLog(
      id: json['log_id'],
      mealType: json['meal_type'],
      name: json['name'] ?? 'Custom Meal',
      date: DateTime.parse(json['logged_at']),
      calories: json['calories'],
      carbs: json['carbs'],
      protein: json['protein'],
      fat: json['fat'],
      sugar: json['sugar'],
      notes: json['notes'],
    );
  }
}

class MealRecipe {
  final int id;
  final String title;
  final String? description;
  final List<String> ingredients;
  final String instructions;
  final int? prepTime;
  final int? cookTime;
  final int? servings;
  final String mealType;
  final int? calories;
  final int? carbs;
  final int? protein;
  final int? fat;
  final int? sugar;
  final int? fiber;
  final String? imagePath;

  MealRecipe({
    required this.id,
    required this.title,
    this.description,
    required this.ingredients,
    required this.instructions,
    this.prepTime,
    this.cookTime,
    this.servings,
    required this.mealType,
    this.calories,
    this.carbs,
    this.protein,
    this.fat,
    this.sugar,
    this.fiber,
    this.imagePath,
  });

  factory MealRecipe.fromJson(Map<String, dynamic> json) {
    return MealRecipe(
      id: json['recipe_id'],
      title: json['title'],
      description: json['description'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: json['instructions'],
      prepTime: json['prep_time'],
      cookTime: json['cook_time'],
      servings: json['servings'],
      mealType: json['meal_type'],
      calories: json['calories'],
      carbs: json['carbs'],
      protein: json['protein'],
      fat: json['fat'],
      sugar: json['sugar'],
      fiber: json['fiber'],
      imagePath: json['image_path'],
    );
  }
}
