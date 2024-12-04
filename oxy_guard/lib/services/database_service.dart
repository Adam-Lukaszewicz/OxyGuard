import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/models/extinguisher_model.dart';
import 'package:oxy_guard/models/action_model.dart';
import 'package:oxy_guard/models/ended_model.dart';
import 'package:oxy_guard/models/personnel/personnel_model.dart';
import 'package:oxy_guard/services/internet_serivce.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watch_it/watch_it.dart';

class DatabaseService extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  late CollectionReference _actionsRef;
  late CollectionReference _endedRef;
  late CollectionReference
      _atestsRef; //W przypadku innych atestów niż tych dla gaśnic to będzie kolekcja kolekcji, teraz atests=gaśnice
  late DocumentReference
      _personnelRef; //TODO: To prawdopodbnie powinno zostać przerobione na kolekjce pracownikow z polami name surname
  late String actionId;
  PersonnelModel currentPersonnel = PersonnelModel();
  late ActionModel currentAction;
  bool get closeToExpiring => _closeToExpiring;
  bool _closeToExpiring = false;
  set closeToExpiring(bool value) {
    _closeToExpiring = value;
    notifyListeners();
  }

  DatabaseService();
  void assignUserSpecificData() async {
    //TODO: Możliwe, że ten arguemtn jest KOMPLETNIE bezuzyteczny
    if (FirebaseAuth.instance.currentUser != null) {
      _actionsRef = _firestore
          .collection("user_data")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("actions")
          .withConverter<ActionModel>(
              fromFirestore: (snapshots, _) =>
                  ActionModel.fromJson(snapshots.data()!),
              toFirestore: (actionModel, _) => actionModel.toJson());
      _personnelRef = _firestore
          .collection("user_data")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .withConverter<PersonnelModel>(
              fromFirestore: (snapshots, _) =>
                  PersonnelModel.fromJson(snapshots.data()!),
              toFirestore: (personnelModel, _) => personnelModel.toJson());
      _endedRef = _firestore
          .collection("user_data")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("archive")
          .withConverter<EndedModel>(
              fromFirestore: (snapshots, _) =>
                  EndedModel.fromJson(snapshots.data()!),
              toFirestore: (endedModel, _) => endedModel.toJson());
      _atestsRef = _firestore
          .collection("user_data")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("atests")
          .withConverter<ExtinguisherModel>(
              fromFirestore: (snapshots, _) =>
                  ExtinguisherModel.fromJson(snapshots.data()!),
              toFirestore: (extinguisherModel, _) =>
                  extinguisherModel.toJson());
      _checkForExpiring();
      DocumentSnapshot personnel = await getPersonnel();
      if (personnel.exists) {
        currentPersonnel = personnel.data() as PersonnelModel;
      } else {
        _personnelRef.set(currentPersonnel);
      }
      currentPersonnel.listenToChanges();
    }
  }

  void writeToFile(String encoded, String filename) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    File localFile = File('${appDir.path}/$filename');
    if (!localFile.existsSync()) {
      await localFile.create();
    } else {
      localFile.deleteSync();
    }
    localFile.writeAsString(encoded);
  }

  Future<bool> checkOfflineData() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    File actionFile = File('${appDir.path}/currentAction');
    File endedFile = File('${appDir.path}/endedAction');
    return (actionFile.existsSync() || endedFile.existsSync());
  }

  void uploadOfflineData() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    File actionFile = File('${appDir.path}/currentAction');
    File endedFile = File('${appDir.path}/endedAction');
    if (!GetIt.I.get<InternetService>().offlineMode) {
      if (actionFile.existsSync()) {
        ActionModel action;
        Map<String, dynamic> decodedAction =
            jsonDecode(actionFile.readAsStringSync()) as Map<String, dynamic>;
        action = ActionModel.fromJson(decodedAction);
        _actionsRef.add(action);
      }
      if (endedFile.existsSync()) {
        EndedModel ended;
        Map<String, dynamic> decodedEnded =
            jsonDecode(endedFile.readAsStringSync()) as Map<String, dynamic>;
        ended = EndedModel.fromJson(decodedEnded);
        _endedRef.add(ended);
      }
    }
  }

  void deleteOfflineData() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    File actionFile = File('${appDir.path}/currentAction');
    File endedFile = File('${appDir.path}/endedAction');
    if (actionFile.existsSync()) {
      actionFile.deleteSync();
    }
    if (endedFile.existsSync()) {
      endedFile.deleteSync();
    }
  }

  ////////////////// ACTIONS CRUD //////////////////
  Stream<QuerySnapshot> getActions() {
    return _actionsRef.snapshots();
  }

  Stream<DocumentSnapshot<Object?>> getActionsRef() {
    return _actionsRef.doc(actionId).snapshots();
  }

  Future<ActionModel> readActionFromFile() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    File localActionFile = File('${appDir.path}/currentAction');
    ActionModel action;
    if (await localActionFile.exists()) {
      String fileRaw = localActionFile.readAsStringSync();
      Map<String, dynamic> decoded =
          jsonDecode(fileRaw) as Map<String, dynamic>;
      action = ActionModel.fromJson(decoded);
      return action;
    } else {
      return Future.error(Exception("No File Found"));
    }
  }

  Future<void> addAction(ActionModel actionModel) async {
    if (!GetIt.I.get<InternetService>().offlineMode) {
      DocumentReference doc = await _actionsRef.add(actionModel);
      actionId = doc.id;
    } else {
      writeToFile(jsonEncode(actionModel.toJson()), "currentAction");
    }
  }

  void joinAction(String newId) {
    if (!GetIt.I.get<InternetService>().offlineMode) {
      actionId = newId;
    }
  }

  void updateAction(ActionModel actionModel) {
    if (!GetIt.I.get<InternetService>().offlineMode) {
      _actionsRef.doc(actionId).update(actionModel.toJson());
    } else {
      writeToFile(jsonEncode(actionModel.toJson()), "currentAction");
    }
  }

  void endAction(ActionModel actionModel) {
    if (!GetIt.I.get<InternetService>().offlineMode) {
      actionModel.finishListening();
      _endedRef.add(actionModel.archivize());
      _actionsRef.doc(actionId).delete();
    } else {
      writeToFile(jsonEncode(actionModel.archivize().toJson()), "endedAction");
    }
  }

  ////////////////// ATESTS CRUD //////////////////
  Stream<QuerySnapshot> getAtests() {
    return _atestsRef.snapshots();
  }

  void addAtest(ExtinguisherModel newAtest) async {
    _atestsRef.add(newAtest);
    if (!closeToExpiring) {
      if (newAtest.expirationDate.difference(DateTime.now()).inDays <= 7) {
        closeToExpiring = true;
      }
    }
  }

  void updateAtest(ExtinguisherModel atest, String id) {
    _atestsRef.doc(id).update(atest.toJson());
    if (!closeToExpiring) {
      if (atest.expirationDate.difference(DateTime.now()).inDays <= 7) {
        closeToExpiring = true;
      }
    } else {
      _checkForExpiring();
    }
  }

  void removeAtest(ExtinguisherModel atest, String id) {
    _atestsRef.doc(id).delete();
    if (atest.expirationDate.difference(DateTime.now()).inDays <= 7) {
      _checkForExpiring();
    }
  }

  Future<void> _checkForExpiring() async {
    bool found = false;
    await getAtests().first.then((snapshot) {
      for (var doc in snapshot.docs) {
        ExtinguisherModel model = doc.data() as ExtinguisherModel;
        if (model.expirationDate.difference(DateTime.now()).inDays <= 7) {
          found = true;
          break;
        }
      }
    });
    closeToExpiring = found;
  }

  Future<String?> getAtestIdBySerial(String serial) async {
    String? id;
    await _atestsRef.get().then((QuerySnapshot docs) {
      var it = docs.docs.iterator;
      while (it.moveNext()) {
        ExtinguisherModel model = it.current.data() as ExtinguisherModel;
        if (model.serial == serial) {
          id = it.current.id;
        }
      }
    });
    return id;
  }

  ////////////////// ARCHIVE CRUD //////////////////
  Stream<QuerySnapshot> getArchive() {
    return _endedRef.snapshots();
  }

  ////////////////// PERSONNEL CRUD //////////////////
  Future<DocumentSnapshot> getPersonnel() {
    return _personnelRef.get();
  }

  Stream<DocumentSnapshot<Object?>> getPersonnelRef() {
    return _personnelRef.snapshots();
  }

  void updatePersonnel(PersonnelModel personnelModel) {
    _personnelRef.update(personnelModel.toJson());
  }
}
