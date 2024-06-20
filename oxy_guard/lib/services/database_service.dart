import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oxy_guard/global_service.dart';
import 'package:oxy_guard/models/action_model.dart';
import 'package:oxy_guard/models/personnel/personnel_model.dart';

class DatabaseSevice{
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _actionsRef;
  late final CollectionReference _endedRef;
  late DocumentReference _personnelRef;
  late String actionId;
  DatabaseSevice(){
    _actionsRef = _firestore.collection("actions").withConverter<ActionModel>(fromFirestore: (snapshots, _) => ActionModel.fromJson(snapshots.data()!), toFirestore: (actionModel, _) => actionModel.toJson());
  }

  void assignTeam(PersonnelModel personnelModel) async {
    if(FirebaseAuth.instance.currentUser != null){
      _personnelRef = _firestore.collection("user_data").doc(FirebaseAuth.instance.currentUser!.uid).withConverter<PersonnelModel>(fromFirestore: (snapshots, _) => PersonnelModel.fromJson(snapshots.data()!), toFirestore: (personnelModel, _) => personnelModel.toJson());  
      _endedRef = _firestore.collection("user_data").doc(FirebaseAuth.instance.currentUser!.uid).collection("archive").withConverter<ActionModel>(fromFirestore: (snapshots, _) => ActionModel.fromJson(snapshots.data()!), toFirestore: (actionModel, _) => actionModel.toJson());
    }
    DocumentSnapshot personnel = await getPersonnel();
    if(personnel.exists){
      GlobalService.currentPersonnel = personnel.data() as PersonnelModel;
    }else{
      _personnelRef.set(personnelModel);
    }
  }

  Stream<QuerySnapshot> getActions() {
    return _actionsRef.snapshots();
  }

  Future<DocumentSnapshot> getPersonnel() {
    return _personnelRef.get();
  }

  Future<void> addAction(ActionModel actionModel) async {
   DocumentReference doc = await _actionsRef.add(actionModel);
   actionId = doc.id;
  }

  void joinAction(String newId){
    actionId = newId;
  }

  void updateAction(ActionModel actionModel){
    _actionsRef.doc(actionId).update(actionModel.toJson());
  }

  void updatePersonnel(PersonnelModel personnelModel){
    _personnelRef.update(personnelModel.toJson());
  }

  void endAction(ActionModel actionModel){
    actionModel.finishListening();
    _endedRef.add(actionModel);
    _actionsRef.doc(actionId).delete();
  }

  Stream<DocumentSnapshot<Object?>> getActionsRef(){
    return _actionsRef.doc(actionId).snapshots();
  }
}