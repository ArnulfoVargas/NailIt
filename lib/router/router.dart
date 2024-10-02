import 'package:flutter/material.dart';
import 'package:tarea/pages/pages.dart';


class NailRouter {
  static String initialRoute = "loading";
  static Map<String, Widget Function(BuildContext)> routes = {
    "login": (ctx) => const LoginPage(),
    "register" : (ctx) => const RegisterPage(),
    "home" : (ctx) => const SlidablePage(),
    "loading" : (ctx) => const LoadingPage(),
  };
}