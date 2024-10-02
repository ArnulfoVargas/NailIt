
import 'package:bloc/bloc.dart';
import 'package:tarea/controllers/controllers.dart';

class UserBloc extends Cubit<UserController>{
  UserBloc() : super(UserController());

  Future<void> loadData() async {
    emit(await state.loadData());
  }

  Future<void> storeAndUpdate({required String username, required String mail, required String password, required String phone}) async {
    UserController newState = UserController();
    newState.username = username;
    newState.phone = phone;
    newState.mail = mail;
    newState.password = password;
    await newState.saveData();
    emit(newState);
  }
}