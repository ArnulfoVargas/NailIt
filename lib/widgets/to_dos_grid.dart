import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/widgets/widgets.dart';

class ToDosGrid extends StatelessWidget {
  const ToDosGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final toDoBloc = context.watch<ToDoBloc>();
    final tagsBloc = context.watch<TagsBloc>();

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