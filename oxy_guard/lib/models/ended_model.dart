import 'dart:convert';

import 'package:geolocator/geolocator.dart';

class EndedModel{
  Position actionLocation;
  double averageUse;
  DateTime endTime;
  EndedModel({required this.actionLocation, required this.averageUse, required this.endTime});
  EndedModel.fromJson(Map<String, dynamic> json):this(
    actionLocation: Position.fromMap(jsonDecode(json["Location"])),
    averageUse: jsonDecode(json["AverageUse"]) as double,
    endTime: DateTime.parse(json["EndTime"]),
  );
  Map<String, dynamic> toJson(){
    return{
      "Location": jsonEncode(actionLocation),
      "AverageUse": jsonEncode(averageUse),
      "EndTime": endTime.toUtc().toIso8601String(),
    };
  }
}