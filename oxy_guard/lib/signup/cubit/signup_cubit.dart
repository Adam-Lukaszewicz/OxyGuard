import 'package:OxyGuard/repositories/authentication_repository.dart';
import 'package:OxyGuard/service_locator.dart';
import 'package:OxyGuard/signup/cubit/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  final AuthenticationRepository _authenticationRepository = sl();

  void init() {
    emit(SignupLoadedState());
  }

  Future<bool> signUp({required String email, required String password}) async {
    try {
      await _authenticationRepository.signUp(email: email, password: password);
      return true;
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit((state as SignupLoadedState).copyWith(errorMessage: e.message));
    }
    return false;
  }
}
