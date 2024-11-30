import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/models/models.dart';

class ToDoBloc extends Cubit<ToDosModel>{
  ToDoBloc(super.initialState);

  Map<int, Map<int, ToDoModel>> get getToDos => state.getToDos;

  Future<Map<String, dynamic>> loadData(int idUser) async {
    final res = await state.loadData(idUser);
    final ok = res["ok"];

    emit(ok ? res["state"] : state);

    return res;
  }

  void emptyToDos() {
    emit(state.emptyToDos());
  }

  Future<Map<String, dynamic>> addToDo(ToDoModel toDo, int idUser) async {
    final res = await state.addToDo(toDo, idUser);
    final ok = res["ok"];

    emit(ok ? res["state"] : state);

    return res;
  }

  Future<Map<String, dynamic>> removeToDo(int id, int userId, ToDoModel toDo) async {
    final res = await state.removeToDo(id, userId, toDo);
    final ok = res["ok"];

    emit(ok ? res["state"] : state);

    return res;
  }

  Future<Map<String, dynamic>> editToDo(int id, int userId, int prevTag, ToDoModel toDo) async {
    final res = await state.editToDo(id, userId, prevTag, toDo);
    final ok = res["ok"];

    emit(ok ? res["state"] : state);

    return res;
  }

  Future<Map<String, dynamic>> clearData(int userId) async {
    final res = await state.clearData(userId);
    final ok = res["ok"];

    emit(ok ? res["state"] : state);

    return res;
  }
}