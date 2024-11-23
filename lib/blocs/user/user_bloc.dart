
import 'package:bloc/bloc.dart';
import 'package:tarea/models/models.dart';
// import 'package:http/http.dart' as http;

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

  Future<Map<String, dynamic>> loginUser({String? mail, String? password}) async{
    final newState = state.copyWith(mail: mail, password: password);
    final result = await newState.loginUser();

    emit(result["ok"] ? newState : state.copyWith());

    return result;
  }

  Future<Map<String, dynamic>> updateUser({String? username, String? mail, String? password, String? phone, String? profileImage}) async {
    final newState = state.copyWith(
      username: username,
      mail: mail,
      password: password,
      phone: phone,
      profileImage: profileImage
    );
    final result = await newState.updateUser();


    emit(result["ok"] ? newState : state.copyWith());

    return result;
  }

  Future<Map<String, dynamic>> registerUser({String? username, String? mail, String? password, String? phone, String? profileImage}) async {
    final newState = state.copyWith(
      username: username,
      mail: mail,
      password: password,
      phone: phone,
      profileImage: profileImage
    );

    final result = await newState.register();

    emit(result["ok"] ? newState : state.copyWith());

    return result;
  }

  Future<Map<String, dynamic>> updateImage(String imagePath) async {
    final newState = state.copyWith(profileImage: imagePath);
    final result = await newState.updateImage();

    emit(result["ok"] ? newState : state.copyWith());

    return result;
  }

  Future<Map<String, dynamic>> removeImage() async {
    final newState = state.copyWith(profileImage: "");
    final result = await newState.removeImage();

    emit(result["ok"] ? newState : state.copyWith());
    return result;
  }

  Future<Map<String, dynamic>> convertToPremium() async {
    final newState = state.copyWith();
    final result = await newState.convertToPremium();

    print(result["ok"]);

    emit(result["ok"] ? newState : state.copyWith());
    return result;
  }
}