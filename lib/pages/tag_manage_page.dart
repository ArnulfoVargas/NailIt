import 'package:flutter/material.dart';

class TagManagePage extends StatelessWidget {
  const TagManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        onPressed: (){},
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
      body: Center(child: Text("Tags Manage"),),
    );
  }
}