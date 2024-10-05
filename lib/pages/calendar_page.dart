import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("settings");
            }, 
            icon: const Icon(Icons.settings, color: Colors.black54,)
          )
        ],
      ),
      body: Calendar(
        startOnMonday: true,
        weekDays: const ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
        isExpandable: false,
        showEventListViewIcon: false,
        eventDoneColor: Colors.green,
        selectedColor: const Color(0xFF424242),
        selectedTodayColor: const Color(0xFF229799),
        todayColor: const Color(0xFF229799),
        eventColor: null,
        topRowIconColor: const Color(0xFF424242),
        // hideArrows: true,
        locale: 'en-Eu',
      
        isExpanded: true,
        expandableDateFormat: 'EEEE, dd MMMM yyyy',
        datePickerType: null,
        dayOfWeekStyle: const TextStyle(
            color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 15),
      ),
    );
  }
}