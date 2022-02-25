import 'package:flutter/material.dart';

class SlidingHorizontalTabBar extends StatefulWidget {

  final EdgeInsets margin;
  final EdgeInsets tabPadding;
  final Function(int currentIndex) onTap;
  final int initialIndex;
  final List<Widget> tabs;
  final Color backgroundColor;
  final Color highlightedTabColor;
  final double height;
  final double borderRadius;
  /// Determines the difference between the border radius of the entire widget and the border radius of a tab. 
  final double tabRadiusBuffer;
  final TextStyle highlightedTextStyle;
  final TextStyle textStyle;

  const SlidingHorizontalTabBar({
    Key? key,
    this.initialIndex = 0, 
    required this.onTap,
    required this.tabs,
    this.backgroundColor = Colors.black12,
    this.highlightedTabColor = Colors.lightBlueAccent,
    this.margin = EdgeInsets.zero,
    this.tabPadding = EdgeInsets.zero,
    this.height = 50.0,
    this.borderRadius = 27.0,
    this.tabRadiusBuffer = 3.0,
    this.highlightedTextStyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    this.textStyle = const TextStyle(color: Colors.white),
  }) :  assert(initialIndex < tabs.length),
        assert(tabs.length > 0),
        super(key: key);

  
  @override
  _SlidingHorizontalTabBarState createState() => _SlidingHorizontalTabBarState();
}

class _SlidingHorizontalTabBarState extends State<SlidingHorizontalTabBar> {

//============================================================
// ** Properties **
//============================================================

  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier(0);

//============================================================
// ** Flutter Life Cycle **
//============================================================

  @override
  void didUpdateWidget(covariant SlidingHorizontalTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _currentIndexNotifier.value = widget.initialIndex;
  }

  @override
  void dispose() {
    super.dispose();

    _currentIndexNotifier.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: Container(
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Stack(
          children: [
            _highlightedBox(),

            _tabTitles(),
          ],
        ),
      ),
    );
  }

//============================================================
// ** Widgets **
//============================================================

  Widget _highlightedBox() {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndexNotifier,
      builder: (_, currentIndex, __) {
        return AnimatedPositioned(
          top: widget.tabPadding.top,
          left: _getSelectedTabLeftPosition(),
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: widget.height - widget.tabPadding.top * 2,
            width: _getTotalWidgetWidth() / widget.tabs.length - widget.tabPadding.left * 2,
            decoration: BoxDecoration(
              color: widget.highlightedTabColor,
              borderRadius: BorderRadius.circular(_getTabBorderRadius()),
            ),
          ),
        );
      }
    );
  }

  Widget _tabTitles() {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndexNotifier,
      builder: (_, currentIndex, __) {
        return Container(
          width: double.infinity,
          height: widget.height,
          child: Row(
            children: widget.tabs.map((tab) {
              final index = widget.tabs.indexOf(tab);

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _currentIndexNotifier.value = index;
                    widget.onTap(index);
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 150),
                        style: (index == _currentIndexNotifier.value)
                          ? widget.highlightedTextStyle
                          : widget.textStyle,
                        child: FittedBox(
                          child: tab,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      } 
    );
  }

//============================================================
// ** Helper Functions **
//============================================================

  double _getSelectedTabLeftPosition() { 
    if (_currentIndexNotifier.value == 0) {
      return widget.tabPadding.left;
    } 

    final leftPadding = widget.tabPadding.left;

    return (_getTotalWidgetWidth() / widget.tabs.length) * _currentIndexNotifier.value - 1 + leftPadding;
    
  }

  double _getTotalWidgetWidth() {
    final screenWidth = MediaQuery.of(context).size.width;
    final width = screenWidth - widget.margin.left * 2;
    return width;
  }

  double _getTabBorderRadius() {
    return widget.borderRadius - widget.tabRadiusBuffer;
  }
}
