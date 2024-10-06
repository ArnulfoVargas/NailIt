import 'package:flutter/material.dart';
import 'package:tarea/pages/pages.dart';


class NailRouter {
  static String initialRoute = "loading";
  static Map<String, Widget Function(BuildContext)> routes = {
    "login": (ctx) => const LoginPage(),
    "register" : (ctx) => const RegisterPage(),
    "home" : (ctx) => const SlidablePage(),
    "settings" : (ctx) => const SettingsPage(),
    "loading" : (ctx) => const LoadingPage(),
    "profile" : (ctx) => const ProfileEditPage(),
    "add_tag" : (ctx) => const AddTagPage(),
    "add_todo" : (ctx) => const AddToDoPage(),
  };
}