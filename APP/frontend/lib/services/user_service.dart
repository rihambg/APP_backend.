import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = 'http://192.168.1.37:5000/api';

  // Shared Preferences Keys
  static const String _rememberMeKey = 'remember_me';
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';

  static Future<void> saveLoginCredentials(
      String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, true);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
  }

  static Future<void> clearLoginCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, false);
    await prefs.remove(_usernameKey);
    await prefs.remove(_passwordKey);
  }

  static Future<Map<String, String?>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    if (!rememberMe) return {'username': null, 'password': null};

    return {
      'username': prefs.getString(_usernameKey),
      'password': prefs.getString(_passwordKey),
    };
  }

  static Future<Map<String, dynamic>> signupUser({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/signup'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'full_name': fullName,
              'username': username,
              'email': email,
              'password': password,
              'user_type': role.toLowerCase(),
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Signup successful',
          ...jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['error'] ?? 'Failed to signup',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> loginUser({
    required String usernameOrEmail,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username_or_email': usernameOrEmail,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        if (rememberMe) {
          await saveLoginCredentials(usernameOrEmail, password);
        } else {
          await clearLoginCredentials();
        }

        return {
          'success': true,
          'message': 'Login successful',
          ...jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['error'] ?? 'Failed to login',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> completePatientProfile({
    required int userId,
    required Map<String, dynamic> formData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/complete-patient-profile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'gender': formData['gender'],
          'date_of_birth': formData['date_of_birth'],
          'phone_number': formData['phone_number'],
          'diabetes_type': formData['diabetes_type'],
          'height': formData['height'],
          'weight': formData['weight'],
          'emergency_contact_name': formData['emergency_contact_name'],
          'emergency_contact_phone': formData['emergency_contact_phone'],
          'allergies': formData['allergies'],
          'other_conditions': formData['other_conditions'],
          'medications': formData['medications'],
          'pregnancy_status': formData['pregnancy_status'],
          'sugar_intake': formData['sugar_intake'],
          'diet_type': formData['diet_type'],
          'exercise_frequency': formData['exercise_frequency'],
          'smoking': formData['smoking'],
          'alcohol': formData['alcohol'],
          'goals': formData['goals'],
          'reminder_frequency': formData['reminder_frequency'],
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Profile completed successfully',
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['error'] ??
              'Failed to complete profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}
