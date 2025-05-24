import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  @override
  List<Object?> get props => [];

  SettingsState copyWith();
}

class SettingsInitial extends SettingsState {
  @override
  SettingsState copyWith() {
    return this;
  }
}

class SettingsLoadedState extends SettingsState {
  @override
  SettingsState copyWith() {
    return this;
  }
}
