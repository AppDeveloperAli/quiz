import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz/custom_button.dart';
import 'package:quiz/model.dart';
import 'package:quiz/start.dart';
import 'package:restart_app/restart_app.dart';

class QuizScreen extends StatefulWidget {
   String dataPath;
   QuizScreen({super.key,required this.dataPath});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {


  late PageController _controller;
  int questionNumber = 1;
  int _score = 0;
  bool _isLocked = false;
  late Stream<QuerySnapshot<Map<String, dynamic>>> myStream;

  @override
  void initState() {
    super.initState();

    myStream =
    FirebaseFirestore.instance.collection(widget.dataPath.toString()).snapshots();

    _controller = PageController(initialPage: 0);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff26294b),
        body: StreamBuilder(
          stream: myStream,
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){

            final data = snapshot.data!.docs.map((doc) => doc.data()).toList();

            if(snapshot.hasData){
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                  Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      'Question $questionNumber/${snapshot.data!.docs.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
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
                            final item = data[index];

                            return buildQuestion(item['question']);
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
                );
            } else if(snapshot.hasError){
              return const Text('Something went wrong');
            }
            return Text('Loading...');
          }
        ),
      ),
    );
  }


  Column buildQuestion(String question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 32,
        ),
        Text(
          question.toString(),
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
        const SizedBox(
          height: 32,
        ),
        // Expanded(
        //     child: OptionWidget(
        //   question: question,
        //   onClickedOption: (option) {
        //     if (question.isLocked) {
        //       return;
        //     } else {
        //       setState(() {
        //         question.isLocked = true;
        //         question.selectedOption = option;
        //       });
        //       _isLocked = question.isLocked;
        //       if (question.selectedOption!.isCorrect) {
        //         _score++;
        //       }
        //     }
        //   },
        // ))
      ],
    );
  }

  Widget buildElevatedButton() {
    return InkWell(
      onTap: () {
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
      child: Row(
        children: [
          Expanded(
            child: Card(
                color: const Color.fromARGB(255, 60, 45, 104),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        questionNumber < questions.length
                            ? 'Next Page'
                            : 'See the Result',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
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
    return InkWell(
      onTap: () {
        onClickedOption(option);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
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
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(
                Icons.cancel,
                color: Colors.red,
              );
      } else if (option.isCorrect) {
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
        );
      }
    }
    return const SizedBox.shrink();
  }
}

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: screen.width - 40.0,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(6.0, 12.0),
                      blurRadius: 6.0,
                    )
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: screen.width / 3.5,
                    width: screen.width / 3.5,
                    child: const Image(
                      image: AssetImage('assets/images/celebrate.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'You got $score / ${questions.length}',
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Restart.restartApp(webOrigin: 'start');
                    },
                    child: const CustomButton(
                      text: 'Play Again',
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
