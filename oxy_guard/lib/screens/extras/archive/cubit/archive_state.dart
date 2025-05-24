import 'package:OxyGuard/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class ArchiveState extends Equatable {
  @override
  List<Object> get props => [];

  ArchiveState copyWith();
}

class ArchiveInitial extends ArchiveState {
  @override
  ArchiveState copyWith() {
    return this;
  }
}

class ArchiveLoadedState extends ArchiveState {
  ArchiveLoadedState({
    required this.archivedActions,
    required this.finishedSquads,
    required this.finishedTeams,
    required this.workers
  });

  final List<ArchivedAction> archivedActions;
  final Map<String, List<FinishedSquad>> finishedSquads;
  final Map<String, List<FinishedTeam>> finishedTeams;
  final List<Worker> workers;

  @override
  List<Object> get props => [
        archivedActions,
        finishedSquads,
        finishedTeams,
      ];

  @override
  ArchiveLoadedState copyWith(
      {List<ArchivedAction>? archivedActions,
      Map<String, List<FinishedSquad>>? finishedSquads,
      Map<String, List<FinishedTeam>>? finishedTeams,
      List<Worker>? workers}) {
    return ArchiveLoadedState(
      archivedActions: archivedActions ?? this.archivedActions,
      finishedSquads: finishedSquads ?? this.finishedSquads,
      finishedTeams: finishedTeams ?? this.finishedTeams,
      workers: workers ?? this.workers
    );
  }
}
