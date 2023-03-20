class Question {
  final String text;
  final List<Option> options;
  bool isLocked;
  Option? selectedOption;

  Question(
      {required this.text,
      required this.options,
      required this.isLocked,
      this.selectedOption});
}

class Option {
  final String text;
  final bool isCorrect;

  Option({required this.text, required this.isCorrect});
}

final questions = [
  Question(
    text: 'What is My Name ?',
    options: [
      Option(text: 'Ali', isCorrect: true),
      Option(text: 'Adnan', isCorrect: false),
      Option(text: 'Xeeshan', isCorrect: false),
      Option(text: 'Rizwan', isCorrect: false)
    ],
    isLocked: false,
  ),
  Question(
    text: 'What is Youre Name ?',
    options: [
      Option(text: 'Aslam', isCorrect: true),
      Option(text: 'Ali', isCorrect: false),
      Option(text: 'Adnan', isCorrect: false),
      Option(text: 'Noman', isCorrect: false)
    ],
    isLocked: false,
  ),
];
