import 'package:OxyGuard/repositories/worker/api/worker_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/models.dart';

class FirestoreWorkerApi implements WorkerApi {
  FirestoreWorkerApi();

  final CollectionReference _workersRef = FirebaseFirestore.instance.collection("workers");

  @override
  Stream<List<Worker>> getWorkers() {
    return _workersRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Worker.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<List<Worker>> getWorkersByPersonnelId(String id) {
    return _workersRef.where('personnelId', isEqualTo: id).snapshots().map((snapshot) {
      if (snapshot.size != 0) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Worker.fromJson(data);
        }).toList();
      } else {
        throw WorkerNotFoundException();
      }
    });
  }

  @override
  Stream<Worker> getWorkerById(String id) {
    return _workersRef.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return Worker.fromJson(data);
      } else {
        throw WorkerNotFoundException();
      }
    });
  }

  @override
  Future<void> saveWorker(Worker worker) {
    return _workersRef.doc(worker.id).set(worker);
  }

  @override
  Future<void> deleteWorker(String id) {
    return _workersRef.doc(id).delete();
  }
}
