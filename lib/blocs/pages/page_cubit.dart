
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentPageBloc extends Cubit<int> {
  CurrentPageBloc(super.initialState);

  void setCurrentPage(int index) {
    emit(index);
  }
}