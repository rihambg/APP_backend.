import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/user_service.dart';
import 'doctor_signup.dart';
import 'diabetes_form_screen.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? selectedRole;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
    );
  }

  Widget _buildButton(
      String text, Color bgColor, Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.black, size: 20),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.black, fontSize: 14)),
      ],
    );
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate() || selectedRole == null) return;

    setState(() => _isLoading = true);

    try {
      final response = await UserService.signupUser(
        fullName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: selectedRole!,
      );

      if (response['success']) {
        final userId = response['user_id'] as int;
        if (selectedRole == 'Doctor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorSignupScreen(userId: userId),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DiabetesFormScreen(userId: userId),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Signup failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF9F8FEF),
              Color(0xFFB8A5F2),
              Color(0x00000000),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                reverse: true,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'DIABETES APP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.menu, color: Colors.white),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'CREATE ACCOUNT NOW!',
                                  style: GoogleFonts.jockeyOne(
                                    color: const Color(0xFF333333),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'signup to get started ...',
                                  style: GoogleFonts.jockeyOne(
                                    color: const Color(0xFF666666),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildLabel('Full Name', Icons.person),
                          TextFormField(
                            controller: _fullNameController,
                            decoration:
                                _inputDecoration('Enter your full name'),
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Please enter your full name'
                                    : null,
                          ),
                          const SizedBox(height: 18),
                          _buildLabel('Username', Icons.account_circle),
                          TextFormField(
                            controller: _usernameController,
                            decoration: _inputDecoration('Create a username'),
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Please enter a username'
                                    : null,
                          ),
                          const SizedBox(height: 18),
                          _buildLabel('Email', Icons.email),
                          TextFormField(
                            controller: _emailController,
                            decoration: _inputDecoration('Enter your email'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          _buildLabel('Password', Icons.lock),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: _inputDecoration('Enter your password')
                                .copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black54,
                                ),
                                onPressed: () => setState(() =>
                                    _isPasswordVisible = !_isPasswordVisible),
                              ),
                            ),
                            validator: (value) =>
                                (value == null || value.length < 6)
                                    ? 'Password must be at least 6 characters'
                                    : null,
                          ),
                          const SizedBox(height: 18),
                          _buildLabel('Role', Icons.group),
                          DropdownButtonFormField<String>(
                            decoration: _inputDecoration('Select your role'),
                            value: selectedRole,
                            items: const [
                              DropdownMenuItem(
                                  value: 'Patient', child: Text('Patient')),
                              DropdownMenuItem(
                                  value: 'Doctor', child: Text('Doctor')),
                            ],
                            onChanged: (value) =>
                                setState(() => selectedRole = value),
                            validator: (value) =>
                                value == null ? 'Please select a role' : null,
                          ),
                          const SizedBox(height: 28),
                          _buildButton(
                            'SIGNUP',
                            Colors.black87,
                            Colors.white,
                            _handleSignup,
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  ),
                                  child: const Text(
                                    'LOG IN',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 109, 153, 255),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          Color.fromARGB(255, 109, 153, 255),
                                      decorationThickness: 2,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
