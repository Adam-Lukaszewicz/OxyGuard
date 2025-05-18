import '../../../models/models.dart';

abstract class ArchiveApi {
  const ArchiveApi();

  Stream<List<ArchivedAction>> getArchive();

  Stream<List<ArchivedAction>> getArchiveByUserId(String userId);

  Stream<ArchivedAction> getArchiveById(String id);

  Future<void> saveArchive(ArchivedAction archivedAction);

  Future<void> deleteArchive(String id);
}

class ArchiveNotFoundException implements Exception {}