import 'package:flutter/material.dart';

class DefaultStepper extends StatefulWidget {

  final EdgeInsets margin;
  final double width;
  final double height;
  final int initialValue;
  final int minValue;
  final int maxValue;
  final Color enabledButtonColor;
  final Color disabledButtonColor;
  final Color borderColor;
  final TextStyle valueStyle;
  final Function(int value) onUpdateStepper;
  
  const DefaultStepper({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.width = 150,
    this.height = 50,
    this.minValue = 0,
    this.maxValue = 10,
    this.initialValue = 0,
    this.enabledButtonColor = Colors.cyan,
    this.disabledButtonColor = Colors.black12,
    this.borderColor = Colors.black12,
    this.valueStyle = const TextStyle(fontWeight: FontWeight.bold),
    required this.onUpdateStepper,
  }) :  assert(initialValue >= minValue && initialValue <= maxValue),
        super(key: key);

  @override
  _DefaultStepperState createState() => _DefaultStepperState();
}

class _DefaultStepperState extends State<DefaultStepper> {


//============================================================
// ** Properties **
//============================================================

  final ValueNotifier<int> _currentValueNotifier = ValueNotifier(0);
  final ValueNotifier<bool> _isAddButtonEnabledNotifier = ValueNotifier(true);
  final ValueNotifier<bool> _isMinusButtonEnabled = ValueNotifier(true);

//============================================================
// ** Flutter Build Cycle **
//============================================================

  @override
  void dispose() {
    super.dispose();
    _currentValueNotifier.dispose();
    _isAddButtonEnabledNotifier.dispose();
    _isMinusButtonEnabled.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentValueNotifier.value = widget.initialValue;
    _isMinusButtonEnabled.value = _isValueNotMinValue();
    _isAddButtonEnabledNotifier.value = _isValueNotMaxValue(); 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      width: widget.width,
      height: widget.height,
      decoration: ShapeDecoration(
        shape: StadiumBorder(
          side: BorderSide(color: widget.borderColor)
        ),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _minusButton(),
          _valueText(),
          _addButton(),
        ],
      )
    );
  }

//============================================================
// ** Widgets **
//============================================================

  Widget _valueText() {
    return Expanded(
      child: ValueListenableBuilder<int>(
        valueListenable: _currentValueNotifier,
        builder: (_, value, __) {
          return Text(value.toString(),
            textAlign: TextAlign.center,
            style: widget.valueStyle,
          );
        },
      ),
    );
  }

  Widget _addButton() {
    return Material(
      type: MaterialType.transparency,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isAddButtonEnabledNotifier,
        builder: (_, isAddButtonEnabled, __) {
          return IconButton(
            splashRadius: widget.height * 0.35,
            padding: EdgeInsets.zero,
            disabledColor: widget.disabledButtonColor,
            color: widget.enabledButtonColor,
            onPressed: isAddButtonEnabled
              ? () {
                _currentValueNotifier.value += 1;
                widget.onUpdateStepper(_currentValueNotifier.value);
                _updateButtonState();
              } : null,
            icon: Icon(Icons.add),
          );
        }
      ),
    );
  }

  Widget _minusButton() {
    return Material(
      type: MaterialType.transparency,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isMinusButtonEnabled,
        builder: (_, isMinusButtonEnabled, __) {
          return IconButton(
            splashRadius: widget.height * 0.35,
            padding: EdgeInsets.zero,
            disabledColor: widget.disabledButtonColor,
            color: widget.enabledButtonColor,
            onPressed: isMinusButtonEnabled
              ? () {
                _currentValueNotifier.value -= 1;
                widget.onUpdateStepper(_currentValueNotifier.value);
                _updateButtonState();
              } : null,
            icon: Icon(Icons.remove),
          );
        }
      ),
    );
  }

//============================================================
// ** Helper Functions **
//============================================================

  bool _isValueNotMinValue() {
    return _currentValueNotifier.value != widget.minValue;
  }

  bool _isValueNotMaxValue() {
    return _currentValueNotifier.value != widget.maxValue;
  }

  void _updateButtonState() {
    _isAddButtonEnabledNotifier.value = _isValueNotMaxValue();
    _isMinusButtonEnabled.value = _isValueNotMinValue();
  }
}