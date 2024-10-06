import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/widgets/widgets.dart';

class ToDosGrid extends StatelessWidget {
  final ToDoBloc toDoBloc;
  final TagsBloc tagsBloc;

  const ToDosGrid({super.key, required this.toDoBloc, required this.tagsBloc});

  @override
  Widget build(BuildContext context) {
    const double spacing = 10; 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text("All to do's:", 
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 225,
          child: ScrollConfiguration(
            behavior: AppScrollBehavior(),
            child: GridView(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
                childAspectRatio: .65
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              scrollDirection: Axis.horizontal, 
              children: [
                ...toDoBloc.getToDos.entries.map((entry) {
                  return ToDo(
                    id: entry.key,
                    toDoModel: entry.value,
                    tagsBloc: tagsBloc,
                  );
                })
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse
  };
}