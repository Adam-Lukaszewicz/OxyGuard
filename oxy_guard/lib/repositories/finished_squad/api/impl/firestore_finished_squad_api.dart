import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/repositories/finished_squad/api/finished_squad_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreFinishedSquadApi implements FinishedSquadApi {
  FirestoreFinishedSquadApi();

  final CollectionReference _finishedSquadRef = FirebaseFirestore.instance.collection("finishedSquads");

  @override
  Stream<List<FinishedSquad>> getFinishedSquads() {
    return _finishedSquadRef.snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FinishedSquad.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<List<FinishedSquad>> getFinishedSquadsByArchivedActionId(String archivedActionId) {
    return _finishedSquadRef.where('archivedActionId', isEqualTo: archivedActionId).snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FinishedSquad.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<FinishedSquad> getFinishedSquadById(String id) {
    return _finishedSquadRef.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return FinishedSquad.fromJson(data);
      } else {
        throw FinishedSquadNotFoundException();
      }
    });
  }

  @override
  Stream<List<FinishedSquad>> getFinishedSquadsByUserId(String userId) {
    return _finishedSquadRef.where('userId', isEqualTo: userId).snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FinishedSquad.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<void> saveFinishedSquad(FinishedSquad finishedSquad) {
    return _finishedSquadRef.doc(finishedSquad.id).set(finishedSquad);
  }

  @override
  Future<void> deleteFinishedSquad(String id) {
    return _finishedSquadRef.doc(id).delete();
  }
}