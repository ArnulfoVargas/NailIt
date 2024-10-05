
import 'package:bloc/bloc.dart';
import 'package:tarea/models/models.dart';

class UserBloc extends Cubit<UserModel>{
  UserBloc() : super(UserModel()) {
    loadData();
  }

  Future<void> loadData() async {
    emit(await state.loadData());
  }

  Future<void> clearData() async {
    emit(await state.clearData());
  }

  Future<void> storeAndUpdate({String? username, String? mail, String? password, String? phone, String? profileImage}) async {
    final newState = state.copyWith(
      username: username,
      mail: mail,
      password: password,
      phone: phone,
      profileImage: profileImage
    );

    await newState.saveData();
    emit(newState);
  }
}