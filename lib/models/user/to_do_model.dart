import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ToDoModel {
  String title;
  String? description;
  late DateTime createdAt;
  DateTime deadLine;
  String tag;
  Color toDoColor;

  static bool isValidToDoName(String value) {
    const pattern = r"^(?:[A-Za-z]{5,15})?$";
    final regex = RegExp(pattern);
    return value.isNotEmpty && regex.hasMatch(value);
  }

  static bool isValidDescription(String value) {
    const pattern = r"^(?:[A-Za-z0-9 ]{5,15})?$";
    final regex = RegExp(pattern);
    return value.isNotEmpty && regex.hasMatch(value);
  }

  ToDoModel({
    required this.title, 
    required this.deadLine,
    this.tag = "",
    DateTime? createdAt,
    this.toDoColor = Colors.teal,
    this.description
  }) {
    DateTime now = DateTime.now();

    this.createdAt = createdAt ?? DateTime(now.year, now.month, now.day);
  }

  Map<String, dynamic> toJson() {
    return {
      "title" : title,
      "description" : description,
      "deadline" : deadLine.millisecondsSinceEpoch,
      "tag" : tag,
      "color" : toDoColor.value,
      "created_at" : createdAt.millisecondsSinceEpoch,
    };
  }

  ToDoModel.fromJson(Map<String, dynamic> json) : 
    title = json["title"], 
    deadLine = DateTime.fromMillisecondsSinceEpoch(json["deadline"]),
    description = json["description"],
    toDoColor = Color(json["color"]),
    createdAt = DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
    tag = json["tag"];
}

class ToDosModel {
  Map<String, ToDoModel> _todos = {};
  Map<String, ToDoModel> get getToDos => _todos;

  ToDosModel({Map<String, ToDoModel>? todos}) {
    _todos = todos ?? <String,ToDoModel>{};
  }

  ToDosModel editToDo(String id, ToDoModel toDo) {
    if (!_todos.containsKey(id)) return this;

    _todos[id] = toDo;
    saveData();
    return ToDosModel(todos: _todos);
  }

  ToDosModel addToDo(ToDoModel toDo) {
    const uuid = Uuid();
    final id = uuid.v8();
    if (!_todos.containsKey(id)) _todos[id] = toDo;
    saveData();

    return ToDosModel(todos: _todos);
  }

  ToDosModel removeToDo(String id) {
    if (!_todos.containsKey(id)) return this;

    _todos.remove(id);
    saveData();
    return ToDosModel(todos: _todos);
  }

  Future<void> saveData() async {
    _todos = {
      "asjdfkljasldfj" : ToDoModel(title: "todo1", deadLine: DateTime(2024, 12, 24), description: "tessjaldfsdkafjt jsdlafjssdklaf ", tag: "20241005-2359-8011-8414-1de39909605a", toDoColor: Colors.red),
      "sdjlsfkajsldfl" : ToDoModel(title: "todo2", deadLine: DateTime(2024, 12, 24), description: "test", tag: "sajf", toDoColor: Colors.blue),
      "flsdakjdflsasf" : ToDoModel(title: "todo3", deadLine: DateTime(2024, 12, 24), description: "test", tag: "sajf", toDoColor: Colors.teal),
      "jsdklfjasdfjas" : ToDoModel(title: "todo4", deadLine: DateTime(2024, 12, 24), description: "test", tag: "sajf", toDoColor: Colors.amber),
      "kdlsjafkjscvdf" : ToDoModel(title: "todo5", deadLine: DateTime(2024, 12, 24), description: "test", tag: "sajf", toDoColor: Colors.orange),
      "dasklfcxvsdjkf" : ToDoModel(title: "todo6", deadLine: DateTime(2024, 12, 24), description: "test", tag: "sajf", toDoColor: Colors.purple),
    };

    final data = jsonEncode(_todos);
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString("todos", data);
  }

  Future<ToDosModel> loadData() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    final jsonString = sh.getString("todos");

    if (jsonString == null) return ToDosModel();

    final json = jsonDecode(jsonString);

    return ToDosModel.fromJson(json);
  }

  ToDosModel.fromJson(Map<String, dynamic> json) {
    _todos = {};
    for(var entry in json.entries) {
      final todo = ToDoModel(
        title: entry.value["title"], 
        description: entry.value["description"],
        tag: entry.value["tag"],
        toDoColor: Color(entry.value["color"]),
        deadLine: DateTime.fromMillisecondsSinceEpoch(entry.value["deadline"]),
        createdAt: DateTime.fromMillisecondsSinceEpoch(entry.value["created_at"]),
      );

      _todos[entry.key] = todo;
    }
  }
}
class ToDoArguments {
  final bool isEditing;
  final ToDoModel? toDo;
  final String toDoId;

  ToDoArguments({this.toDoId = "",this.isEditing = false, this.toDo});
}