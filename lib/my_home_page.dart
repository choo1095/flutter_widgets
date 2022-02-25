import 'package:flutter/material.dart';
import 'package:flutter_widgets/widgets/default_checkbox_options.dart';

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
    Question(id: 1, title: "question 1",),
    Question(id: 2, title: "question 2", isSelected: true),
    Question(id: 3, title: "question 3",),
    Question(id: 4, title: "question 4", isSelected: true),
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
        child: DefaultCheckboxOptions(
          optionList: questionList.map((question) => CheckboxOption(
            id: question.id,
            title: question.title,
            isSelectedNotifier: ValueNotifier(question.isSelected),
          )).toList(),
          onTapCheckbox: (index, newValue) {
            questionList[index].isSelected = newValue;
            for (var question in questionList) {
              print("${question.title} ${question.isSelected}");
            }
          },
        )
      )
    );
  }
}
