class Question {
  final String text;
  final String? description;
  final List<String> options;
  final String answerKey;
  final bool multipleChoice;

  Question({
    required this.text,
    this.description,
    required this.options,
    required this.answerKey,
    this.multipleChoice = false,
  });
}