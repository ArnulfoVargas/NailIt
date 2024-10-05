import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final userCubit = context.read<UserBloc>();
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
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Text("Home"),
          )
        ),
      ),
    );
  }
}
