import 'dart:async';
import 'dart:convert';

import 'package:OxyGuard/models/personnel/shift.dart';
import 'package:OxyGuard/models/personnel/worker.dart';
import 'package:OxyGuard/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class PersonnelModel extends ChangeNotifier{
  List<Worker> team;
  PersonnelModel({List<Worker>? team, List<Shift>? shifts}): team = team ?? [];
  PersonnelModel.fromJson(Map<String, dynamic> json):this(
    team: (jsonDecode(json["Team"]) as List).map((worker) => Worker.fromJson(worker)).toList(),
  );

  late StreamSubscription<DocumentSnapshot<Object?>> _listener;

  Map<String, dynamic> toJson(){
    return{
      "Team": jsonEncode(team),
    };
  }

  void listenToChanges() {
    _listener = GetIt.I.get<DatabaseService>().getPersonnelRef().listen((event) {
      PersonnelModel newData = event.data() as PersonnelModel;
      team = newData.team;
      notifyListeners();
    });
  }

  void finishListening(){
    _listener.cancel();
  }

  void addWorker(Worker newWorker){
    team.insert(0, newWorker);
    notifyListeners();
    GetIt.I.get<DatabaseService>().updatePersonnel(this);
  }
  void subWorker(Worker worker){
    team.remove(worker);
    notifyListeners();
    GetIt.I.get<DatabaseService>().updatePersonnel(this);
  }
}