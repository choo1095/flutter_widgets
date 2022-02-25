# Widgets List

1. **scrollable_tabs_view:** Tabs + Contents that supports dynamic tab and content size

```
return Scaffold(
    appBar: AppBar(),
    body: ScrollableTabsView(
        tabBarPosition: TabBarPosition.left,
        onPageChange: (pageIndex) => print(pageIndex),
        onSelectTab:(tabIndex) => print(tabIndex),
        contents: _contentList,
        tabs: _tabList,
    ),
);
```

2. **debouncer_wrapper:** Adds delay to button presses

3. **default_stepper:** widget with plus and minus buttons + value
```
return Scaffold(
    appBar: AppBar(),
    body: Center(
        child: DefaultStepper(
            initialValue: 1,
            onUpdateStepper: (value) => print(value),
        ),
    ),
);
```

4. **default_checkbox_option:** self-explanatory
```
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
        },
    )
);
```

5. **default_radio_option:** self-explanatory
```
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
    },
);
```

6. **sliding_horizontal_tab_bar:** A horizontal tab bar with sliding animation
```
return Scaffold(
  appBar: AppBar(),
  body: Column(
    children: [
      SlidingHorizontalTabBar(
        borderRadius: 10.0,
        margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        tabs: [
          Text("tab 1"),
          Text("tab 2"),
          Text("tab 3"),
        ],
        onTap: (currentIndex) => print(currentIndex),
      ),

      Expanded(
        child: Container(
          color: Colors.red,
        ),
      ),
    ],
  ),
);
```

