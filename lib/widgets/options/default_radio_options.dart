import 'package:flutter/material.dart';

class RadioOption {
  final String title;
  final String? subtitle;
  /// To determine if a radio option is enabled or disabled.
  final bool isSelectable;

  const RadioOption({
    required this.title,
    this.subtitle,
    this.isSelectable = true,
  });
}

class DefaultRadioOptions extends StatefulWidget {

  final EdgeInsets margin;
  final List<RadioOption> optionList;
  final int? initialSelectedIndex;
  final Function(int?) onTapOption;

  const DefaultRadioOptions({
    Key? key,
    this.margin = EdgeInsets.zero,
    required this.optionList,
    this.initialSelectedIndex,
    required this.onTapOption,
  }) : super(key: key);

  @override
  _DefaultRadioOptionsState createState() => _DefaultRadioOptionsState();
}

class _DefaultRadioOptionsState extends State<DefaultRadioOptions> {

//============================================================
// ** Properties **
//============================================================

  final ValueNotifier<int?> _selectedIndexNotifier = ValueNotifier(null);

//============================================================
// ** Flutter Build Cycle **
//============================================================

  @override
  void initState() {
    super.initState();

    _selectedIndexNotifier.value = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.optionList.length,
      itemBuilder: (_, index) {
        return ValueListenableBuilder<int?>(
          valueListenable: _selectedIndexNotifier,
          builder: (_, selectedIndex, __) {
            final option = widget.optionList[index];

            return RadioListTile(
              value: index, 
              groupValue: selectedIndex, 
              onChanged: option.isSelectable
                ? (int? value) {
                  _selectedIndexNotifier.value = value;
                  widget.onTapOption(value);
                } : null,
              subtitle: option.subtitle != null
                ? Text(option.subtitle!)
                : null,
              title: Text(option.title),
            );
          },
        );
      },
    );
  }

//============================================================
// ** Widgets **
//============================================================

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