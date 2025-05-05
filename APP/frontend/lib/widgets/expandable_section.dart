import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../constants/colors.dart';

class ExpandableSection extends StatefulWidget {
  final String title;
  final List<Question> questions;
  final Map<String, dynamic> userAnswers;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final bool initiallyExpanded;
  final ValueChanged<bool> onExpansionChanged;

  const ExpandableSection({
    Key? key,
    required this.title,
    required this.questions,
    required this.userAnswers,
    required this.onChanged,
    required this.onExpansionChanged,
    this.initiallyExpanded = false,
  }) : super(key: key);

  @override
  _ExpandableSectionState createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  void _updateAnswer(String key, dynamic value) {
    final previous = widget.userAnswers[key];
    if (previous != value) {
      setState(() {
        widget.userAnswers[key] = value;
      });
      // Notify parent of full map to recalculate progress
      widget.onChanged(widget.userAnswers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        initiallyExpanded: _expanded,
        onExpansionChanged: (open) {
          setState(() => _expanded = open);
          widget.onExpansionChanged(open);
        },
        iconColor: formColors.white,
        collapsedIconColor: formColors.white,
        title: Row(
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: formColors.white,
              ),
            ),
          ],
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: formColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.questions.map((q) {
                final current = widget.userAnswers[q.answerKey];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        q.text,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),

                      ...q.options.map((opt) {
                        return RadioListTile<String>(
                          title: Text(opt),
                          value: opt,
                          groupValue: current as String?,
                          onChanged: (val) {
                            _updateAnswer(q.answerKey, val);
                          },
                        );
                      }).toList(),

                      if (q.answerKey == 'allergies' &&
                          widget.userAnswers['allergies'] == 'Yes')
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 8),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Please list your allergies',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (txt) =>
                                _updateAnswer('allergies_details', txt),
                          ),
                        ),

                      if (q.answerKey == 'has_chronic_illness' &&
                          widget.userAnswers['has_chronic_illness'] == 'Yes')
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 8),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Please describe your chronic illnesses',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (txt) =>
                                _updateAnswer('chronic_illness_details', txt),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
