import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz/quiz.dart';
import 'package:quiz/start.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(
        brightness: Brightness.light,
        backgroundColor: Color.fromRGBO(37, 44, 74, 1.0),
        primaryColor: Color.fromRGBO(190, 56, 55, 1.0),
      ),
      routes: {
        'start': (context) => Start(),
        // 'quiz': (context) => QuizScreen(),
        // 'result': (context) => Result(),
      },
      home: Start(),
    );
  }
}
