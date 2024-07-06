import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomMultiInputCalendar extends StatefulWidget {
  const CustomMultiInputCalendar({required this.initDay, required this.onRangeSelected});

  final initDay;
  final onRangeSelected;

  @override
  State<CustomMultiInputCalendar> createState() => _CustomMultiInputCalendarState();
}

class _CustomMultiInputCalendarState extends State<CustomMultiInputCalendar> {
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: widget.initDay,
      firstDay: widget.initDay.subtract(Duration(days: 3)),
      lastDay: widget.initDay.add(Duration(days: 365)),
      selectedDayPredicate: (date) {
        return isSameDay(_rangeStart, date) || isSameDay(_rangeEnd, date);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
            _rangeStart = selectedDay;
            _rangeEnd = null;
          } else if (_rangeStart != null && _rangeEnd == null) {
            if (selectedDay.isBefore(_rangeStart!)) {
              _rangeEnd = _rangeStart;
              _rangeStart = selectedDay;
            } else {
              _rangeEnd = selectedDay;
            }
          }

          if (_rangeStart != null && _rangeEnd != null) {
            final difference = _rangeEnd!.difference(_rangeStart!).inDays;
            if (difference > 7) {
              _rangeEnd = _rangeStart!.add(Duration(days: 6));

              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomAlert(
                        title: '최대 7일까지 설정 가능합니다.',
                        deviceSize: MediaQuery.of(context).size,
                    );
                  }
              );
            }
          }

          widget.onRangeSelected(_rangeStart, _rangeEnd);
        });
      },
      rangeSelectionMode: RangeSelectionMode.toggledOn,
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        weekendStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        // defaultBuilder: (context, day, focusedDay) {
        //   return Center(
        //     child: Text(
        //       '${day.day}',
        //       style: TextStyle(color: Colors.black),
        //     ),
        //   );
        // },
        defaultBuilder: (context, day, focusedDay) {
          bool isWithinRange = _rangeStart != null &&
              _rangeEnd != null &&
              day.isAfter(_rangeStart!.subtract(Duration(days: 1))) &&
              day.isBefore(_rangeEnd!.add(Duration(days: 1)));

          return Container(
            decoration: BoxDecoration(
              color: isWithinRange ? Colors.orange.withOpacity(0.5) : Colors.transparent,
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(color: isWithinRange ? Colors.white : Colors.black),
              ),
            ),
          );
        },
        disabledBuilder: (context, day, focusedDay) {
          return Center(
            child: Text(
              '${day.day}',
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
        outsideBuilder: (context, day, focusedDay) {
          return Center(
            child: Text(
              '${day.day}',
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
        selectedBuilder: (context, day, focusedDay) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
              width: 50.0,
              height: 50.0,
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
        todayBuilder: (context, day, focusedDay) {
          return Center(
            child: Text(
                  '${day.day}',
                  style: TextStyle(color: Colors.black),
            ),
          );
        },
        // rangeStartBuilder: (context, day, focusedDay) {
        //   return Center(
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: Colors.orangeAccent,
        //         shape: BoxShape.circle,
        //       ),
        //       width: 35.0,
        //       height: 35.0,
        //       child: Center(
        //         child: Text(
        //           '${day.day}',
        //           style: TextStyle(color: Colors.white),
        //         ),
        //       ),
        //     ),
        //   );
        // },
        // rangeEndBuilder: (context, day, focusedDay) {
        //   return Center(
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: Colors.orangeAccent,
        //         shape: BoxShape.circle,
        //       ),
        //       width: 35.0,
        //       height: 35.0,
        //       child: Center(
        //         child: Text(
        //           '${day.day}',
        //           style: TextStyle(color: Colors.white),
        //         ),
        //       ),
        //     ),
        //   );
        // },
        // withinRangeBuilder: (context, day, focusedDay) {
        //   return Center(
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: Colors.orangeAccent.withOpacity(0.5),
        //         shape: BoxShape.circle,
        //       ),
        //       width: 35.0,
        //       height: 35.0,
        //       child: Center(
        //         child: Text(
        //           '${day.day}',
        //           style: TextStyle(color: Colors.white),
        //         ),
        //       ),
        //     ),
        //   );
        // },
        withinRangeBuilder: (context, day, focusedDay) {
          bool isStart = isSameDay(day, _rangeStart);
          bool isEnd = isSameDay(day, _rangeEnd);

          return Center(
            child: Container(
              decoration: BoxDecoration(
                color: isStart || isEnd ? Colors.orangeAccent : Colors.orange.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              width: 35.0,
              height: 35.0,
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
