import 'package:OxyGuard/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class ActionListState extends Equatable {
  @override
  List<Object?> get props => [];

  ActionListState copyWith();
}

class ActionListInitial extends ActionListState {
  @override
  ActionListState copyWith() {
    return this;
  }
}

class ActionListLoadedState extends ActionListState {
  ActionListLoadedState({required this.actions, required this.offlineMode});

  final List<Action> actions;
  final bool offlineMode;

  @override
  ActionListState copyWith({List<Action>? actions, bool? offlineMode}) {
    return ActionListLoadedState(actions: actions ?? this.actions, offlineMode: offlineMode ?? this.offlineMode);
  }

  @override
  List<Object?> get props => [actions];
}
