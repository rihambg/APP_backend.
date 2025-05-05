import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../models/question_model.dart';
import '../services/user_service.dart';
import '../widgets/expandable_section.dart';
import 'login.dart';

class DiabetesFormScreen extends StatefulWidget {
  final int userId;
  const DiabetesFormScreen({super.key, required this.userId});

  @override
  State<DiabetesFormScreen> createState() => _DiabetesFormScreenState();
}

class _DiabetesFormScreenState extends State<DiabetesFormScreen> {
  final Map<String, bool> _expandedSections = {
    'Diabetes Type': false,
    'Medical Background': false,
    'Nutrition And Diet': false,
    'Lifestyle': false,
    'Preference and goals': false,
  };

  final Map<String, dynamic> _userAnswers = {};
  late int _totalQuestions;
  bool _isLoading = false;

  List<Question> _diabetesTypeQuestions() => [
        Question(
          text: '1-What type of diabetes do you have?',
          options: [
            'Pre-diabetes',
            'Type 1',
            'Type 2',
            'Gestational',
            'I\'m not sure'
          ],
          answerKey: 'diabetes_type',
        ),
        Question(
          text: '2-When were you diagnosed?',
          options: [
            'Less than 1 year',
            '1-5 years',
            '5-10 years',
            'More than 10 years'
          ],
          answerKey: 'diagnosis_time',
        ),
      ];

  List<Question> _medicalBackgroundQuestions() => [
        Question(
          text: '1-Do you have any allergies?',
          options: ['Yes', 'No'],
          answerKey: 'allergies',
        ),
        Question(
          text: '2-Do you have any other chronic conditions?',
          options: [
            'Hypertension',
            'Heart Disease',
            'Kidney Disease',
            'Obesity',
            'None'
          ],
          answerKey: 'other_conditions',
          multipleChoice: true,
        ),
        Question(
          text: '3-Are you on diabetes medication?',
          options: ['Insulin', 'Oral medication', 'Both', 'None'],
          answerKey: 'medications',
          multipleChoice: true,
        ),
        Question(
          text: '4-Are you currently pregnant?',
          options: ['Yes', 'No', 'Not applicable'],
          answerKey: 'pregnancy_status',
        ),
      ];

  List<Question> _nutritionQuestions() => [
        Question(
          text: '1-How often do you consume sugary foods?',
          options: ['Rarely', 'Occasionally', 'Frequently', 'Very Often'],
          answerKey: 'sugar_intake',
        ),
        Question(
          text: '2-Do you follow a special diet?',
          options: ['Low-carb', 'Keto', 'Mediterranean', 'Vegan', 'None'],
          answerKey: 'diet_type',
        ),
      ];

  List<Question> _lifestyleQuestions() => [
        Question(
          text: '1-How often do you exercise per week?',
          options: ['Never', 'Rarely', '1-2 times', '3-5 times', 'Daily'],
          answerKey: 'exercise_frequency',
        ),
        Question(
          text: '2-Do you smoke?',
          options: ['Yes', 'No'],
          answerKey: 'smoking',
        ),
        Question(
          text: '3-Do you drink alcohol?',
          options: ['Yes', 'No'],
          answerKey: 'alcohol',
        ),
      ];

  List<Question> _preferenceQuestions() => [
        Question(
          text: '1-What is your goal in using this app?',
          options: [
            'Monitor blood sugar',
            'Improve diet',
            'Lose/gain weight',
            'All of the above'
          ],
          answerKey: 'goals',
          multipleChoice: true,
        ),
        Question(
          text: '2-How often would you like to receive health reminders?',
          options: ['Daily', 'Weekly', 'Occasionally', 'Never'],
          answerKey: 'reminder_frequency',
        ),
      ];

  List<List<Question>> _allQuestions() => [
        _diabetesTypeQuestions(),
        _medicalBackgroundQuestions(),
        _nutritionQuestions(),
        _lifestyleQuestions(),
        _preferenceQuestions(),
      ];

  @override
  void initState() {
    super.initState();
    _totalQuestions =
        _allQuestions().fold(0, (count, qList) => count + qList.length);
  }

  void _refresh() => setState(() {});

  double _sectionProgress(List<Question> questions) {
      int answered = questions
        .where((q) {
          final ans = _userAnswers[q.answerKey];
          if (q.multipleChoice) {
            return ans is List && ans.length == 1; // Enforcing only one value
          }
          return ans != null && ans.toString().trim().isNotEmpty;
        })
        .length;
    return questions.isEmpty ? 0 : answered / questions.length;
  }

   bool _isFormComplete() {
    return _allQuestions()
        .expand((qList) => qList)
        .every((q) {
          final ans = _userAnswers[q.answerKey];
          if (q.multipleChoice) {
            return ans is List && ans.length == 1;
          }
          return ans != null && ans.toString().trim().isNotEmpty;
        });
  }


  Future<void> _submitForm() async {
    if (_userAnswers.length != _totalQuestions) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all sections')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Add basic info that's not in the form
      _userAnswers['gender'] = 'male'; // You should get this from signup
      _userAnswers['date_of_birth'] = '01/01/1990'; // Get from signup
      _userAnswers['phone_number'] = '1234567890'; // Get from signup
      _userAnswers['height'] = 170.0; // Get from signup
      _userAnswers['weight'] = 70.0; // Get from signup
      _userAnswers['emergency_contact_name'] =
          'Emergency Contact'; // Get from signup
      _userAnswers['emergency_contact_phone'] = '9876543210'; // Get from signup

      final response = await UserService.completePatientProfile(
        userId: widget.userId,
        formData: _userAnswers,
      );

      if (response['success']) {
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
          SnackBar(
              content: Text(response['message'] ?? 'Failed to submit form')),
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

  Widget _section(String title, List<Question> questions) {
    return ExpandableSection(
      title: title,
      questions: questions,
      userAnswers: _userAnswers,
      onChanged: (_) => _refresh(),
      initiallyExpanded: _expandedSections[title] ?? false,
      onExpansionChanged: (val) =>
          setState(() => _expandedSections[title] = val),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: formColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'DIABETES APP',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: AppColors.primary,
            child: Center(
              child: Text(
                'Fill the form please!',
                style: GoogleFonts.jockeyOne(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: _allQuestions().map((questions) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: _sectionProgress(questions).clamp(0.0, 1.0),
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _section('Diabetes Type', _diabetesTypeQuestions()),
                  _section('Medical Background', _medicalBackgroundQuestions()),
                  _section('Nutrition And Diet', _nutritionQuestions()),
                  _section('Lifestyle', _lifestyleQuestions()),
                  _section('Preference and goals', _preferenceQuestions()),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _isFormComplete()
                        ? () {
                            print(_userAnswers);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Form submitted successfully!'),
                            ));
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormComplete()
                          ? AppColors.primary
                          : formColors.white,
                      foregroundColor: _isFormComplete()
                          ? formColors.white
                          : formColors.textDark,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child:
                        const Text('Done', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
