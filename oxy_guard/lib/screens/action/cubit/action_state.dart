import 'package:OxyGuard/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class ActionState extends Equatable {
  @override
  List<Object?> get props => [];

  ActionState copyWith();
}

class ActionInitial extends ActionState {
  @override
  ActionState copyWith() {
    return this;
  }
}

class ActionLoadedState extends ActionState {
  ActionLoadedState({required this.action, required this.squads, required this.workers});

  final Action action;
  final List<Squad> squads;
  final List<Worker> workers;

  @override
  ActionState copyWith({Action? action, List<Squad>? squads, List<Worker>? workers}) {
    return ActionLoadedState(action: action ?? this.action, squads: squads ?? this.squads, workers: workers ?? this.workers);
  }

  @override
  List<Object?> get props => [action, squads, workers];
}
