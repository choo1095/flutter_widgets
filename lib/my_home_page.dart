import 'package:flutter/material.dart';
import 'package:flutter_widgets/widgets/tabs/sliding_horizontal_tab_bar.dart';

class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            child: SlidingHorizontalTabBar(
              borderRadius: 10.0,
              margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              tabs: [
                Text("tab 1"),
                Text("tab 2"),
                Text("tab 3"),
              ],
              onTap: (currentIndex) => print(currentIndex),
            ),
          ),

          Expanded(
            child: Container(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
