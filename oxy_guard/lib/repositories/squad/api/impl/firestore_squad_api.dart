import 'package:OxyGuard/repositories/squad/api/squad_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/models.dart';

class FirestoreSquadApi implements SquadApi {
  FirestoreSquadApi();

  final CollectionReference _squadsRef = FirebaseFirestore.instance.collection("squads");

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
  Stream<List<Squad>> getSquadsByUserId(String userId) {
    return _squadsRef.where('uid', isEqualTo: userId).snapshots().map((snapshot) {
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