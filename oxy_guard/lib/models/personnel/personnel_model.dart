import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/services/global_service.dart';
import 'package:oxy_guard/models/personnel/shift.dart';
import 'package:oxy_guard/models/personnel/worker.dart';

class PersonnelModel extends ChangeNotifier{
  List<Worker> team;
  List<Shift> shifts;
  PersonnelModel({List<Worker>? team, List<Shift>? shifts}): team = team ?? [], shifts = shifts ?? [];
  PersonnelModel.fromJson(Map<String, dynamic> json):this(
    team: (jsonDecode(json["Team"]) as List).map((worker) => Worker.fromJson(worker)).toList(),
    shifts: (jsonDecode(json["Shifts"]) as List).map((shift) => Shift.fromJson(shift)).toList()
  );

  late StreamSubscription<DocumentSnapshot<Object?>> _listener;

  Map<String, dynamic> toJson(){
    return{
      "Team": jsonEncode(team),
      "Shifts": jsonEncode(shifts),
    };
  }

  void listenToChanges() {
    _listener = GlobalService.databaseSevice.getPersonnelRef().listen((event) {
      PersonnelModel newData = event.data() as PersonnelModel;
      team = newData.team;
      shifts = newData.shifts;
      notifyListeners();
    });
  }

  void finishListening(){
    _listener.cancel();
  }

  void addWorker(Worker newWorker){
    team.insert(0, newWorker);
    notifyListeners();
    GlobalService.databaseSevice.updatePersonnel(this);
  }
  void subWorker(Worker worker){
    team.remove(worker);
    notifyListeners();
    GlobalService.databaseSevice.updatePersonnel(this);
  }
}