import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/blocs/pages/page_cubit.dart';
import 'package:tarea/blocs/user/tags_bloc.dart';
import 'package:tarea/blocs/user/to_do_bloc.dart';
import 'package:tarea/models/models.dart';
import 'package:tarea/router/router.dart';
import 'package:tarea/utils/utils.dart';

void main() {
  runApp(const BlocsProvider());
}

class BlocsProvider extends StatelessWidget {
  const BlocsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc(), lazy: true,),
        BlocProvider(create: (context) => TagsBloc(TagsModel()), lazy: false,),
        BlocProvider(create: (context) => ToDoBloc(ToDosModel()), lazy: false,),
        BlocProvider(create: (context) => CurrentPageBloc(0)),
      ], 
      child: const MyApp()
    ); 
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: NailRouter.routes,
      initialRoute: NailRouter.initialRoute,
      theme: NailUtils.getTheme(context),
    );
  }
}