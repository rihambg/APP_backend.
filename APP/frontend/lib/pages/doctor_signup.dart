import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'doctor_signup_step2.dart';

class DoctorSignupScreen extends StatefulWidget {
  final int userId; // Add this line to accept userId
  const DoctorSignupScreen({super.key, required this.userId}); // Update constructor

  @override
  State<DoctorSignupScreen> createState() => _DoctorInfoScreenState();
}

class _DoctorInfoScreenState extends State<DoctorSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _dobController = TextEditingController();

  String? _selectedGender;
  String? _selectedSpeciality;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF9F8FEF),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF9F8FEF),
              Color(0xFF9F8FEF),
              Color(0xFFB8A5F2),
              Color(0x00000000),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'HELLO DOCTOR !',
                      style: GoogleFonts.jockeyOne(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Image.asset('assets/doctor_team.png', height: 160),
                    const SizedBox(height: 8),
                    Text(
                      'Now, complete your account !',
                      style: GoogleFonts.jockeyOne(
                        fontSize: 20,
                        color: Colors.black45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Gender Dropdown
                    DropdownButtonFormField<String>(
                      decoration:
                          _inputDecoration('Select your gender', 'Gender'),
                      value: _selectedGender,
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(
                            value: 'Female', child: Text('Female')),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedGender = value),
                      validator: (value) =>
                          value == null ? 'Please select gender' : null,
                    ),
                    const SizedBox(height: 18),

                    // Date of Birth Field
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration:
                          _inputDecoration('DD/MM/YYYY', 'Date Of Birth'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(1990),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          _dobController.text =
                              DateFormat('dd/MM/yyyy').format(pickedDate);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Date of birth required';
                        try {
                          DateFormat('dd/MM/yyyy').parseStrict(value);
                        } catch (e) {
                          return 'Enter a valid date (DD/MM/YYYY)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),

                    // Speciality Dropdown
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration(
                          'Select your speciality', 'Speciality'),
                      value: _selectedSpeciality,
                      items: const [
                        DropdownMenuItem(
                            value: 'Cardiologist', child: Text('Cardiologist')),
                        DropdownMenuItem(
                            value: 'Endocrinologist',
                            child: Text('Endocrinologist')),
                        DropdownMenuItem(
                            value: 'General Practitioner',
                            child: Text('General Practitioner')),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedSpeciality = value),
                      validator: (value) =>
                          value == null ? 'Please select speciality' : null,
                    ),
                    const SizedBox(height: 18),

                    // Location Field
                    TextFormField(
                      controller: _locationController,
                      decoration: _inputDecoration(
                        'Enter your location (City/Hospital/Clinic)',
                        'Location',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Location is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorFinalStepScreen(
                                  userId: widget.userId, // Pass the userId here
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, String label) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontSize: 12,
        height: 1.5,
      ),
    );
  }
}