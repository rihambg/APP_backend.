import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'pages/login.dart';
import 'pages/singin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DiabetesLoginScreen(),
    );
  }
}

class DiabetesLoginScreen extends StatefulWidget {
  const DiabetesLoginScreen({super.key});

  @override
  State<DiabetesLoginScreen> createState() => _DiabetesLoginScreenState();
}

class _DiabetesLoginScreenState extends State<DiabetesLoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        print("Google user name: ${account.displayName}");
        print("Google user email: ${account.email}");
      } else {
        print("Google sign-in canceled");
      }
    } catch (error) {
      print("Google sign-in error: $error");
    }
  }

  void _handleAppleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      print("Apple user ID: ${credential.userIdentifier}");
      print("Apple user email: ${credential.email}");
      print("Apple user name: ${credential.givenName} ${credential.familyName}");
    } catch (error) {
      print("Apple sign-in error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9D84E8),
        title: const Text(
          'DIABETES APP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: const Color(0xFF9D84E8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.25, // Relative height (25% of screen)
                  width: MediaQuery.of(context).size.width * 0.98,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(125),
                      bottomLeft: Radius.circular(125),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(125),
                      bottomLeft: Radius.circular(125),
                    ),
                    child: Image.asset(
                      'assets/diabetes_illustration.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  'Hello, ... your application for complete monitoring of your diabetes!',
                  textAlign: TextAlign.center,
                  maxLines: 3, // Prevent text overflow
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.jockeyOne(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                _buildButton(
                  'LOGIN',
                  Colors.white,
                  const Color(0xFF9D84E8),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildButton(
                  'SIGNUP',
                  Colors.white,
                  const Color(0xFF9D84E8),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.white.withOpacity(0.5)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'OR',
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.white.withOpacity(0.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                _buildSocialButton(
                  'Continue with Google',
                  Colors.white,
                  Colors.black87,
                  FontAwesomeIcons.google,
                  Colors.red,
                  onTap: _handleGoogleSignIn,
                ),
                const SizedBox(height: 15),
                _buildSocialButton(
                  'Continue with Apple',
                  Colors.white,
                  Colors.black87,
                  FontAwesomeIcons.apple,
                  Colors.black,
                  onTap: _handleAppleSignIn,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 25.0),
                  child: Column(
                    children: [
                      Text(
                        'Keep in Contact with us',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.instagram, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.facebook, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color bgColor, Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    String text,
    Color bgColor,
    Color textColor,
    IconData icon,
    Color iconColor, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}