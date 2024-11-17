import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oxy_guard/action/tabs/finished/finished_squad.dart';
import 'package:oxy_guard/context_windows.dart';
import 'package:oxy_guard/models/ended_model.dart';
import 'package:oxy_guard/models/squad_model.dart';
import 'package:oxy_guard/services/database_service.dart';
import 'package:watch_it/watch_it.dart';

import '../services/global_service.dart';

class ActionModel{
  int internalIndex;
  Map<String, SquadModel> squads;
  Position actionLocation;
  String actionName;
  ActionModel({
    int? internalIndex,
    Map<String, SquadModel>? squads,
    Position? actionLocation,
    String? actionName
  }):
    internalIndex = internalIndex ?? 0,
    squads = squads ?? <String, SquadModel>{},
    actionLocation = actionLocation ?? Position(
                longitude: 0,
                latitude: 0,
                timestamp: DateTime.now(),
                accuracy: 0,
                altitude: 0,
                altitudeAccuracy: 0,
                heading: 0,
                headingAccuracy: 0,
                speed: 0,
                speedAccuracy: 0
                ),
    actionName = actionName ?? "";
  
  late StreamSubscription<DocumentSnapshot<Object?>> _listener;

  void addSquad(SquadModel newSquad){
    squads.addAll({internalIndex.toString():newSquad});
    internalIndex++;
  }

  void update(){
    GetIt.I.get<DatabaseService>().updateAction(this);
  }

  Map<String, dynamic> toJson(){
    return{
      "InternalIndex": jsonEncode(internalIndex),
      "Squads": jsonEncode(squads),
      "Location": jsonEncode(actionLocation),
      "Name": actionName
    };
  }

  EndedModel archivize(){
    double averageUse = 0;
    int divider = 0;
    Map<String, List<FinishedSquad>> endedSqauds = <String, List<FinishedSquad>>{};
    squads.forEach((sqkey, squad){
      endedSqauds.addAll({sqkey : squad.finishedSquads.values.toList()});
    });
    averageUse /= divider;
    return EndedModel(actionLocation: actionLocation, squads: endedSqauds, endTime: DateTime.now());
  }

  void listenToChanges() {
    _listener = GetIt.I.get<DatabaseService>().getActionsRef().listen((event) {
      ActionModel newData = event.data() as ActionModel;
      squads.forEach((key, value) { 
        newData.squads.forEach((nkey, nvalue) {
          if(key == nkey){
            value.copyFrom(nvalue);
          }
         });
      });
      newData.squads.removeWhere((nkey, value) => squads.keys.any((key) => key == nkey));
      squads.addAll(newData.squads);
      internalIndex = newData.internalIndex;
      actionLocation = newData.actionLocation;
    });
  }


  void finishListening(){
    _listener.cancel();
  }

  Future<void> setActionLocation(BuildContext context) async {
    if(GlobalService.permission == LocationPermission.always || GlobalService.permission == LocationPermission.whileInUse){
      actionLocation = await Geolocator.getCurrentPosition();
    }else{
      String? input = await textInputDialog(context, "Podaj nazwę akcji", "Nazwa akcji", "Akcja bez GPS musi być nazwana");
      if(input != null) actionName = input;
    }
    GetIt.I.get<DatabaseService>().addAction(this).then((value) => listenToChanges());
  }

  ActionModel.fromJson(Map<String, dynamic> json) : this(
    internalIndex: jsonDecode(json["InternalIndex"]),
    squads: Map.castFrom(jsonDecode(json["Squads"])).map((key, value) => MapEntry(key.toString(), SquadModel.fromJson(value))),
    actionLocation: Position.fromMap(jsonDecode(json["Location"])),
    actionName: json["Name"] != null ? json["Name"]! as String : "",
  );

  void copyFrom(ActionModel other){
    squads = other.squads;
    actionLocation = other.actionLocation;
  }
}