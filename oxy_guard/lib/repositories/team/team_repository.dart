import 'package:OxyGuard/repositories/team/api/team_api.dart';

import '../../models/models.dart';

class TeamRepository {
  const TeamRepository({required TeamApi teamApi})
      : _teamApi = teamApi;

  final TeamApi _teamApi;

  Stream<List<Team>> getTeams() => _teamApi.getTeams();

  Stream<List<Team>> getTeamsByUserId(String userId) => _teamApi.getTeamsByUserId(userId);

  Future<void> saveTeam(Team team) => _teamApi.saveTeam(team);

  Future<void> deleteTeam(String id) => _teamApi.deleteTeam(id);
}