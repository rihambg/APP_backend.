import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:file_picker/file_picker.dart';
import 'login.dart';
import '../services/doctor_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorFinalStepScreen extends StatefulWidget {
  final int userId;
  const DoctorFinalStepScreen({super.key, required this.userId});

  @override
  State<DoctorFinalStepScreen> createState() => _DoctorFinalStepScreenState();
}

class _DoctorFinalStepScreenState extends State<DoctorFinalStepScreen> {
  final _formKey = GlobalKey<FormState>();
  final _experienceController = TextEditingController();
  final _professionalIdController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _documentController = TextEditingController();
  String _phoneNumber = '';
  String? _selectedCountry;
  String? _selectedCity;
  bool _agreeToGuidelines = false;
  bool _isLoading = false;
  String? _documentPath;

  List<String> countries = [];
  Map<String, List<String>> countryCities = {};
  List<String> cities = [];

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    try {
      final response = await http
          .get(Uri.parse('https://countriesnow.space/api/v0.1/countries'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == false) {
          setState(() {
            countries = data['data']
                .map<String>((country) => country['country'] as String)
                .toList();
            countryCities = {
              for (var country in data['data'])
                country['country'] as String: (country['cities'] as List)
                    .map<String>((city) => city as String)
                    .toList()
            };
          });
        }
      }
    } catch (e) {
      setState(() {
        countries = ['Algeria', 'United States', 'Canada', 'France', 'Germany'];
        countryCities = {
          'Algeria': ['Algiers', 'Oran', 'Constantine'],
          'United States': ['New York', 'Los Angeles', 'Chicago'],
          'Canada': ['Toronto', 'Montreal', 'Vancouver'],
          'France': ['Paris', 'Marseille', 'Lyon'],
          'Germany': ['Berlin', 'Munich', 'Hamburg'],
        };
      });
    }
  }

  void _updateCities(String? country) {
    setState(() {
      _selectedCountry = country;
      _selectedCity = null;
      cities = country != null ? countryCities[country] ?? [] : [];
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || !_agreeToGuidelines) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please agree to guidelines and complete all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await DoctorService.completeDoctorProfile(
        userId: widget.userId,
        phoneNumber: _phoneNumber,
        experience: _experienceController.text,
        professionalId: _professionalIdController.text,
        hospital: _hospitalController.text,
        country: _selectedCountry ?? '',
        city: _selectedCity ?? '',
        documentPath: _documentPath,
      );

      if (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Profile completed successfully! Please login')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to complete profile. Please try again')),
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

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _documentController.text = result.files.single.name;
          _documentPath = result.files.single.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: ${e.toString()}')),
      );
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
                      'Doctor Registration',
                      style: GoogleFonts.jockeyOne(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Complete your doctor profile',
                      style: GoogleFonts.jockeyOne(
                        fontSize: 14,
                        color: Colors.black45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Step 2 of 2: Professional Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phone Number',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IntlPhoneField(
                            decoration: buildInputDecoration('xx-xx-xx-xx-x'),
                            initialCountryCode: 'DZ',
                            dropdownIconPosition: IconPosition.trailing,
                            disableLengthCheck: true,
                            showDropdownIcon: true,
                            onChanged: (phone) {
                              if (phone.completeNumber != null) {
                                _phoneNumber = phone.completeNumber!;
                              }
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.completeNumber == null) {
                                return 'Phone number is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    buildLabeledTextField(
                      label: 'Years of Experience',
                      controller: _experienceController,
                      hint: 'Enter number of years',
                      keyboardType: TextInputType.number,
                      validatorMsg: 'Experience is required',
                    ),
                    const SizedBox(height: 18),
                    buildLabeledTextField(
                      label: 'Professional ID',
                      controller: _professionalIdController,
                      hint: 'Enter your professional ID',
                      validatorMsg: 'Professional ID is required',
                    ),
                    const SizedBox(height: 18),
                    buildLabeledTextField(
                      label: 'Hospital/Clinic Name',
                      controller: _hospitalController,
                      hint: 'Enter your workplace name',
                      validatorMsg: 'Hospital name is required',
                    ),
                    const SizedBox(height: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location',
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration:
                                    buildInputDecoration('Select Country'),
                                value: _selectedCountry,
                                items: countries.map((String country) {
                                  return DropdownMenuItem<String>(
                                    value: country,
                                    child: Text(country),
                                  );
                                }).toList(),
                                onChanged: _updateCities,
                                validator: (value) => value == null
                                    ? 'Country is required'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: buildInputDecoration('Select City'),
                                value: _selectedCity,
                                items: cities.map((String city) {
                                  return DropdownMenuItem<String>(
                                    value: city,
                                    child: Text(city),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCity = value;
                                  });
                                },
                                validator: (value) =>
                                    value == null ? 'City is required' : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Supporting Document (PDF)*',
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _documentController,
                          decoration: buildInputDecoration(
                            'Add your professional document',
                            icon: Icons.file_upload_outlined,
                          ),
                          maxLines: 3,
                          readOnly: true,
                          onTap: _pickDocument,
                          validator: (value) {
                            if (_documentPath == null) {
                              return 'Supporting document is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToGuidelines,
                          onChanged: (value) {
                            setState(() {
                              _agreeToGuidelines = value ?? false;
                            });
                          },
                          fillColor: MaterialStateProperty.all(Colors.white),
                          checkColor: const Color(0xFF9F8FEF),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Agree to guidelines and policies',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Complete Registration',
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

  Widget buildLabeledTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
    IconData? icon,
    String? validatorMsg,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: buildInputDecoration(hint ?? '', icon: icon),
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validatorMsg ?? 'Field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  InputDecoration buildInputDecoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      suffixIcon: icon != null ? Icon(icon, color: Colors.black54) : null,
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontSize: 12,
        height: 1.5,
      ),
    );
  }

  @override
  void dispose() {
    _experienceController.dispose();
    _professionalIdController.dispose();
    _hospitalController.dispose();
    _documentController.dispose();
    super.dispose();
  }
}
