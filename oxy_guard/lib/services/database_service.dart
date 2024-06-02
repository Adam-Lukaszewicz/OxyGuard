import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oxy_guard/models/action_model.dart';

class DatabaseSevice{
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _actionsRef;
  late String id;
  DatabaseSevice(){
    _actionsRef = _firestore.collection("actions").withConverter<ActionModel>(fromFirestore: (snapshots, _) => ActionModel.fromJson(snapshots.data()!), toFirestore: (actionModel, _) => actionModel.toJson());
  }

  Stream<QuerySnapshot> getActions() {
    return _actionsRef.snapshots();
  }

  void addAction(ActionModel actionModel) async {
   DocumentReference doc = await _actionsRef.add(actionModel);
   id = doc.id;
  }

  void joinAction(String newId){
    id = newId;
  }

  void updateAction(ActionModel actionModel){
    _actionsRef.doc(id).update(actionModel.toJson());
  }

  Stream<DocumentSnapshot<Object?>> getActionsRef(){
    return _actionsRef.doc(id).snapshots();
  }
}