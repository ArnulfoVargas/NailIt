import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:tarea/blocs/blocs.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final toDoBloc = context.watch<ToDoBloc>();

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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Calendar(
          startOnMonday: true,
          weekDays: const ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'],
          isExpandable: false,
          showEventListViewIcon: false,
          allDayEventText: "",
          eventCellBuilder: (context, event, start, end) {
            double containerHeight = 0;
            const TextStyle descTextStyle = TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 14,
              color: Colors.black38,
            );

            if (event.description.isEmpty) {
              containerHeight = 45;
            } else if (needsSecondLine(context, event.description, descTextStyle)) {
              containerHeight = 85;
            } else {
              containerHeight = 65;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 25,
                    height: containerHeight,
                    decoration: BoxDecoration(
                      color: event.color,
                      borderRadius: const BorderRadius.all(Radius.circular(10))
                    ),
                  ),

                  const SizedBox(width: 10,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(event.summary,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54
                        ),
                      ),

                      if (event.description != "")
                        const SizedBox(height: 5,),

                      if (event.description != "")
                        SizedBox(
                          width: MediaQuery.of(context).size.width *.8,
                          child: Text(event.description,
                            maxLines: 2,
                            softWrap: true,
                            style: descTextStyle
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
          eventDoneColor: Colors.green,
          selectedColor: const Color(0xFF424242),
          selectedTodayColor: const Color(0xFF229799),
          todayColor: const Color(0xFF229799),
          eventColor: null,
          topRowIconColor: const Color(0xFF424242),
          // hideArrows: true,
          locale: 'en-Eu',
          eventsList: [
            if (toDoBloc.getToDos.containsKey(0))
              ...toDoBloc.getToDos[0]!.entries.map((entry) {
                return NeatCleanCalendarEvent(
                  entry.value.title, 
                  id: entry.value.id.toString(),
                  description: entry.value.description ?? "",
                  startTime: entry.value.deadLine, 
                  endTime: entry.value.deadLine,
                  color: entry.value.toDoColor,
                  isAllDay: true,
                );
            })
          ],
        
          isExpanded: true,
          expandableDateFormat: 'EEEE, dd MMMM yyyy',
          datePickerType: null,
          dayOfWeekStyle: const TextStyle(
              color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 15),
        ),
      ),
    );
  }

  bool needsSecondLine(BuildContext context, String title, TextStyle style) {
    final textSpan = TextSpan(
      text: title,
      style: style,
    );
    final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    tp.layout();
    final screenWidth = MediaQuery.of(context).size.width;
    return tp.width > screenWidth - 34; // number is horizontal padding value for the actual widget
  }
}