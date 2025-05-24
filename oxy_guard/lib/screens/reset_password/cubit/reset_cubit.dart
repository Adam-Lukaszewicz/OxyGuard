import 'package:OxyGuard/repositories/authentication_repository.dart';
import 'package:OxyGuard/screens/reset_password/cubit/reset_state.dart';
import 'package:OxyGuard/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetCubit extends Cubit<ResetState> {
  ResetCubit() : super(ResetInitial());

  final AuthenticationRepository _authenticationRepository = sl();

  void init() {
    emit(ResetLoadedState());
  }

  Future<bool> sendResetEmail({required String email}) async {
    try {
      await _authenticationRepository.resetPassword(email: email);
      return true;
    } on SendResetPasswordEmailFailure catch (e) {
      emit(ResetLoadedState(errorMessage: e.message));
    }
    return false;
  }
}
