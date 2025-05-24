import 'package:OxyGuard/repositories/squad/api/squad_api.dart';

import '../../models/models.dart';

class SquadRepository {
  const SquadRepository({required SquadApi squadApi})
      : _squadApi = squadApi;

  final SquadApi _squadApi;

  Stream<List<Squad>> getSquads() => _squadApi.getSquads();

  Stream<List<Squad>> getSquadsByActionId(String actionId) => _squadApi.getSquadsByActionId(actionId);

  Stream<Squad> getSquadById(String id) => _squadApi.getSquadById(id);

  Future<void> saveSquad(Squad squad) => _squadApi.saveSquad(squad);

  Future<void> deleteSquad(String id) => _squadApi.deleteSquad(id);
}