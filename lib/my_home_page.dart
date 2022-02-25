import 'package:flutter/material.dart';
import 'package:flutter_widgets/widgets/default_stepper.dart';

class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: DefaultStepper(
          initialValue: 1,
          onUpdateStepper: (value) => print(value),
        )
      )
    );
  }
}
