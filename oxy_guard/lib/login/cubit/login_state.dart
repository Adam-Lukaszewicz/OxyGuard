part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];

  LoginState copyWith();
}

final class LoginInitalState extends LoginState {
  @override
  LoginState copyWith() {return this;}
}

final class LoginLoadedState extends LoginState {
  LoginLoadedState({this.email = "", this.password = "", this.errorMessage});

  final String email;
  final String password;
  final String? errorMessage;

  @override
  List<Object?> get props => [email, password, errorMessage];

  @override
  LoginLoadedState copyWith({String? email, String? password, String? errorMessage}) {
    return LoginLoadedState(
        email: email ?? this.email,
        password: password ?? this.password,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
