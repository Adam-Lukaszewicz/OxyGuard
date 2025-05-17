import '../../models/models.dart';
import 'api/atest_api.dart';

class AtestRepository {
  final AtestApi _atestApi;

  const AtestRepository(this._atestApi);

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