import 'package:OxyGuard/models/squad/squad.dart';
import 'package:OxyGuard/squads/api/squads_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSquadsApi implements SquadsApi {
  FirestoreSquadsApi();
  final CollectionReference _squadsRef =
      FirebaseFirestore.instance.collection("squads");

  @override
  Stream<List<Squad>> getSquads() {
    return _squadsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Squad.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<List<Squad>> getSquadsByActionId(String actionId) {
    return _squadsRef
        .where('actionId', isEqualTo: actionId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Squad.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<void> saveSquad(Squad squad) {
    return _squadsRef.doc(squad.id).set(squad);
  }

  @override
  Future<void> deleteSquad(String id) {
    return _squadsRef.doc(id).delete();
  }
}
