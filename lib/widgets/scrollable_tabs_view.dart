import 'package:flutter/material.dart';
import 'package:flutter_widgets/utils/debouncer_wrapper.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

enum TabBarPosition { top, left, right, bottom }

//============================================================
// ** Widget - ScrollableTabsView **
//============================================================

class ScrollableTabsView extends StatefulWidget {

  final TabBarPosition tabBarPosition;

  final List<Widget> tabs;

  final List<Widget> contents;

  /// Determines the scroll offset relative to the screen height that determines
  /// which tab should be highlighted on scroll. 
  /// 0.0 indicates top of the screen, 1.0 indicates bottom of the screen.
  final double scrollContentPageThreshold;

  /// Position of the selected [tab] relative to the screenHeight. 
  /// 0.0 indicates start of screen, 1.0 indicates end of screen.
  final double selectedTabAlignment;

  final double tabBarElevation;

  /// The height (if [tabBarPosition] is left or right) / width (if [tabBarPosition] is top or bottom) of a single tab.
  final double? tabSize;

  /// The width / height of the tab bar in total. 
  final double tabBarSize;

  final Color selectedTabIndicatorColor;

  final double selectedTabIndicatorSize;

  final Color tabBarColor;

  final Function(int tabIndex)? onSelectTab;

  final Function(int pageIndex)? onPageChange;

  const ScrollableTabsView({
    Key? key,
    this.tabSize,
    this.tabBarPosition = TabBarPosition.left,
    required this.tabs,
    required this.contents,
    this.tabBarSize = 75.0,
    this.selectedTabIndicatorColor = Colors.lightBlueAccent,
    this.scrollContentPageThreshold = 0.5,
    this.selectedTabAlignment = 0.5,
    this.tabBarElevation = 1.0,
    this.tabBarColor = Colors.white,
    this.onSelectTab,
    this.onPageChange,
    this.selectedTabIndicatorSize = 5.0,
  })  : assert(tabs.length == contents.length),
        assert(selectedTabAlignment >= 0 && selectedTabAlignment <= 1),
        assert(scrollContentPageThreshold >= 0 && scrollContentPageThreshold < 1),
        super(key: key);

  @override
  State<ScrollableTabsView> createState() => _ScrollableTabsViewState();
}

class _ScrollableTabsViewState extends State<ScrollableTabsView> {

//============================================================
// ** Properties **
//============================================================

  /// When set to false, prevents the tab bar indicator from moving together with the scroll position when tapping on a tab. 
  /// Set to false when tapping on a tab. 
  bool _updateIndexOnScroll = true;

  final ValueNotifier<int> _tabIndexValueNotifier = ValueNotifier(1);
  final ItemScrollController _contentScrollController = ItemScrollController();
  final ItemPositionsListener _contentScrollPositionsListener = ItemPositionsListener.create();

  List<GlobalKey> _tabGlobalKeyList = [];

//============================================================
// ** Flutter Build Cycle **
//============================================================

  @override
  void initState() {
    super.initState();

    _setupGlobalKeyList();
    _setContentScrollListener();
  }

  @override
  void dispose() {
    super.dispose();
    _tabIndexValueNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.tabBarPosition) {
      case TabBarPosition.top:
        return _verticalBody(direction: VerticalDirection.down);
      case TabBarPosition.left:
        return _horizontalBody();
      case TabBarPosition.right:
        return _horizontalBody(direction: TextDirection.rtl);
      case TabBarPosition.bottom:
        return _verticalBody(direction: VerticalDirection.up);
    }
  }

//============================================================
// ** Widgets **
//============================================================

  Widget _horizontalBody({TextDirection? direction}) {
    return Row(
      textDirection: direction,
      children: [
        _tabBar(),
        _contentView(),
      ],
    );
  }

  Widget _verticalBody({required VerticalDirection direction}) {
    return Column(
      verticalDirection: direction,
      children: [
        _tabBar(),
        _contentView(),
      ],
    );
  }

  Widget _tabBar() {
    return Material(
      color: widget.tabBarColor,
      elevation: widget.tabBarElevation,
      child: ValueListenableBuilder<int>(
        valueListenable: _tabIndexValueNotifier,
        builder: (context, currentIndex, child) {
          return Container(
            width: widget.tabBarPosition == TabBarPosition.left || widget.tabBarPosition == TabBarPosition.right
              ? widget.tabBarSize
              : null,
            height: widget.tabBarPosition == TabBarPosition.top || widget.tabBarPosition == TabBarPosition.bottom
              ? widget.tabBarSize
              : null,
            child: ListView.builder(
              scrollDirection: widget.tabBarPosition == TabBarPosition.left || widget.tabBarPosition == TabBarPosition.right
                ? Axis.vertical
                : Axis.horizontal,
              itemCount: widget.tabs.length,
              itemBuilder: (context, index) {
                return VerticalScrollableTabItem(
                  tabSize: widget.tabSize,
                  tabBarPosition: widget.tabBarPosition,
                  child: widget.tabs[index],
                  key: _tabGlobalKeyList[index],
                  onTap: () {
                    _onTapTab(index);
                    if (widget.onSelectTab != null) widget.onSelectTab!(index);
                  },
                  indicatorSize: widget.selectedTabIndicatorSize,
                  isSelected: index == currentIndex,
                  selectedIndexColor: widget.selectedTabIndicatorColor,
                );
              },
            ),
          );
        }
      ),
    );
  }

  Widget _contentView() {
    return Expanded(
      child: ScrollablePositionedList.builder(
        itemCount: widget.tabs.length,
        itemBuilder: (context, index) => widget.contents[index],
        itemScrollController: _contentScrollController,
        itemPositionsListener: _contentScrollPositionsListener,
        scrollDirection: Axis.vertical,
      ),
    );
  }

