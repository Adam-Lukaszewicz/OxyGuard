import '../../../models/models.dart';

abstract class TeamApi {
  const TeamApi();

  Stream<List<Team>> getTeams();

  Stream<List<Team>> getTeamsBySquadId(String squadId);
  
  Stream<Team> getTeamById(String id);

  Future<void> saveTeam(Team team);

  Future<void> deleteTeam(String id);
}

class TeamNotFoundException implements Exception {}