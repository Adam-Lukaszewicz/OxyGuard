import '../../models/models.dart';
import 'api/atest_api.dart';

class AtestRepository {
  const AtestRepository({required AtestApi atestApi})
      : _atestApi = atestApi;

  final AtestApi _atestApi;

  Stream<List<Extinguisher>> getAtests() => _atestApi.getAtests();

  Stream<List<Extinguisher>> getAtestsByUserId(String userId) => _atestApi.getAtestsByUserId(userId);

  Stream<Extinguisher> getAtestById(String id) => _atestApi.getAtestById(id);

  Future<void> saveAtest(Extinguisher atest) => _atestApi.saveAtest(atest);

  Future<void> deleteAtest(String id) => _atestApi.deleteAtest(id);
}