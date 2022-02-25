import 'dart:async';
import 'package:flutter/material.dart';

/// Wrap this class around a button to prevent it from firing multiple times when users tap a button rapidly.
/// Remove the button function from the [child] widget and pass it into [onPressed].
/// Example usage: Social Sign In buttons in the Login/Signup page. 
class DebouncerWrapper extends StatefulWidget {

  final Function? onPressed;

  final Widget child;

  /// Used to determine how much time will a button be disabled after tapping it.
  /// Set 2 seconds by default. 
  /// For example: 
  /// (i) User taps on button
  /// (ii) button is disabled for 2 seconds (users can't tap it)
  /// (iii) After 2 seconds has passed, the button can be tapped again
  final int debounceTimeMs;

  const DebouncerWrapper({
    Key? key,
    required this.child,
    required this.onPressed,
    this.debounceTimeMs = 2000, // set a default of 2 second delay
  }) : super(key: key);

  @override
  _DebouncerWrapperState createState() => _DebouncerWrapperState();
}

class _DebouncerWrapperState extends State<DebouncerWrapper> {

  ValueNotifier<bool>? _isEnabled = ValueNotifier<bool>(true);
  Timer? _timer;
  Duration? _duration;

  @override
  void initState() {
    super.initState();

    _duration = Duration(milliseconds: widget.debounceTimeMs);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEnabled != null) {
      return ValueListenableBuilder<bool>(
        valueListenable: _isEnabled!,
        builder: (context, isEnabled, child) => InkWell(
          onTap: isEnabled
            ? () => _onButtonPressed()
            : null,
          child: widget.child
        ),
      );
    }

    return Container();
    
  }

  void _onButtonPressed() {
    if (widget.onPressed != null) {
      _isEnabled?.value = false;
      widget.onPressed!();

      if (_duration != null) {
        _timer = Timer(_duration!, 
          () => _isEnabled?.value = true
        );
      }
    }
  }
}