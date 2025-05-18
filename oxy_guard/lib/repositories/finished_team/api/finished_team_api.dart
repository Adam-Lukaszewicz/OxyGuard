import '../../../models/models.dart';

abstract class FinishedTeamApi {
  const FinishedTeamApi();

  Stream<List<FinishedTeam>> getFinishedTeams();

  Stream<List<FinishedTeam>> getFinishedTeamsByArchivedSquadId(String archivedSquadId);

  Stream<FinishedTeam> getFinishedTeamById(String id);

  Stream<List<FinishedTeam>> getFinishedTeamsByUserId(String userId);

  Future<void> saveFinishedTeam(FinishedTeam finishedTeam);

  Future<void> deleteFinishedTeam(String id);
}

class FinishedTeamNotFoundException implements Exception {}
