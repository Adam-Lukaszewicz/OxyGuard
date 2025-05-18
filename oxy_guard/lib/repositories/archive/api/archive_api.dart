import '../../../models/models.dart';

abstract class ArchiveApi {
  const ArchiveApi();

  Stream<List<ArchivedAction>> getArchive();

  Stream<List<ArchivedAction>> getArchiveByUserId(String userId);

  Stream<ArchivedAction> getArchiveById(String id);

  Future<void> saveArchive(ArchivedAction archivedAction);

  Future<void> deleteArchive(String id);

  Stream<List<FinishedSquad>> getFinishedSquads();

  Stream<FinishedSquad> getFinishedSquadById(String id);

  Stream<List<FinishedSquad>> getFinishedSquadsByArchivedActionId(String archivedActionId);

  Future<void> saveFinishedSquad(FinishedSquad finishedSquad);
  
  Future<void> deleteFinishedSquad(String id);

  Stream<List<FinishedTeam>> getFinishedTeams();

  Stream<FinishedTeam> getFinishedTeamById(String id);

  Stream<List<FinishedTeam>> getFinishedTeamsByArchivedSquadId(String archivedSquadId);

  Future<void> saveFinishedTeam(FinishedTeam finishedTeam);

  Future<void> deleteFinishedTeam(String id);
}

class ArchiveNotFoundException implements Exception {}

class FinishedSquadNotFoundException implements Exception {}

class FinishedTeamNotFoundException implements Exception {}
