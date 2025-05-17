import 'package:OxyGuard/repositories/actions/api/actions_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/models.dart';

class FirestoreActionsApi implements ActionsApi {
  FirestoreActionsApi();

  final CollectionReference _actionsRef = FirebaseFirestore.instance.collection("actions");

  @override
  Stream<List<Action>> getActions() {
    return _actionsRef.snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Action.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<List<Action>> getActionsByUserId(String userId) {
    return _actionsRef.where('uid', isEqualTo: userId).snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Action.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<void> saveAction(Action action) {
    return _actionsRef.doc(action.id).set(action);
  }

  @override
  Future<void> deleteAction(String id) {
    return _actionsRef.doc(id).delete();
  }
}