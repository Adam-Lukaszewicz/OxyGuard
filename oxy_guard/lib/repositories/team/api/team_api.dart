import '../../../models/models.dart';

abstract class TeamApi {
  const TeamApi();

  Stream<List<Team>> getTeams();

  Stream<List<Team>> getTeamsByUserId(String userId);

  Future<void> saveTeam(Team team);

  Future<void> deleteTeam(String id);
}

class TeamNotFoundException implements Exception {}