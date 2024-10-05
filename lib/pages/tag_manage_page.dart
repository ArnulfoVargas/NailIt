import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/models/models.dart';
import 'package:tarea/widgets/widgets.dart';

class TagManagePage extends StatelessWidget {
  const TagManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        onPressed: () {
          Navigator.of(context).pushNamed("add_tag", arguments: TagArguments());
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
      appBar: AppBar(
        title: const Text("Manage Tags"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("settings");
            }, 
            icon: const Icon(Icons.settings, color: Colors.black54,)
          )
        ],
      ),
      body: _displayGridOrEmpty(context),
      // body: _tagGrid(tags),
    );
  }

  EmptyPage _displayEmptyPage() {
    return const EmptyPage(
      icon: Icons.label_off_outlined, 
      label: "You don't have any tags, add some!",
    );
  }

  Widget _displayGridOrEmpty(BuildContext context) {
    final bloc = context.watch<TagsBloc>();
    final count = bloc.getTags.length;
    return count > 0 ? _tagsGrid(count, bloc) : _displayEmptyPage();
  }

  Widget _tagsGrid(int tagsCount, TagsBloc bloc) {
    const double spacing = 10;
    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      children: [
        ...bloc.getTags.entries.map((entry) {
          return Tag(tag: entry.value, tagId: entry.key);
        })
      ],
    );
  }
}