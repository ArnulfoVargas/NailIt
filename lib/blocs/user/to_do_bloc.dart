import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/models/models.dart';

class ToDoBloc extends Cubit<ToDosModel>{
  ToDoBloc(super.initialState) {
    loadData();
  }

  Map<String, ToDoModel> get getToDos => state.getToDos;

  Future<void> loadData() async {
    final newState = await state.loadData();
    emit(newState);
  }

  void addToDo(ToDoModel toDo) {
    emit(state.addToDo(toDo));
  }

  void removeToDo(String id) {
    emit(state.removeToDo(id));
  }

  void editToDo(String id, ToDoModel toDo) {
    emit(state.editToDo(id, toDo));
  }

  Future<void> clearData() async {
    emit(await state.clearData());
  }
}