//============================================================
// ** Helper Functions **
//============================================================

  /// Sets up a list of global keys to be associated with each [VerticalScrollableTabItem].
  /// This is to allow each tab item to be visible when scrolling through the [contents].
  void _setupGlobalKeyList() {
    for (int i = 0; i < widget.tabs.length; i++) {
      _tabGlobalKeyList.add(GlobalKey());
    }
  }

  void _setContentScrollListener() {
    _contentScrollPositionsListener.itemPositions.addListener(() {
      if (!_updateIndexOnScroll) return;

      // retrieves the current page that is being displayed on the screen
      int currentPage = _contentScrollPositionsListener.itemPositions.value.where((position) {
        return position.itemLeadingEdge < widget.scrollContentPageThreshold;
      }).reduce((max, position) => position.itemLeadingEdge > max.itemLeadingEdge ? position : max)
        .index;

      if (_tabIndexValueNotifier.value != currentPage) {
        if (widget.onPageChange != null) widget.onPageChange!(currentPage);
        // set the highlighted indicator on the tab bar on scroll
        _tabIndexValueNotifier.value = currentPage;
      }

      // ensures that the selected tab is always visible in the screen
      final currentContext = _tabGlobalKeyList[currentPage].currentContext;
      if (currentContext != null) Scrollable.ensureVisible(currentContext,
        alignment: widget.selectedTabAlignment,
      );
    });
  }

  void _onTapTab(int index) async {
    _tabIndexValueNotifier.value = index;
    _updateIndexOnScroll = false;
    final currentContext = _tabGlobalKeyList[index].currentContext;
    if (currentContext != null) Scrollable.ensureVisible(currentContext,
      alignment: widget.selectedTabAlignment,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInCubic,
    );
    await _contentScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInCubic,
    );
    _updateIndexOnScroll = true;
  }
}

//============================================================
// ** Widget - VerticalScrollableTabItem **
//============================================================

class VerticalScrollableTabItem extends StatelessWidget {
  final TabBarPosition tabBarPosition;
  final Widget child;
  final Color selectedIndexColor;
  final bool isSelected;
  final double? tabSize;
  final double indicatorSize;
  final Function() onTap;

  const VerticalScrollableTabItem({
    Key? key,
    required this.tabBarPosition,
    required this.selectedIndexColor,
    this.tabSize,
    required this.indicatorSize,
    required this.child,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  static const String _top = "top";
  static const String _bottom = "bottom";
  static const String _left = "left";
  static const String _right = "right";

  @override
  Widget build(BuildContext context) {
    return DebouncerWrapper(
      onPressed: this.onTap,
      child: Container(
        color: Colors.transparent,
        height: this.tabBarPosition == TabBarPosition.left || this.tabBarPosition == TabBarPosition.right
          ? this.tabSize
          : double.infinity,
        width: this.tabBarPosition == TabBarPosition.top || this.tabBarPosition == TabBarPosition.bottom
          ? this.tabSize
          : double.infinity,
        child: Stack(
          children: [
            // tab widget
            Center(
              child: this.child,
            ),
            
            // selected indicator
            isSelected
              ? Positioned(
                top: returnPosition()[_top], 
                left: returnPosition()[_left],
                bottom: returnPosition()[_bottom],
                right: returnPosition()[_right],
                child: Container(
                  height: this.tabBarPosition == TabBarPosition.left || this.tabBarPosition == TabBarPosition.right
                    ? double.infinity
                    : this.indicatorSize,
                  width: this.tabBarPosition == TabBarPosition.top || this.tabBarPosition == TabBarPosition.bottom
                    ? double.infinity
                    : this.indicatorSize,
                  color: this.selectedIndexColor,
                ),
              ) : const SizedBox(),   
          ],
        )
      ),
    );
  }

//============================================================
// ** Helper Functions **
//============================================================
  
  Map<String, double?> returnPosition() {
    switch (this.tabBarPosition) {
      case TabBarPosition.top:
        return {
          _top: null,
          _bottom: 0.0,
          _left: 0.0,
          _right: 0.0,
        };
      case TabBarPosition.left:
        return {
          _top: 0.0,
          _bottom: 0.0,
          _left: 0.0,
          _right: null,
        };
      case TabBarPosition.right:
        return {
          _top: 0.0,
          _bottom: 0.0,
          _left: null,
          _right: 0.0,
        };
      case TabBarPosition.bottom:
        return {
          _top: 0.0,
          _bottom: null,
          _left: 0.0,
          _right: 0.0,
        };
    }
  }


}