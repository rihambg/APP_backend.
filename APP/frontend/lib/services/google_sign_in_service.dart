import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sugarblood/services/user_service.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {'success': false, 'message': 'Sign in cancelled'};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Send to your backend for verification and user creation
      final response = await http.post(
        Uri.parse('${UserService.baseUrl}/google-signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': googleAuth.idToken,
          'email': googleUser.email,
          'name': googleUser.displayName,
        }),
      );

      if (response.statusCode == 200) {
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
        'message': 'Error signing in with Google: ${e.toString()}',
      };
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
