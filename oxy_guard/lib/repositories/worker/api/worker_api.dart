import '../../../models/models.dart';

abstract class WorkerApi {
  const WorkerApi();

  Stream<List<Worker>> getWorkers();

  Stream<List<Worker>> getWorkersByUserId(String userId);

  Future<void> saveWorker(Worker worker);

  Future<void> deleteWorker(String id);
}

class WorkerNotFoundException implements Exception {}