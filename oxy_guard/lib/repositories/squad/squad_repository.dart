import 'package:OxyGuard/repositories/squad/api/squad_api.dart';

import '../../models/models.dart';

class SquadRepository {
  const SquadRepository({required SquadApi squadApi})
      : _squadApi = squadApi;

  final SquadApi _squadApi;

  Stream<List<Squad>> getSquads() => _squadApi.getSquads();

  Stream<List<Squad>> getSquadsByUserId(String userId) => _squadApi.getSquadsByUserId(userId);

  Future<void> saveSquad(Squad squad) => _squadApi.saveSquad(squad);

  Future<void> deleteSquad(String id) => _squadApi.deleteSquad(id);
}