import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oxy_guard/models/squad_model.dart';

import '../global_service.dart';

class ActionModel{
  int internalIndex;
  Map<String, SquadModel> squads;
  Position actionLocation;
  ActionModel({
    int? internalIndex,
    Map<String, SquadModel>? squads,
    Position? actionLocation
  }):
   internalIndex = internalIndex ?? 0,
   squads = squads ?? <String, SquadModel>{},
   actionLocation = actionLocation ??
            Position(
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
                );
  
  late StreamSubscription<DocumentSnapshot<Object?>> _listener;

  void addSquad(SquadModel newSquad){
    squads.addAll({internalIndex.toString():newSquad});
    internalIndex++;
  }

  void update(){
    GlobalService.databaseSevice.updateAction(this);
  }

  Map<String, dynamic> toJson(){
    return{
      "InternalIndex": jsonEncode(internalIndex),
      "Squads": jsonEncode(squads),
      "Location": jsonEncode(actionLocation)
    };
  }

  void listenToChanges() {
    _listener = GlobalService.databaseSevice.getActionsRef().listen((event) {
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

  Future<void> setActionLocation() async {
    actionLocation = await Geolocator.getCurrentPosition();
    GlobalService.databaseSevice.addAction(this).then((value) => listenToChanges());
  }

  ActionModel.fromJson(Map<String, dynamic> json) : this(
    internalIndex: jsonDecode(json["InternalIndex"]),
    squads: Map.castFrom(jsonDecode(json["Squads"])).map((key, value) => MapEntry(key.toString(), SquadModel.fromJson(value))),
    actionLocation: Position.fromMap(jsonDecode(json["Location"])),
  );

  void copyFrom(ActionModel other){
    squads = other.squads;
    actionLocation = other.actionLocation;
  }
}