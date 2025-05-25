import 'package:OxyGuard/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class PersonnelState extends Equatable {
  @override
  List<Object?> get props => [];

  PersonnelState copyWith();
}

class PersonnelInitial extends PersonnelState {
  @override
  PersonnelState copyWith() {
    return this;
  }
}

class PersonnelLoadedState extends PersonnelState {
  PersonnelLoadedState({required this.personnel, required this.workers});

  final Personnel personnel;
  final List<Worker> workers;

  @override
  PersonnelState copyWith({Personnel? personnel, List<Worker>? workers}) {
    return PersonnelLoadedState(personnel: personnel ?? this.personnel, workers: workers ?? this.workers);
  }

  @override
  List<Object?> get props => [personnel, workers];
}
