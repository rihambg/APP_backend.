import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../models/question_model.dart';
import '../widgets/expandable_section.dart';

class DiabetesFormScreen extends StatefulWidget {
  const DiabetesFormScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    _totalQuestions = _allQuestions().fold(0, (count, qList) => count + qList.length);
  }

  void _refresh() => setState(() {});

  double _sectionProgress(List<Question> questions) {
    int answered = questions.where((q) => _userAnswers.containsKey(q.answerKey)).length;
    return questions.isEmpty ? 0 : answered / questions.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: formColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: const BackButton(color: formColors.textDark),
        title: const Text(
          'DIABETES APP',
          style: TextStyle(color: formColors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: formColors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: AppColors.primary,
            child: Center(
              child: Text(
                'Fill the form please!',
                style: GoogleFonts.jockeyOne(fontSize: 20, fontWeight: FontWeight.w500, color: formColors.textDark),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SegmentedProgressBar(
            sectionProgress: [
              _sectionProgress(_diabetesTypeQuestions()),
              _sectionProgress(_medicalBackgroundQuestions()),
              _sectionProgress(_nutritionQuestions()),
              _sectionProgress(_lifestyleQuestions()),
              _sectionProgress(_preferenceQuestions()),
            ],
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
                  const SizedBox(height: 165),
                  ElevatedButton(
                    onPressed: _userAnswers.length == _totalQuestions
                        ? () {
                            print(_userAnswers);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Form submitted successfully!')),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: formColors.white,
                      foregroundColor: formColors.textDark,
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Done', style: TextStyle(fontSize: 16)),
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

  List<Question> _diabetesTypeQuestions() => [
        Question(
          text: '1-What type of diabetes do you have?',
          options: ['Pre-diabetes', 'Type 1', 'Type 2', 'Gestational', 'i\'m not sure'],
          answerKey: 'diabetes_type',
        )
        
      ];

  List<Question> _medicalBackgroundQuestions() => [
        Question(
          text: '1-Do you have any allergies?',
          options: ['yes','No'],
          answerKey: 'allergies',
          multipleChoice: true,
        ),
        Question(
          text: '2-Do you have any other chronic conditions?',
          options: ['Hypertension', 'Heart Disease', 'Kidney Disease', 'Obesity', 'None'],
          answerKey: 'other_conditions',
          multipleChoice: true,
        ),
        Question(
          text: '3-Are you on diabet medication?',
          options: [
            'Insulin',
            'Oral medication',
            'Bothe'
          ],
          answerKey: 'medications',
          multipleChoice: true,
        ),
        Question(
          text: '3-Are you currently pregnant?',
          options: [
            'Yes',
            'No',
          ],
          answerKey: 'pregnancy',
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
          options: ['Never','Rarely', '1-2 times', '3-5 times', 'Daily'],
          answerKey: 'exercise_frequency',
        ),
        Question(
          text: '2-Do you smoke?',
          options: ['Yes', 'No'],
          answerKey: 'smoking',
        ),
        Question(
          text: '2-Do you drink Alcohol?',
          options: ['Yes', 'No'],
          answerKey: 'drinking',
        ),
      ];

  List<Question> _preferenceQuestions() => [
        Question(
          text: '1-What is your goal in using this app?',
          options: ['Monitor blood sugar', 'Improve diet', 'loss / gain weight'],
          answerKey: 'goal',
        ),
        Question(
          text: '2-What is your goal in using this app?',
          options: ['Monitor blood sugar', 'Improve diet', 'loss / gain weight'],
          answerKey: 'goal',
        ),
        Question(
          text: '3-How often would you like to receive health reminders?',
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

  Widget _section(String title, List<Question> questions) {
    return ExpandableSection(
      title: title,
      questions: questions,
      userAnswers: _userAnswers,
      onChanged: (_) => _refresh(),
      initiallyExpanded: _expandedSections[title] ?? false,
      onExpansionChanged: (val) => setState(() => _expandedSections[title] = val),
    );
  }
}

class SegmentedProgressBar extends StatelessWidget {
  final List<double> sectionProgress;

  const SegmentedProgressBar({super.key, required this.sectionProgress});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: sectionProgress.map((progress) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
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
    );
  }
}
