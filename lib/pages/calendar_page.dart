import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/date_picker_config.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Calendar(
          startOnMonday: true,
          weekDays: const ['L', 'M', 'M', 'J', 'V', 'S', 'D'],
          isExpandable: true,
          showEventListViewIcon: false,
          eventDoneColor: Colors.green,
          selectedColor: const Color(0xFF229799),
          selectedTodayColor: const Color(0xFF424242),
          todayColor: const Color(0xFF229799),
          eventColor: null,
          topRowIconColor: const Color(0xFF424242),
          // hideArrows: true,
          locale: 'es-Es',
        
          // todo: modificar esta shit
          todayButtonText: 'Hoy',
          allDayEventText: 'Todos',
          multiDayEndText: 'Fin',
        
          isExpanded: true,
          expandableDateFormat: 'EEEE, dd MMMM yyyy',
          datePickerType: null,
          dayOfWeekStyle: const TextStyle(
              color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 15),
        ),
      ),
    );
  }
}