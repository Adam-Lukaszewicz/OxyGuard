import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/repositories/finished_squad/api/finished_squad_api.dart';

class FinishedSquadRepository {
  const FinishedSquadRepository({required FinishedSquadApi finishedSquadApi}) : _finishedSquadApi = finishedSquadApi;

  final FinishedSquadApi _finishedSquadApi;

  Stream<List<FinishedSquad>> getFinishedSquads() => _finishedSquadApi.getFinishedSquads();

  Stream<List<FinishedSquad>> getFinishedSquadsByArchivedActionId(String archivedActionId) =>
      _finishedSquadApi.getFinishedSquadsByArchivedActionId(archivedActionId);

  Stream<FinishedSquad> getFinishedSquadById(String id) => _finishedSquadApi.getFinishedSquadById(id);

  Stream<List<FinishedSquad>> getFinishedSquadsByUserId(String userId) => _finishedSquadApi.getFinishedSquadsByUserId(userId);

  Future<void> saveFinishedSquad(FinishedSquad finishedSquad) => _finishedSquadApi.saveFinishedSquad(finishedSquad);

  Future<void> deleteFinishedSquad(String id) => _finishedSquadApi.deleteFinishedSquad(id);
}