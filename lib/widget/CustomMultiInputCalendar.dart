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
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initDay;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: _focusedDay,
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      firstDay: widget.initDay.subtract(Duration(days: 3)),
      lastDay: widget.initDay.add(Duration(days: 365)),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      rangeSelectionMode: RangeSelectionMode.toggledOn,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
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
                },
              );
            }
          }

          widget.onRangeSelected(_rangeStart, _rangeEnd);
        });
      },
      calendarStyle: CalendarStyle(
        rangeHighlightColor: Colors.orangeAccent.withOpacity(0.3),
        rangeStartDecoration: BoxDecoration(
          color: Colors.orangeAccent,
          shape: BoxShape.circle,
        ),
        rangeEndDecoration: BoxDecoration(
          color: Colors.orangeAccent,
          shape: BoxShape.circle,
        ),
        withinRangeTextStyle: TextStyle(color: Colors.white),
        rangeStartTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        rangeEndTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        todayTextStyle: TextStyle(color: Colors.black),
        outsideDaysVisible: true,
        outsideTextStyle: TextStyle(color: Colors.grey),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
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
        disabledBuilder: (context, day, focusedDay) {
          return Center(
            child: Text(
              '${day.day}',
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
