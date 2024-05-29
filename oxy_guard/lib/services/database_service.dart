import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:oxy_guard/models/action_model.dart';
import 'package:geolocator/geolocator.dart';

const String TODO_COLLECTION_REF = "actions";

//TODO: to jest krótkowzroczne, jakiś system który nadzoruje przestawianie aktualnego id
class DatabaseSevice{
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _actionsRef;
  late String id;
  DatabaseSevice(){
    _actionsRef = _firestore.collection(TODO_COLLECTION_REF).withConverter<ActionModel>(fromFirestore: (snapshots, _) => ActionModel.fromJson(snapshots.data()!), toFirestore: (actionModel, _) => actionModel.toJson());
  }

  Stream<QuerySnapshot> getActions() {
    return _actionsRef.snapshots();
  }

  void addAction(ActionModel actionModel) async {
   DocumentReference doc = await _actionsRef.add(actionModel);
   id = doc.id;
  }

  void updateAction(ActionModel actionModel){
    _actionsRef.doc(id).update(actionModel.toJson());
  }
}