import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea/models/models.dart';
import 'package:tarea/utils/utils.dart';
import 'package:http/http.dart' as http;

class ToDoModel {
  int id = 0;
  String title;
  String? description;
  DateTime deadLine;
  int tag;
  Color toDoColor;

  static bool isValidToDoName(String value) {
    const pattern = r"^(?:[A-Za-z ]{5,15})?$";
    final regex = RegExp(pattern);
    return value.isNotEmpty && regex.hasMatch(value);
  }

  static bool isValidDescription(String value) {
    const pattern = r"^(?:[A-Za-z0-9 ]{0,100})?$";
    final regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  ToDoModel({
    required this.title, 
    required this.deadLine,
    this.tag = 0,
    this.id = 0,
    this.toDoColor = Colors.teal,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "title" : title,
      "description" : description,
      "deadline" : deadLine.millisecondsSinceEpoch,
      "tag" : tag,
      "color" : toDoColor.value,
    };
  }

  ToDoModel.fromJson(Map<String, dynamic> json) : 
    title = json["title"], 
    deadLine = DateTime.parse(json["deadline"]),
    description = json["description"],
    toDoColor = Color(json["color"] as int),
    tag = json["tag"] as int;
}

class ToDosModel {
  Map<int, Map<int, ToDoModel>> _todos = {};
  Map<int, Map<int, ToDoModel>> get getToDos => _todos;

  ToDosModel({Map<int, Map<int, ToDoModel>>? todos}) {
    _todos = todos ?? <int, Map<int,ToDoModel>>{};
  }

  Future<Map<String, dynamic>> editToDo(int id, int userId, ToDoModel toDo) async {
    try{
      final uri = Uri.https(NailUtils.baseRoute, "todos/update/$id");
      final res = await http.put(uri, body: jsonEncode(
        <String, dynamic> {
          "title" : toDo.title,
          "description" : toDo.description ?? "",
          "tag" : toDo.tag,
          "color" : toDo.toDoColor.value,
          "created_by" : userId,
          "deadline" : toDo.deadLine.millisecondsSinceEpoch
        }
      )).timeout(const Duration(seconds: 5));

      final data = jsonDecode(res.body);
      final body = data["body"];

      if (res.statusCode == 200) {
        ToDoModel newTodo = ToDoModel.fromJson(body);
        newTodo.id = id;
        _updateToDosMap(toDo, newTodo: newTodo);

        return {
          "state" : ToDosModel(todos: _todos),
          "ok" : true,
          "error" : ""
        };
      }

      return {
        "ok" : false,
        "error" : "cannot create"
      };
    } catch(e) {
      return {
        "ok" : false,
        "error" : "unexpected error"
      };
    }
  }

//{id: 3, tag: {title: example, description: , color: 4294930176, deadline: 2024-11-24T22:44:15.544Z, tag: 0, created_by: 1}}
  Future<Map<String, dynamic>> addToDo(ToDoModel toDo, int userId) async {
    try{
      final uri = Uri.https(NailUtils.baseRoute, "todos/create");
      final res = await http.post(uri, body: jsonEncode(
        <String, dynamic> {
          "title" : toDo.title,
          "description" : toDo.description ?? "",
          "tag" : toDo.tag,
          "color" : toDo.toDoColor.value,
          "created_by" : userId,
          "deadline" : toDo.deadLine.millisecondsSinceEpoch
        }
      )).timeout(const Duration(seconds: 5));

      final data = jsonDecode(res.body);

      if (res.statusCode == 201) {
        toDo.id = data["body"]["id"];

        _updateToDosMap(toDo);

        return {
          "state" : ToDosModel(todos: _todos),
          "ok" : true,
          "error" : ""
        };
      }

      return {
        "ok" : false,
        "error" : "cannot create"
      };
    } catch(e) {
      return {
        "ok" : false,
        "error" : "unexpected error"
      };
    }
  }

  Future<Map<String,dynamic>> removeToDo(int id, int userId, ToDoModel toDo) async {
    try{
      final uri = Uri.https(NailUtils.baseRoute, "todos/delete/$id");
      final res = await http.delete(uri, body: jsonEncode(
        <String, dynamic> {
          "title" : toDo.title,
          "description" : toDo.description ?? "",
          "tag" : toDo.tag,
          "color" : toDo.toDoColor.value,
          "created_by" : userId,
          "deadline" : toDo.deadLine.millisecondsSinceEpoch
        }
      )).timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        _updateToDosMap(toDo, delete: true);

        return {
          "state" : ToDosModel(todos: _todos),
          "ok" : true,
          "error" : ""
        };
      }

      return {
        "ok" : false,
        "error" : "cannot create"
      };
    } catch(e) {
      return {
        "ok" : false,
        "error" : "unexpected error"
      };
    }
  }

  Future<void> saveData() async {
    final data = jsonEncode(_todos);
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString("todos", data);
  }

  Future<ToDosModel> clearData() async {


    return ToDosModel();
  }

  Future<ToDosModel> loadData() async {
    // SharedPreferences sh = await SharedPreferences.getInstance();
    // final jsonString = sh.getString("todos");
    // if (jsonString == null) return ToDosModel();
    // final json = jsonDecode(jsonString);
    return ToDosModel();
  }

  _updateToDosMap(ToDoModel oldTodo, {bool delete = false, ToDoModel? newTodo}) {
    final oldTodoTag = oldTodo.tag;
    final oldTodoId = oldTodo.id;
    final newTodoTag = newTodo != null ? newTodo.tag : 0;
    final newTodoId = newTodo != null ? newTodo.id : 0;

    if (delete) {
      if (_todos.containsKey(0)) {
        _todos[0]!.remove(oldTodoId);
      }
      if (_todos.containsKey(oldTodoTag) && oldTodoTag != 0) {
        _todos[oldTodoTag]!.remove(oldTodoTag);
      }
    } else {
      if (newTodo != null) {
        if (!_todos.containsKey(0)) {
          _todos[0] = <int, ToDoModel>{};
        }
        if (!_todos.containsKey(newTodoTag)) {
          _todos[newTodoTag] = <int, ToDoModel>{};
        }

        _todos[0]![newTodoId] = newTodo;
        _todos[newTodoTag]![newTodoId] = newTodo;
      } else {
        if (!_todos.containsKey(0)) {
          _todos[0] = <int, ToDoModel>{};
        }
        if (!_todos.containsKey(oldTodoTag)) {
          _todos[oldTodoTag] = <int, ToDoModel>{};
        }
        _todos[0]![oldTodoId] = oldTodo;
        _todos[oldTodoTag]![oldTodoId] = oldTodo;
      }
    }
  }
}
class ToDoArguments {
  final bool isEditing;
  final ToDoModel? toDo;
  final int toDoId;

  ToDoArguments({this.toDoId = 0,this.isEditing = false, this.toDo});
}