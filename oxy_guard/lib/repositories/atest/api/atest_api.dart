import '../../../models/models.dart';

abstract class AtestApi {
  const AtestApi();

  Stream<List<Extinguisher>> getAtests();

  Stream<List<Extinguisher>> getAtestsByUserId(String userId);

  Stream<Extinguisher> getAtestById(String id);

  Future<void> saveAtest(Extinguisher atest);

  Future<void> deleteAtest(String id);
}

class AtestNotFoundException implements Exception {}
