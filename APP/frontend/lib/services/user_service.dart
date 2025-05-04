import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  static const String baseUrl = 'http://192.168.1.37:5000/api';

  static Future<Map<String, dynamic>> signupUser({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final uri = Uri.parse('http://192.168.1.37:5000/api/signup');
      print('Attempting to call: $uri'); // Debug print

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'full_name': fullName,
              'username': username,
              'email': email,
              'password': password,
              'user_type': role.toLowerCase(),
            }),
          )
          .timeout(const Duration(seconds: 30)); // Increased timeout

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Signup successful',
          ...jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to signup: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error in signup: $e'); // Debug print
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> loginUser({
    required String usernameOrEmail,
    required String password,
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
        return {
          'success': true,
          'message': 'Login successful',
          ...jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to login: ${response.statusCode}',
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
