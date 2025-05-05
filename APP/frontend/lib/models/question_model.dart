class Question {
final String text;
final String? description;
final List options;
final String answerKey;
final bool multipleChoice;
final bool isTextInput;  // indicates if this question should show a text field

Question({
required this.text,
this.description,
required this.options,
required this.answerKey,
this.multipleChoice = false,
this.isTextInput = false,  // default to false
});
}