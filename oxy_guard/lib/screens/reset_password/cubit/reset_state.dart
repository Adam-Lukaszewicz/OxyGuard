import 'package:equatable/equatable.dart';

abstract class ResetState extends Equatable {
  @override
  List<Object?> get props => [];

  ResetState copyWith();
}

class ResetInitial extends ResetState {
  @override
  ResetState copyWith() {
    return this;
  }
}

class ResetLoadedState extends ResetState {
  ResetLoadedState({this.errorMessage});

  final String? errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  @override
  ResetState copyWith({String? errorMessage}) {
    return ResetLoadedState(
      errorMessage: errorMessage ?? this.errorMessage
    );
  }
}
