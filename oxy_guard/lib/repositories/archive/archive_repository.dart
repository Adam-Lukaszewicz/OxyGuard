import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/repositories/archive/api/archive_api.dart';

class ArchiveRepository {
  const ArchiveRepository({required ArchiveApi archiveApi}) : _archiveApi = archiveApi;

  final ArchiveApi _archiveApi;

  Stream<List<ArchivedAction>> getArchive() => _archiveApi.getArchive();

  Stream<List<ArchivedAction>> getArchiveByUserId(String userId) => _archiveApi.getArchiveByUserId(userId);

  Future<void> saveArchive(ArchivedAction archivedAction) => _archiveApi.saveArchive(archivedAction);

  Future<void> moveActionToArchive(Action action, List<Squad> squads, List<Team> teams) async {
    final ArchivedAction newArchiveEntry = ArchivedAction(uid: action.uid, endTime: DateTime.now(), finishedSquads: []);
    final List<FinishedTeam> finishedTeams = [];
    final List<FinishedSquad> finishedSquads = squads.map((Squad squad) {
      final FinishedSquad finishedSquad = FinishedSquad(
        archivedActionId: newArchiveEntry.id!,
        finishedTeams: [],
      );
      finishedSquad.finishedTeams = teams.where((Team team) => team.squadId == squad.id!).map((Team team) {
        final double averageConsumption = (team.checks.first.$2 - team.checks.last.$2) /
            (team.checks.last.$1.difference(team.checks.first.$1).inSeconds) *
            60;
        final List<String> workers = [];
        if (team.firstWorker != null) {
          workers.add(team.firstWorker!.id!);
        }
        if (team.secondWorker != null) {
          workers.add(team.secondWorker!.id!);
        }
        if (team.thirdWorker != null) {
          workers.add(team.thirdWorker!.id!);
        }
        //TODO: Figure out if there is a better way to store workers in Team model.
        final FinishedTeam finishedTeam = FinishedTeam(
          archivedSquadId: finishedSquad.id!,
          name: team.name,
          averageConsumption: averageConsumption,
          workers: workers,
        );
        finishedTeams.add(finishedTeam);
        finishedSquad.finishedTeams.add(finishedTeam.id!);
        return finishedTeam.id!;
      }).toList();
      newArchiveEntry.finishedSquads.add(finishedSquad.id!);
      return finishedSquad;
    }).toList();
    for (final FinishedSquad finishedSquad in finishedSquads) {
      await _archiveApi.saveFinishedSquad(finishedSquad);
    }
    for (final FinishedTeam finishedTeam in finishedTeams) {
      await _archiveApi.saveFinishedTeam(finishedTeam);
    } 
    await _archiveApi.saveArchive(newArchiveEntry);
  }

  Future<void> deleteArchive(String id) => _archiveApi.deleteArchive(id);

  Stream<List<FinishedSquad>> getFinishedSquads() => _archiveApi.getFinishedSquads();

  Stream<FinishedSquad> getFinishedSquadById(String id) => _archiveApi.getFinishedSquadById(id);

  Stream<List<FinishedSquad>> getFinishedSquadsByArchivedActionId(String archivedActionId) =>
      _archiveApi.getFinishedSquadsByArchivedActionId(archivedActionId);

  Future<void> saveFinishedSquad(FinishedSquad finishedSquad) => _archiveApi.saveFinishedSquad(finishedSquad);

  Future<void> deleteFinishedSquad(String id) => _archiveApi.deleteFinishedSquad(id);

  Stream<List<FinishedTeam>> getFinishedTeams() => _archiveApi.getFinishedTeams();

  Stream<FinishedTeam> getFinishedTeamById(String id) => _archiveApi.getFinishedTeamById(id);

  Stream<List<FinishedTeam>> getFinishedTeamsByArchivedSquadId(String archivedSquadId) =>
      _archiveApi.getFinishedTeamsByArchivedSquadId(archivedSquadId);

  Future<void> saveFinishedTeam(FinishedTeam finishedTeam) => _archiveApi.saveFinishedTeam(finishedTeam);

  Future<void> deleteFinishedTeam(String id) => _archiveApi.deleteFinishedTeam(id);
}
