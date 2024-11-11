import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:oxy_guard/action/tabs/finished/finished_squad.dart';

class EndedModel {
  Position actionLocation;
  Map<String, List<FinishedSquad>> squads;
  DateTime endTime;
  EndedModel(
      {required this.actionLocation,
      required this.squads,
      required this.endTime});
  EndedModel.fromJson(Map<String, dynamic> json)
      : this(
          actionLocation: Position.fromMap(jsonDecode(json["Location"])),
          squads: Map.castFrom(jsonDecode(json["Squads"]!)).map((key, value) {
            value = value as List<dynamic>;
            List<FinishedSquad> fSquads = value.map((f){
              return FinishedSquad.fromJson(f);
            }).toList();
            return MapEntry(key.toString(), fSquads);
          }),
          endTime: DateTime.parse(json["EndTime"]),
        );
  Map<String, dynamic> toJson() {
    return {
      "Location": jsonEncode(actionLocation),
      "Squads": jsonEncode(squads),
      "EndTime": endTime.toUtc().toIso8601String(),
    };
  }
}
