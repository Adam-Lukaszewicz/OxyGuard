import 'package:OxyGuard/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository)
      : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  Future<void> loginWithCredentials() async {
    try {
      _authenticationRepository.logInWithEmailAndPassword(
          email: state.email, password: state.password);
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    }
  }
}
