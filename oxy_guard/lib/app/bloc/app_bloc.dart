import 'dart:async';

import 'package:OxyGuard/models/user.dart';
import 'package:OxyGuard/repositories/authentication_repository.dart';
import 'package:OxyGuard/repositories/user_repository.dart';
import 'package:OxyGuard/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(): super(AppState()) {
    on<AppUserSubscriptionRequested>(_onUserSubscriptionRequested);
    on<AppLogoutPressed>(_onLogoutPressed);
  }

  final AuthenticationRepository _authenticationRepository = sl();
  final UserRepository _userRepository = sl();

  Future<void> _onUserSubscriptionRequested(
    AppUserSubscriptionRequested event,
    Emitter<AppState> emit,
  ) {
    return emit.onEach(
      _authenticationRepository.user,
      onData: (user) {
        emit(AppState(user: user));
        _userRepository.user = user;
      },
      onError: addError,
    );
  }

  void _onLogoutPressed(
    AppLogoutPressed event,
    Emitter<AppState> emit,
  ) {
    _authenticationRepository.logOut();
    _userRepository.logOut();
  }
}
