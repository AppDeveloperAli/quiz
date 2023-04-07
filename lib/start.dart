import 'package:flutter/material.dart';
import 'package:quiz/collectionCard.dart';
import 'package:quiz/custom_button.dart';
import 'package:quiz/quiz.dart';

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Collections'),
        backgroundColor: Color.fromRGBO(37, 44, 74, 1.0),
      ),
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuizScreen(dataPath: 'Names_Of_Allah')));

                  },
                  child: CollectionCard(title: 'Names of Allah',)),
              InkWell(onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuizScreen(dataPath: 'People_Of_The_Quran')));

              },child: CollectionCard(title: 'People of the Quran',)),
              InkWell(onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuizScreen(dataPath: 'Places_In_The_Quran')));

              },child: CollectionCard(title: 'Places in the Quran',)),
              InkWell(onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuizScreen(dataPath: 'Prophets')));

              },child: CollectionCard(title: 'Prophets',)),
              InkWell(onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuizScreen(dataPath: 'Quranic_Knowledge')));

              },child: CollectionCard(title: 'Quranic Knowledge',)),
              InkWell(onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuizScreen(dataPath: 'Teachings_Of _The_Quran')));

              },child: CollectionCard(title: 'Teachings of the Quran',)),
            ],
          ),
        ),
      ),
    );
  }
}
