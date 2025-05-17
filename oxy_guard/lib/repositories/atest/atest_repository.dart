import '../../models/models.dart';
import 'api/atest_api.dart';

class AtestRepository {
  const AtestRepository({required AtestApi atestApi})
      : _atestApi = atestApi;

  final AtestApi _atestApi;

  Stream<List<Extinguisher>> getAtests() {
    return _atestApi.getAtests();
  }

  Stream<List<Extinguisher>> getAtestsByUserId(String userId) {
    return _atestApi.getAtestsByUserId(userId);
  }

  Future<void> saveAtest(Extinguisher atest) {
    return _atestApi.saveAtest(atest);
  }

  Future<void> deleteAtest(String id) {
    return _atestApi.deleteAtest(id);
  }
}