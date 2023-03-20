import 'package:flutter/material.dart';
import 'package:quiz/model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late PageController _controller;
  int questionNumber = 1;
  int _score = 0;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();

    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const SizedBox(
              height: 32,
            ),
            Text('Question $questionNumber/${questions.length}'),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Expanded(
                child: PageView.builder(
              controller: _controller,
              itemCount: questions.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final question = questions[index];
                return buildQuestion(question);
              },
            )),
            const SizedBox(
              height: 20,
            ),
            _isLocked ? buildElevatedButton() : const SizedBox.shrink(),
            const SizedBox(
              height: 20,
            )
          ]),
        ),
      ),
    );
  }

  Column buildQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 32,
        ),
        Text(
          question.text,
          style: const TextStyle(fontSize: 25),
        ),
        const SizedBox(
          height: 32,
        ),
        Expanded(
            child: OptionWidget(
          question: question,
          onClickedOption: (option) {
            if (question.isLocked) {
              return;
            } else {
              setState(() {
                question.isLocked = true;
                question.selectedOption = option;
              });
              _isLocked = question.isLocked;
              if (question.selectedOption!.isCorrect) {
                _score++;
              }
            }
          },
        ))
      ],
    );
  }

  ElevatedButton buildElevatedButton() {
    return ElevatedButton(
        onPressed: () {
          if (questionNumber < questions.length) {
            _controller.nextPage(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInExpo);
            setState(() {
              questionNumber++;
              _isLocked = false;
            });
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultPage(score: _score),
                ));
          }
        },
        child: Text(questionNumber < questions.length
            ? 'Next Page'
            : 'See the Result'));
  }
}

class OptionWidget extends StatelessWidget {
  final Question question;
  final ValueChanged<Option> onClickedOption;

  const OptionWidget(
      {super.key, required this.question, required this.onClickedOption});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: question.options
              .map((option) => buildOption(context, option))
              .toList(),
        ),
      );

  Widget buildOption(BuildContext context, Option option) {
    final color = getColorsforOption(option, question);
    return GestureDetector(
      onTap: () => onClickedOption(option),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 8),
        height: 50,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              option.text,
              style: const TextStyle(fontSize: 20),
            ),
            getIconForOption(option, question)
          ],
        ),
      ),
    );
  }

  Color getColorsforOption(Option option, Question question) {
    final isSelected = option == question.selectedOption;
    if (question.isLocked) {
      if (isSelected) {
        return option.isCorrect ? Colors.green : Colors.red;
      } else if (option.isCorrect) {
        return Colors.green;
      }
    }
    return Colors.grey.shade300;
  }

  Widget getIconForOption(Option option, Question question) {
    final isSelected = option == question.selectedOption;
    if (question.isLocked) {
      if (isSelected) {
        return option.isCorrect
            ? Icon(Icons.check_circle, color: Colors.green)
            : Icon(
                Icons.cancel,
                color: Colors.red,
              );
      } else if (option.isCorrect) {
        return Icon(
          Icons.check_circle,
          color: Colors.green,
        );
      }
    }
    return SizedBox.shrink();
  }
}

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('You got $score/ ${questions.length}')),
    );
  }
}
