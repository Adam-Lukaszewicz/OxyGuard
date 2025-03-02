import 'package:OxyGuard/models/squad/squad.dart';
import 'package:OxyGuard/squads/api/squads_api.dart';

class SquadsRepository {
  const SquadsRepository({required SquadsApi squadsApi}) : _squadsApi = squadsApi;

  final SquadsApi _squadsApi;

  Stream<List<Squad>> getSquads() => _squadsApi.getSquads();

  Stream<List<Squad>> getSquadsByActionId(String actionId) => _squadsApi.getSquadsByActionId(actionId);

  Future<void> saveSquad(Squad squad) => _squadsApi.saveSquad(squad);

  Future<void> deleteSquad(String id) => _squadsApi.deleteSquad(id);
}