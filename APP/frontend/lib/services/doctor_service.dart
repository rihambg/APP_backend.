import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorService {
  static const String baseUrl = 'http://192.168.1.36:5000/api';

  static Future<bool> completeDoctorProfile({
    required String phoneNumber,
    required String experience,
    required String professionalId,
    required String? documentPath,
  }) async {
    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/complete-doctor-profile'));
      
      // Add fields
      request.fields['phone_number'] = phoneNumber;
      request.fields['experience_years'] = experience;
      request.fields['license_number'] = professionalId;
      
      // Add file if exists
      if (documentPath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'document',
          documentPath,
        ));
      }

      // Send the request
      var response = await request.send();
      
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}