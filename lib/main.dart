import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/models/models.dart';
import 'package:tarea/router/router.dart';
import 'package:tarea/utils/utils.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const BlocsProvider());
}

class BlocsProvider extends StatelessWidget {
  const BlocsProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc(), lazy: false,),
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
      themeMode: ThemeMode.light,
      routes: NailRouter.routes,
      initialRoute: NailRouter.initialRoute,
      theme: NailUtils.getTheme(context),
    );
  }
}