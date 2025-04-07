class QuestionModel {
  final int id;
  final String questionText;
  final List<String> options;
  int? selectedAnswer;

  QuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    this.selectedAnswer,
  });
}
