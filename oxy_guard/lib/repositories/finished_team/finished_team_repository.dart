import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/repositories/finished_team/api/finished_team_api.dart';

class FinishedTeamRepository {
  const FinishedTeamRepository({required FinishedTeamApi finishedTeamApi}) : _finishedTeamApi = finishedTeamApi;

  final FinishedTeamApi _finishedTeamApi;

  Stream<List<FinishedTeam>> getFinishedTeams() => _finishedTeamApi.getFinishedTeams();

  Stream<List<FinishedTeam>> getFinishedTeamsByArchivedSquadId(String archivedSquadId) =>
      _finishedTeamApi.getFinishedTeamsByArchivedSquadId(archivedSquadId);

  Stream<FinishedTeam> getFinishedTeamById(String id) => _finishedTeamApi.getFinishedTeamById(id);

  Stream<List<FinishedTeam>> getFinishedTeamsByUserId(String userId) => _finishedTeamApi.getFinishedTeamsByUserId(userId);

  Future<void> saveFinishedTeam(FinishedTeam finishedTeam) => _finishedTeamApi.saveFinishedTeam(finishedTeam);

  Future<void> deleteFinishedTeam(String id) => _finishedTeamApi.deleteFinishedTeam(id);
}