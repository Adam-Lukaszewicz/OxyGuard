import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object?> get props => [];

  SignupState copyWith();
}

class SignupInitial extends SignupState {
  @override
  SignupState copyWith() {
    return this;
  }
}

class SignupLoadedState extends SignupState {
  SignupLoadedState({this.errorMessage});

  final String? errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  @override
  SignupState copyWith({String? errorMessage}) {
    return SignupLoadedState(errorMessage: errorMessage ?? this.errorMessage);
  }
}
