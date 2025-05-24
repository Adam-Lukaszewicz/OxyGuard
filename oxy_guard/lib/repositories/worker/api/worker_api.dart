import '../../../models/models.dart';

abstract class WorkerApi {
  const WorkerApi();

  Stream<List<Worker>> getWorkers();

  Stream<List<Worker>> getWorkersByPersonnelId(String id);

  Stream<Worker> getWorkerById(String id);

  Future<void> saveWorker(Worker worker);

  Future<void> deleteWorker(String id);
}

class WorkerNotFoundException implements Exception {}
