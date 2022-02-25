import 'package:flutter/material.dart';
import 'package:flutter_widgets/widgets/scrollable_tabs_view.dart';

class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
static const int tabCount = 50;

  List<Widget> _contentList = [];
  List<Widget> _tabList = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < tabCount; i++) {
      _contentList.add(Container(
        height: (i + 25) * 20,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black)),
        ),
        child: Center(
          child: TextButton(
            child: Text(i.toString()),
            onPressed: () => print(i)
          ),
        )
      ));
      _tabList.add(Container(
        height: (i + 10) * 5,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.ac_unit),
              Text("tabbity " + i.toString())
            ],
          )
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ScrollableTabsView(
        tabBarPosition: TabBarPosition.left,
        onPageChange: (pageIndex) => print(pageIndex),
        onSelectTab:(tabIndex) => print(tabIndex),
        contents: _contentList,
        tabs: _tabList,
      )
      
    );
  }
}
