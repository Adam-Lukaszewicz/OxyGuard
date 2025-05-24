import 'package:OxyGuard/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class TeamState extends Equatable {
  @override
  List<Object?> get props => [];

  TeamState copyWith();
}

class TeamInitial extends TeamState {
  @override
  TeamState copyWith() {
    return this;
  }
}

class TeamLoadedState extends TeamState {
  TeamLoadedState({required this.personnel, required this.workers});

  final Personnel personnel;
  final List<Worker> workers;

  @override
  TeamState copyWith({Personnel? personnel, List<Worker>? workers}) {
    return TeamLoadedState(personnel: personnel ?? this.personnel, workers: workers ?? this.workers);
  }

  @override
  List<Object?> get props => [personnel, workers];
}
