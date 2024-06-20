import 'dart:convert';

import 'package:oxy_guard/models/personnel/worker.dart';

class Shift{
  int startTime; //8:30 is stored as 830, 10:00 as 1000 etc.
  int endTime;
  List<Worker> team;

  Shift({required this.startTime, required this.endTime, List<Worker>? team}):team = team ?? [];
  Shift.fromJson(Map<String, dynamic> json):this(
    startTime: json["StartTime"] as int,
    endTime: json["EndTime"] as int,
    team: (jsonDecode(json["Team"]!) as List).map((worker) => Worker.fromJson(worker)).toList()
  );

  Map<String, dynamic> toJson(){
    return{
      "StartTime": jsonEncode(startTime),
      "EndTime": jsonEncode(endTime),
      "Team": jsonEncode(team)
    };
  }
}