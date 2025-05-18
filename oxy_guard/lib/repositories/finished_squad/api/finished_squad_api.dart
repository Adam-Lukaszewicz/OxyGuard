import '../../../models/models.dart';

abstract class FinishedSquadApi {
  const FinishedSquadApi();

  Stream<List<FinishedSquad>> getFinishedSquads();

  Stream<List<FinishedSquad>> getFinishedSquadsByArchivedActionId(String archivedActionId);

  Stream<FinishedSquad> getFinishedSquadById(String id);

  Stream<List<FinishedSquad>> getFinishedSquadsByUserId(String userId);

  Future<void> saveFinishedSquad(FinishedSquad finishedSquad);

  Future<void> deleteFinishedSquad(String id);
}

class FinishedSquadNotFoundException implements Exception {}