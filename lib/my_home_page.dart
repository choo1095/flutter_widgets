import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_widgets/widgets/default_radio_options.dart';

class Question {
  final int id;
  final String title;
  bool isSelected;

  Question({
    required this.id,
    required this.title,
    this.isSelected = false,
  });
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Question> questionList = [
    Question(id: 1, title: "question question question question question question question question question question question question question question question 1",),
    Question(id: 2, title: "question 2"),
    Question(id: 3, title: "question 3",),
    Question(id: 4, title: "question 4"),
    Question(id: 5, title: "question 5",),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: DefaultRadioOptions(
          optionList: questionList.map((question) {
            Random r = new Random();
            double falseProbability = .5;
            bool booleanResult = r.nextDouble() > falseProbability;

            return RadioOption(title: question.title, isSelectable: booleanResult);
          }).toList(),
          onTapOption: (index) {
            for (int i = 0; i < questionList.length; i++) {
              questionList[i].isSelected = (index == i) ? true : false;
              print("${questionList[i].title} ${questionList[i].isSelected}");
            }
          },
        )
      )
    );
  }
}
