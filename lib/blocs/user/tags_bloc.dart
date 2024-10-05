
import 'package:bloc/bloc.dart';
import 'package:tarea/models/models.dart';

class TagsBloc extends Cubit<TagsModel> {
  TagsBloc(super.initialState) {
    loadData();
  }

  Future<void> loadData() async {
    final newState = await state.loadData();
    emit(newState);
  }

  Map<String, TagModel> get getTags => state.getTags;

  void removeTag(String id) {
    emit(state.removeTag(id));
  }

  void addTag(TagModel tag) {
    emit(state.addTag(tag));
  }

  void editTag(String id, TagModel tag) {
    emit(state.editTag(id, tag));
  }
}