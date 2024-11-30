import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/models/models.dart';
import 'package:tarea/widgets/widgets.dart';

class ToDoList extends StatelessWidget {
  final Map<int, ToDoModel> toDos;
  final TagModel tag;
  const ToDoList({super.key, required this.toDos, required this.tag});

  @override
  Widget build(BuildContext context) {
    final tagsBloc = context.watch<TagsBloc>();

    const double spacing = 10; 

    const crossAxisCount = 1;
    const containerSize = 112.5;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(tag.title, 
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 20
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: containerSize,
            child: ScrollConfiguration(
              behavior: AppScrollBehavior(),
              child: GridView(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  childAspectRatio: .65
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                scrollDirection: Axis.horizontal, 
                children: [
                  ...toDos.entries.map((entry) {
                    return ToDo(
                      id: entry.value.id,
                      toDoModel: entry.value,
                      tagsBloc: tagsBloc,
                    );
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}