import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/widgets/widgets.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<UserBloc>();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(image: AssetImage("images/LogoNailItT.png"), width: 150,),
          const SizedBox(width: double.infinity, height: 200,),
          CustomLoading(
            color: const Color(0xFF229799),
            onLoadFunction: () {
              FlutterNativeSplash.remove();
              _onLoad(bloc);
            },
            thickness: 6,
          )
        ],
      ),
    );
  }

  Future<void> _onLoad(UserBloc bloc) async {
    if (bloc.state.loaded) { 
      Future.delayed(Duration.zero, () {}).then((value) async {
        final state = bloc.state;

        if (state.id < 0) {
          _goLogin();
        } else {
          final tagsBloc = _getTagsBloc();
          final todosBloc = _getTodosBloc();

          await tagsBloc.loadData(state.id);
          await todosBloc.loadData(state.id);

          _goHome();
        }
      },);
    }
  }

  TagsBloc _getTagsBloc() {
    return context.read<TagsBloc>();
  }

  ToDoBloc _getTodosBloc() {
    return context.read<ToDoBloc>();
  }

  _goHome() {
    Navigator.of(context).pushReplacementNamed("home");
  }
  _goLogin() {
    Navigator.of(context).pushReplacementNamed("login");
  }
}