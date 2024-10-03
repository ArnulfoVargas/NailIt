import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<UserBloc>();
    final user = bloc.state;

    return SingleChildScrollView(
      child: Column(
        children: [
          Text("data")
        ],
      ),
    );
  }
}