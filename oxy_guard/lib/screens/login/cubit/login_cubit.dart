import 'package:OxyGuard/repositories/authentication_repository.dart';
import 'package:OxyGuard/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitalState());

  final AuthenticationRepository _authenticationRepository = sl();

  void init() {
    emit(LoginLoadedState());
  }

  void emailChanged(String value) {
    emit((state as LoginLoadedState).copyWith(email: value));
  }

  void passwordChanged(String value) {
    emit((state as LoginLoadedState).copyWith(password: value));
  }

  Future<void> loginWithCredentials() async {
    try {
      _authenticationRepository.logInWithEmailAndPassword(
          email: (state as LoginLoadedState).email, password: (state as LoginLoadedState).password);
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit((state as LoginLoadedState).copyWith(errorMessage: e.message));
    }
  }
}
