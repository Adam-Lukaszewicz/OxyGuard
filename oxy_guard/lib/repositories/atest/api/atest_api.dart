import '../../../models/models.dart';

abstract class AtestApi {
  const AtestApi();

  Stream<List<Extinguisher>> getAtests();

  Stream<List<Extinguisher>> getAtestsByUserId(String userId);

  Future<void> saveAtest(Extinguisher atest);

  Future<void> deleteAtest(String id);
}

class AtestNotFoundException implements Exception {}