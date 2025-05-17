import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/repositories/archive/api/archive_api.dart';

class ArchiveRepository {
  const ArchiveRepository({required ArchiveApi archiveApi}) : _archiveApi = archiveApi;

  final ArchiveApi _archiveApi;

  Stream<List<ArchivedAction>> getActions() => _archiveApi.getArchive();

  Stream<List<ArchivedAction>> getActionsByUserId(String userId) => _archiveApi.getArchiveByUserId(userId);

  Future<void> saveAction(ArchivedAction archivedAction) => _archiveApi.saveArchive(archivedAction);

  Future<void> deleteAction(String id) => _archiveApi.deleteArchive(id);
}
