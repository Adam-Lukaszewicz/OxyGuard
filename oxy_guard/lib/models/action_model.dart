import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oxy_guard/action/tabs/working/squad_page.dart';
import 'package:oxy_guard/action/tabs/working/squad_tab.dart';
import 'package:oxy_guard/main.dart';
import 'package:oxy_guard/services/database_service.dart';

class ActionModel extends ChangeNotifier {
  List<double> oxygenValues;
  List<DateTime> newestCheckTimes;
  List<double> usageRates;
  List<Object> waitingSquads;
  List<SquadPage> workingSquads;
  List<Object> finishedSquads;
  List<TabSquad> tabs;
  late Position actionLocation;
  ActionModel({List<double>? oxygenValues, List<DateTime>? newestCheckTimes, List<double>? usageRates, List<Object>? waitingSquads, List<SquadPage>? workingSquads, List<Object>? finishedSquads, List<TabSquad>? tabs, Position? actionLocation}):
  oxygenValues = oxygenValues ?? <double>[],
  newestCheckTimes = newestCheckTimes ?? <DateTime>[],
  usageRates = usageRates ?? <double>[],
  waitingSquads = waitingSquads ?? [],
  workingSquads = workingSquads ?? <SquadPage>[],
  finishedSquads = finishedSquads ?? [],
  tabs = tabs ?? <TabSquad>[],
  actionLocation = actionLocation ?? Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0) {
  }

  void setActionLocation() async {
    actionLocation = await Geolocator.getCurrentPosition();
    NavigationService.databaseSevice.updateAction(this);
  }

  double getOxygenRemaining(int index){
    return oxygenValues[index] - (usageRates[index] * DateTime.now().difference(newestCheckTimes[index]).inSeconds);
  }

  int getTimeRemaining(int index){
    int remainingTime = (getOxygenRemaining(index) - 60.0) ~/ usageRates[index];
    if(remainingTime > 0){
      return remainingTime;
    }else{
      return 0;
    }
  }

  void update(double newOxygen, double usageRate, DateTime newTime, int index) {
    oxygenValues[index] = newOxygen;
    usageRates[index] = usageRate;
    newestCheckTimes[index] = newTime;
    notifyListeners();
    NavigationService.databaseSevice.updateAction(this);
  }

  void changeStarting(double newOxygen, int index){
    oxygenValues[index] = newOxygen;
    notifyListeners();
    NavigationService.databaseSevice.updateAction(this);
  }

  void advanceTime(int index) {
    notifyListeners();
  }

  void startSquadWork(int entryPressure, int exitPressure, int interval) {
    oxygenValues.add(entryPressure.toDouble());
    usageRates.add(10.0/60.0);
    newestCheckTimes.add(DateTime.now());
    workingSquads.add(SquadPage(interval: interval, index: oxygenValues.length-1, entryPressure: entryPressure.toDouble(), exitPressure: exitPressure, text: "R${workingSquads.length+1}"));
    tabs.add(TabSquad(text: "R${workingSquads.length}", index: oxygenValues.length-1));
    notifyListeners();
    NavigationService.databaseSevice.updateAction(this);
  }
  //TODO: Funkcja, która rusza oxygen value z czasem, jeśli tego potrzebujemy

  Map<String, dynamic> toJson(){
    return{
      "OxygenValues": jsonEncode(oxygenValues),
      "NewestCheckTimes": jsonEncode(newestCheckTimes, toEncodable: (nonEncodable) => nonEncodable is DateTime ? nonEncodable.toIso8601String() : throw UnsupportedError('Cannot convert to JSON: $nonEncodable'),),
      "UsageRates": jsonEncode(usageRates),
      "WaitingSquads": jsonEncode(waitingSquads),
      "WorkingSquads": jsonEncode(workingSquads),
      "FinishedSquads": jsonEncode(finishedSquads),
      "Tabs": jsonEncode(tabs),
      "Location": jsonEncode(actionLocation)
    };
  }
  ActionModel.fromJson(Map<String, dynamic> json):this(
    oxygenValues: List<double>.from(jsonDecode(json["OxygenValues"]!)),
    newestCheckTimes: (jsonDecode(json["NewestCheckTimes"]!) as List).map((date) => DateTime.parse(date)).toList(),
    usageRates: List<double>.from(jsonDecode(json["UsageRates"]!)),
    waitingSquads: List<Object>.from(jsonDecode(json["WaitingSquads"]!)),
    workingSquads: (jsonDecode(json["WorkingSquads"]!) as List).map((squad) => SquadPage.fromJson(squad)).toList(),
    finishedSquads: List<Object>.from(jsonDecode(json["FinishedSquads"]!)),
    tabs: (jsonDecode(json["Tabs"]!) as List).map((tab) => TabSquad.fromJson(tab)).toList(),
    actionLocation: Position.fromMap(jsonDecode(json["Location"])),
  );

  ActionModel copyWith({
    List<double>? oxygenValues,
    List<double>? usageRates,
    List<Object>? waitingSquads,
    List<SquadPage>? workingSquads,
    List<Object>? finishedSquads,
    List<TabSquad>? tabs,
    Position? actionLocation,
    }){
    return ActionModel(
      oxygenValues: oxygenValues ?? this.oxygenValues,
      usageRates: usageRates ?? this.usageRates,
      waitingSquads: waitingSquads ?? this.waitingSquads,
      workingSquads: workingSquads ?? this.workingSquads,
      finishedSquads: finishedSquads ?? this.finishedSquads,
      tabs: tabs ?? this.tabs,
      actionLocation: actionLocation ?? this.actionLocation
    );
  }
}
