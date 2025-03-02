import '../../models/models.dart';

abstract class SquadsApi {
  const SquadsApi();

  Stream<List<Squad>> getSquads();

  Stream<List<Squad>> getSquadsByActionId(String actionId);

  Future<void> saveSquad(Squad squad);

  Future<void> deleteSquad(String id);
}

class SquadNotFoundException implements Exception{}