import 'package:OxyGuard/repositories/worker/api/worker_api.dart';

import '../../models/models.dart';

class WorkerRepository {
  const WorkerRepository({required WorkerApi workerApi})
      : _workerApi = workerApi;

  final WorkerApi _workerApi;

  Stream<List<Worker>> getWorkers() => _workerApi.getWorkers();

  Stream<Worker> getWorkerById(String id) => _workerApi.getWorkerById(id);

  Future<void> saveWorker(Worker worker) => _workerApi.saveWorker(worker);

  Future<void> deleteWorker(String id) => _workerApi.deleteWorker(id);
}