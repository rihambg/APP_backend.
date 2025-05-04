import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final Map<String, dynamic> userAnswers;
  final ValueChanged<void> onChanged;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.userAnswers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        if (question.description != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              question.description!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        const SizedBox(height: 8),
        question.multipleChoice
            ? _buildMultipleChoiceOptions()
            : _buildSingleChoiceOptions(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSingleChoiceOptions() {
    final selectedValue = userAnswers[question.answerKey];
    return Column(
      children: question.options.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: selectedValue,
          onChanged: (value) {
            userAnswers[question.answerKey] = value;
            onChanged(null);
          },
          contentPadding: EdgeInsets.zero,
          dense: true,
        );
      }).toList(),
    );
  }

  Widget _buildMultipleChoiceOptions() {
    final selectedValues = userAnswers[question.answerKey] as List<String>? ?? [];
    return Column(
      children: question.options.map((option) {
        return CheckboxListTile(
          title: Text(option),
          value: selectedValues.contains(option),
          onChanged: (bool? value) {
            final list = selectedValues.toList();
            if (value == true) {
              list.add(option);
            } else {
              list.remove(option);
            }
            userAnswers[question.answerKey] = list;
            onChanged(null);
          },
          contentPadding: EdgeInsets.zero,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }
}