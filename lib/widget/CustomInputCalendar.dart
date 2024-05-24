import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomInputCalendar extends StatelessWidget {
  const CustomInputCalendar({required this.initDay, required this.onDaySelected});

  final initDay;
  final onDaySelected;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: initDay,
      firstDay: initDay.subtract(Duration(days: 3)),
      lastDay: initDay.add(Duration(days: 365)),
      selectedDayPredicate: (date) {
        final newDate = date;
        final defaultTime = TimeOfDay(hour: 18, minute: 0);
        final newDateTime = DateTime(newDate.year, newDate.month, newDate.day, defaultTime.hour, defaultTime.minute);
        return isSameDay(initDay, newDateTime);
      },
      onDaySelected: onDaySelected,
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
        defaultBuilder: (context, day, focusedDay) {
          return Center(
            child: Text(
              '${day.day}',
              style: TextStyle(color: Colors.black),
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
        todayBuilder: (context, day, focusedDay) {
          return Center(
            child: Text(
                  '${day.day}',
                  style: TextStyle(color: Colors.black),
            ),
          );
        },
      ),
    );
  }
}
