import 'dart:convert';

import 'package:oxy_guard/global_service.dart';
import 'package:oxy_guard/models/personnel/shift.dart';
import 'package:oxy_guard/models/personnel/worker.dart';

class PersonnelModel{
  List<Worker> team;
  List<Shift> shifts;
  PersonnelModel({List<Worker>? team, List<Shift>? shifts}): team = team ?? [], shifts = shifts ?? [];
  PersonnelModel.fromJson(Map<String, dynamic> json):this(
    team: (jsonDecode(json["Team"]) as List).map((worker) => Worker.fromJson(worker)).toList(),
    shifts: (jsonDecode(json["Shifts"]) as List).map((shift) => Shift.fromJson(shift)).toList()
  );

  Map<String, dynamic> toJson(){
    return{
      "Team": jsonEncode(team),
      "Shifts": jsonEncode(shifts),
    };
  }

  void addWorker(Worker newWorker){
    team.insert(0, newWorker);//wstawia na początek listy - ładnie to wygląda w zakładce kadry :D
    GlobalService.databaseSevice.updatePersonnel(this);
  }
  void subWorker(Worker Worker){
    team.remove(Worker);
    GlobalService.databaseSevice.updatePersonnel(this);
  }
}