import 'dart:async';

import 'package:OxyGuard/extras/archive/cubit/archive_state.dart';
import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/repositories/archive/archive_repository.dart';
import 'package:OxyGuard/repositories/finished_squad/finished_squad_repository.dart';
import 'package:OxyGuard/repositories/finished_team/finished_team_repository.dart';
import 'package:OxyGuard/repositories/user_repository.dart';
import 'package:OxyGuard/repositories/worker/worker_repository.dart';
import 'package:OxyGuard/service_locator.dart';
import 'package:bloc/bloc.dart';

class ArchiveCubit extends Cubit<ArchiveState> {
  ArchiveCubit() : super(ArchiveInitial());

  final ArchiveRepository _archiveRepository = sl();
  final FinishedSquadRepository _finishedSquadRepository = sl();
  final FinishedTeamRepository _finishedTeamRepository = sl();
  final WorkerRepository _workerRepository = sl();
  final UserRepository _userRepository = sl();

  StreamSubscription<dynamic>? _subscription;

  void init() async {
    _subscription = _archiveRepository
        .getArchiveByUserId(_userRepository.user.id)
        .listen((List<ArchivedAction> archivedActions) async {
      final List<FinishedSquad> unsortedSquads =
          await _finishedSquadRepository.getFinishedSquadsByUserId(_userRepository.user.id).first;
      final List<FinishedTeam> unsortedTeams =
          await _finishedTeamRepository.getFinishedTeamsByUserId(_userRepository.user.id).first;
      final List<Worker> workers = await _workerRepository.getWorkers().first;
      final Map<String, List<FinishedSquad>> finishedSquads = {};
      final Map<String, List<FinishedTeam>> finishedTeams = {};

      for (final ArchivedAction archivedAction in archivedActions) {
        final List<FinishedSquad> archiveSquads = unsortedSquads
            .where((FinishedSquad finishedSquad) => finishedSquad.archivedActionId == archivedAction.id)
            .toList();
        finishedSquads[archivedAction.id!] = archiveSquads;

        for (final FinishedSquad finishedSquad in archiveSquads) {
          final List<FinishedTeam> archiveTeams = unsortedTeams
              .where((FinishedTeam finishedTeam) => finishedTeam.archivedSquadId == finishedSquad.id)
              .toList();
          finishedTeams[finishedSquad.id!] = archiveTeams;
        }
      }

      archivedActions.sort((ArchivedAction a, ArchivedAction b) => b.endTime.compareTo(a.endTime));

      emit(ArchiveLoadedState(
        archivedActions: archivedActions,
        finishedSquads: finishedSquads,
        finishedTeams: finishedTeams,
        workers: workers
      ));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
