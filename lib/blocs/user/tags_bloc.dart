
import 'package:bloc/bloc.dart';
import 'package:tarea/models/models.dart';

class TagsBloc extends Cubit<TagsModel> {
  TagsBloc(super.initialState);

  Map<int, TagModel> get getTags => state.getTags;

  void emptyTags() {
    emit(state.emptyTags());
  }

  Future<Map<String, dynamic>> loadData(int idUser) async {
    final res = await state.loadData(idUser);
    final ok = res["ok"];

    emit(ok ? res["state"] : state);

    return res;
  }

  Future<Map<String, dynamic>> removeTag(int id, int idUser, TagModel tag) async {
    final res = await state.removeTag(id, idUser, tag);
    final ok = res["ok"];

    emit(ok ? res["state"] : state);

    return res;
  }

  Future<Map<String, dynamic>> addTag(TagModel tag, int id) async {
    final res = await state.addTag(tag, id);
    final ok = res["ok"];

    emit(ok ? res["state"] : state);

    return res;
  }

  Future<Map<String, dynamic>> editTag(int id, int userId,TagModel tag) async {
    final res = await state.editTag(id, userId, tag);
    final ok = res["ok"];

    emit(ok ? res["state"] : state);

    return res;
  }

  Future<Map<String, dynamic>> clearData(int id) async {
    final res = await state.clearData(id);
    final ok = res["ok"];

    emit(ok ? res["state"] : state);

    return res;
  }
}