import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorService {
  static const String baseUrl = 'http://192.168.1.34:5000/api';

  static Future<bool> completeDoctorProfile({
    required int userId,
    required String phoneNumber,
    required String experience,
    required String professionalId,
    required String hospital,
    required String country,
    required String city,
    required String? documentPath,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/complete-doctor-profile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'phone_number': phoneNumber,
          'experience_years': experience,
          'license_number': professionalId,
          'hospital_clinic_name': hospital,
          'country': country,
          'city': city,
          'document_base64':
              documentPath != null ? await _fileToBase64(documentPath) : null,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error in doctor profile completion: $e');
      return false;
    }
  }

  static Future<String?> _fileToBase64(String filePath) async {
    // For web, you'll need to implement this differently
    // This is just a placeholder
    return null;
  }
}
