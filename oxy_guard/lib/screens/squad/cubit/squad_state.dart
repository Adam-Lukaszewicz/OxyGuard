import 'package:OxyGuard/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class SquadState extends Equatable {
  @override
  List<Object?> get props => [];

  SquadState copyWith();
}

class SquadInitial extends SquadState {
  @override
  SquadState copyWith() {
    return this;
  }
}

class SquadLoadedState extends SquadState {
  SquadLoadedState({required this.squad, required this.teams, required this.finishedTeams});

  final Squad squad;
  final List<Team> teams;
  final List<FinishedTeam> finishedTeams;

  @override
  SquadState copyWith({Squad? squad, List<Team>? teams, List<FinishedTeam>? finishedTeams}) {
    return SquadLoadedState(
      squad: squad ?? this.squad,
      teams: teams ?? this.teams,
      finishedTeams: finishedTeams ?? this.finishedTeams,
    );
  }

  @override
  List<Object?> get props => [squad, teams, finishedTeams];
}
