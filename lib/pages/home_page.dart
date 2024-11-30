import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/models/models.dart';
import 'package:tarea/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final toDoBloc = context.watch<ToDoBloc>();
    final tagsBloc = context.watch<TagsBloc>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("settings");
            }, 
            icon: const Icon(Icons.settings, color: Colors.black54,)
          )
        ],
        title: const Text("Home"),
      ),
    
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        onPressed: (){
          Navigator.of(context).pushNamed("add_todo", arguments: ToDoArguments());
        },
        backgroundColor: const Color(0xFF229799),
        child: const Icon(Icons.add,
          color: Colors.white,
          size: 30,
          shadows: [
            Shadow(
              color: Colors.white60,
              blurRadius: 5
            )
          ],
        ),
      ),
      body: _showToDosOrEmpty(toDoBloc, tagsBloc)
    );
  }
  
  Widget _showToDosOrEmpty(ToDoBloc toDoBloc, TagsBloc tagsBloc) {
    if (toDoBloc.state.getToDos.isNotEmpty) return _showToDos(toDoBloc, tagsBloc);
    return _showEmptyPage();
  }

  Widget _showToDos(ToDoBloc toDoBloc, TagsBloc tagsBloc) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ToDosGrid(),

          for (final entry in toDoBloc.getToDos.entries)
            if (entry.key != 0)
              if (entry.value.isNotEmpty)
                if (tagsBloc.getTags.containsKey(entry.key))
                  ToDoList(tag: tagsBloc.getTags[entry.key]!, toDos: entry.value,)
        ],
      ),
    );
  }

  Widget _showEmptyPage() {
    return const EmptyPage(
      icon: Icons.more_time_rounded,
      label: "Nothing to do, add some activities!",
    );
  }
}
