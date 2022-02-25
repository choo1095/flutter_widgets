import 'package:flutter/material.dart';

class CheckboxOption {
  final String title;
  final ValueNotifier<bool> isSelectedNotifier;

  CheckboxOption({
    required this.title,
    required this.isSelectedNotifier,
  });
}

class DefaultCheckboxOptions extends StatefulWidget {

  final EdgeInsets margin;
  final List<CheckboxOption> optionList;
  final Function(int index, bool value) onTapCheckbox;
  
  const DefaultCheckboxOptions({
    Key? key,
    this.margin = EdgeInsets.zero,
    required this.optionList,
    required this.onTapCheckbox,
  }) : super(key: key);

  @override
  _DefaultCheckboxOptionsState createState() => _DefaultCheckboxOptionsState();
}

class _DefaultCheckboxOptionsState extends State<DefaultCheckboxOptions> {

  List<CheckboxOption> _optionList = [];

//============================================================
// ** Properties **
//============================================================

  @override
  void initState() {
    super.initState();

    _optionList = widget.optionList;
  }

  @override
  void dispose() {
    super.dispose();

    for (int i = 0; i < _optionList.length; i++) {
      _optionList[i].isSelectedNotifier.dispose();
    }
  }
  
//============================================================
// ** Flutter Build Cycle **
//============================================================
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: ListView.builder(
        itemCount: _optionList.length,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          return _checkbox(index);
        }, 
      ),
    );
  }
  
//============================================================
// ** Widgets **
//============================================================

    Widget _checkbox(int index) {
      final option = _optionList[index];
      return Row(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: option.isSelectedNotifier,
            builder: (_, isSelected, __) {
              return Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                value: isSelected,
                onChanged: (value) {
                  if (value != null) {
                    option.isSelectedNotifier.value = value;
                    widget.onTapCheckbox(index, value);
                  } 
                },
              );
            },
          ),
          Expanded(
            child: Text(option.title),
          )
        ],
      );
    }
  
//============================================================
// ** Helper Functions **
//============================================================

//============================================================
// ** Navigations **
//============================================================

//============================================================
// ** APIs **
//============================================================
  
}