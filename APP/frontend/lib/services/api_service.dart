import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/blood_sugar_model.dart';
import '../models/medication_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.36:5000/api';

  /// Fetches list of blood sugar readings from backend
  static Future<List<BloodSugarReading>> fetchBloodSugar() async {
    final response = await http.get(Uri.parse('\$baseUrl/blood_sugar'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return BloodSugarReading.listFromJson(data);
    } else {
      throw Exception('Failed to load blood sugar data');
    }
  }

  /// Fetches list of today's medications from backend
  static Future<List<Medication>> fetchMedications() async {
    final response = await http.get(Uri.parse('\$baseUrl/medications/today'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return Medication.listFromJson(data);
    } else {
      throw Exception('Failed to load medications');
    }
  }
}
