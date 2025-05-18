import '../../../models/models.dart';

abstract class SquadApi {
  const SquadApi();

  Stream<List<Squad>> getSquads();

  Stream<List<Squad>> getSquadsByActionId(String userId);

  Stream<Squad> getSquadById(String id);

  Future<void> saveSquad(Squad squad);

  Future<void> deleteSquad(String id);
}

class SquadNotFoundException implements Exception {}