// Using [table_calendar] widget

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:tealive_ph/constants/custom_fonts.dart';
// import 'package:tealive_ph/constants/palette.dart';
// import 'package:tealive_ph/utils/utils.dart';

// class CalendarView extends StatefulWidget {

//   final DateTime? focusedDay;

//   const CalendarView({
//     Key? key,
//     this.focusedDay,
//   }) : super(key: key);

//   @override
//   State<CalendarView> createState() => _CalendarViewState();
// }

// class _CalendarViewState extends State<CalendarView> {

// //============================================================
// // ** Properties **
// //============================================================

//   static const rangeSelectionCircleStyle = BoxDecoration(
//     color: const Color(0xFFAD8ADC),
//     shape: BoxShape.circle,
//   );

//   late DateTime _startDateLimit;
//   late DateTime _endDateLimit;

//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn; // Can be toggled on/off by longpressing a date
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;

// //============================================================
// // ** Flutter Build Cycle **
// //============================================================

//   @override
//   void initState() {
//     super.initState();

//     _focusedDay = widget.focusedDay ?? DateTime.now();
//     _startDateLimit = DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
//     _endDateLimit = DateTime(_focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 17.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 15.0),
//             child: _header(),
//           ),
//           _calendar(),
//         ],
//       ),
//     );
//   }

// //============================================================
// // ** Widgets **
// //============================================================

//   Widget _calendar() {
//     return TableCalendar(
//       shouldFillViewport: false,
//       firstDay: _startDateLimit,
//       lastDay: _endDateLimit,
//       focusedDay: _focusedDay,
//       selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//       rangeStartDay: _rangeStart,
//       rangeEndDay: _rangeEnd,
//       calendarFormat: _calendarFormat,
//       rangeSelectionMode: _rangeSelectionMode,
//       calendarStyle: CalendarStyle(
//         rangeHighlightColor: const Color(0xFFE5DBFF),
//         rangeStartDecoration: rangeSelectionCircleStyle,
//         rangeEndDecoration: rangeSelectionCircleStyle,
//       ),
//       headerVisible: false,
//       daysOfWeekStyle: DaysOfWeekStyle(
//         dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0],
//         decoration: BoxDecoration(
//           border: const Border(bottom: BorderSide(color: Palette.greyE7E7E7))
//         )
//       ),
//       daysOfWeekHeight: 40.0,
//       rowHeight: 40.0,
//       onDaySelected: (selectedDay, focusedDay) {
//         if (!isSameDay(_selectedDay, selectedDay)) {
//           setState(() {
//             _selectedDay = selectedDay;
//             _focusedDay = focusedDay;
//             _rangeStart = null; // Important to clean those
//             _rangeEnd = null;
//             _rangeSelectionMode = RangeSelectionMode.toggledOff;
//           });
//         }
//       },
//       onRangeSelected: (start, end, focusedDay) {
//         setState(() {
//           _selectedDay = null;
//           _focusedDay = focusedDay;
//           _rangeStart = start;
//           _rangeEnd = end;
//           _rangeSelectionMode = RangeSelectionMode.toggledOn;
//         });
//       },
//       // onFormatChanged: (format) {
//       //   if (_calendarFormat != format) {
//       //     setState(() {
//       //       _calendarFormat = format;
//       //     });
//       //   }
//       // },
//       onPageChanged: (focusedDay) {
//         _focusedDay = focusedDay;
//         setState(() {});
//       },
//     );
//   }

//   Widget _header() {
//     final dateStr = Utils.formatDateTimeLocal(_focusedDay, dateTimeFormat: "MMMM yyyy");

//     return Row(
//       children: [
//         Expanded(
//           child: Text("${dateStr ?? ""}",
//             style: CustomFonts.grey900W700MedPlusInter,
//           ),
//         ),

//         _monthChangerButton(
//           icon: Icons.chevron_left_rounded,
//           isVisible: _isShowLeftButton(),
//           onTap: () {
//             _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
//             setState(() {});
//           }
//         ),

//         _monthChangerButton(
//           margin: const EdgeInsets.only(left: 10.0),
//           icon: Icons.chevron_right_rounded,
//           isVisible: _isShowRightButton(),
//           onTap: () {
//             _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
//             setState(() {});
//           }
//         ),
//       ],
//     );
//   }

//   bool _isShowLeftButton() {
//     final dateToCompare1 = DateTime(_focusedDay.year, _focusedDay.month);
//     final dateToCompare2 = DateTime(_startDateLimit.year, _startDateLimit.month);
//     final differenceInDate = dateToCompare1.compareTo(dateToCompare2);
//     return differenceInDate == 1;
//   }

//   bool _isShowRightButton() {
//     final dateToCompare1 = DateTime(_focusedDay.year, _focusedDay.month);
//     final dateToCompare2 = DateTime(_endDateLimit.year, _endDateLimit.month);
//     final differenceInDate = dateToCompare1.compareTo(dateToCompare2);
//     return differenceInDate == -1;
//   }

//   Widget _monthChangerButton({
//     required IconData icon,
//     required Function() onTap,
//     EdgeInsets margin = EdgeInsets.zero,
//     bool isVisible = true,
//   }) {
//     return Container(
//       margin: margin,
//       child: SizedBox(
//         height: 35,
//         width: 35,
//         child: isVisible
//           ? ElevatedButton(
//             onPressed: onTap,
//             child: Icon(icon, color: Palette.purple7C65E8),
//             style: ElevatedButton.styleFrom(
//               padding: EdgeInsets.zero,
//               fixedSize: const Size(35, 35),
//               shadowColor: Colors.transparent,
//               elevation: 0.0,
//               shape: CircleBorder(),
//               primary: Palette.greyF2F2F2,
//             ),
//           ) : const SizedBox(),
//       ),
//     );
//   }

// //============================================================
// // ** Helper Functions **
// //============================================================

// //============================================================
// // ** Navigations **
// //============================================================

// //============================================================
// // ** APIs **
// //============================================================


// }