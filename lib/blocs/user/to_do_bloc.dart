import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/models/models.dart';

class ToDoBloc extends Cubit<ToDosModel>{
  ToDoBloc(super.initialState) {
    loadData();
  }

  Map<int, Map<int, ToDoModel>> get getToDos => state.getToDos;

  Future<void> loadData() async {
    final newState = await state.loadData();
    emit(newState);
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

  Future<Map<String, dynamic>> editToDo(int id, int userId,ToDoModel toDo) async {
    final res = await state.editToDo(id, userId, toDo);
    final ok = res["ok"];

    emit(ok ? res["state"] : state);

    return res;
  }

  Future<void> clearData(int id) async {
    emit(await state.clearData());
  }
}