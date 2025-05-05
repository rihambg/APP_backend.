import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/blood_sugar_model.dart';
import '../models/medication_model.dart';
import '../models/activity_model.dart';
import '../models/meal_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.34:5000/api';

  static Future<List<BloodSugarReading>> fetchBloodSugar() async {
    final response = await http.get(Uri.parse('$baseUrl/blood_sugar'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => BloodSugarReading.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load blood sugar readings');
    }
  }

  static Future<List<Medication>> fetchMedications() async {
    final response = await http.get(Uri.parse('$baseUrl/medications'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Medication.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load medications');
    }
  }

  static Future<List<ActivityLog>> fetchActivities() async {
    final response = await http.get(Uri.parse('$baseUrl/activities'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => ActivityLog.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load activities');
    }
  }

  static Future<List<MealLog>> fetchMeals() async {
    final response = await http.get(Uri.parse('$baseUrl/meals'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => MealLog.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  static Future<List<MealRecipe>> fetchRecipes() async {
    final response = await http.get(Uri.parse('$baseUrl/recipes'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => MealRecipe.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  static Future<Map<String, dynamic>> fetchPatientDetails() async {
    final response = await http.get(Uri.parse('$baseUrl/patient_details'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load patient details');
    }
  }

  static Future<void> logBloodSugar(double value, String readingType) async {
    final response = await http.post(
      Uri.parse('$baseUrl/blood_sugar'),
      body: jsonEncode({
        'value': value,
        'reading_type': readingType,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to log blood sugar');
    }
  }

  static Future<void> logActivity(
    String activityType,
    int durationMinutes,
    int? steps,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/activities'),
      body: jsonEncode({
        'activity_type': activityType,
        'duration_minutes': durationMinutes,
        'steps': steps,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to log activity');
    }
  }

  static Future<void> logMeal(
    String mealType,
    String name,
    int calories,
    int carbs,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/meals'),
      body: jsonEncode({
        'meal_type': mealType,
        'name': name,
        'calories': calories,
        'carbs': carbs,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to log meal');
    }
  }

  static Future<void> addMedication(
    String name,
    String dosage,
    String time,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/medications'),
      body: jsonEncode({
        'medication_name': name,
        'dosage': dosage,
        'specific_times': time,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add medication');
    }
  }
}
