import 'package:flutter/material.dart';
import '../models/question_model.dart';
import 'question_widget.dart';
import '../constants/colors.dart';

class ExpandableSection extends StatelessWidget {
  final String title;
  final List<Question> questions;
  final Map<String, dynamic> userAnswers;
  final ValueChanged<void> onChanged;
  final bool initiallyExpanded;
  final Function(bool) onExpansionChanged;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.questions,
    required this.userAnswers,
    required this.onChanged,
    required this.initiallyExpanded,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        onExpansionChanged: onExpansionChanged,
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
              title,
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
              children: questions
                  .map((q) => QuestionWidget(
                        question: q,
                        userAnswers: userAnswers,
                        onChanged: onChanged,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}