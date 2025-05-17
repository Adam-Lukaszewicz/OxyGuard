import '../../../models/models.dart';

abstract class ArchiveApi {
  const ArchiveApi();

  Stream<List<Action>> getArchive();

  Stream<List<Action>> getArchiveByUserId(String userId);
  
  Future<void> saveArchive(Action action);

  Future<void> deleteArchive(String id);
}

class ArchiveNotFoundException implements Exception{}