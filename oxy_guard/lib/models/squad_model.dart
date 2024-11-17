import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oxy_guard/action/tabs/finished/finished_squad.dart';
import 'package:oxy_guard/action/tabs/working/squad_page.dart';
import 'package:oxy_guard/action/tabs/working/squad_tab.dart';
import 'package:oxy_guard/models/personnel/worker.dart';
import 'package:oxy_guard/services/database_service.dart';
import 'package:watch_it/watch_it.dart';

class SquadModel extends ChangeNotifier {
  Map<String, double> oxygenValues;
  Map<String, DateTime> newestCheckTimes;
  Map<String, double> usageRates;
  Map<String, Object> waitingSquads;
  Map<String, SquadPage> workingSquads;
  Map<String, FinishedSquad> finishedSquads;
  Map<String, SquadTab> tabs;
  SquadModel(
      {Map<String, double>? oxygenValues,
      Map<String, DateTime>? newestCheckTimes,
      Map<String, double>? usageRates,
      Map<String, Object>? waitingSquads,
      Map<String, SquadPage>? workingSquads,
      Map<String, FinishedSquad>? finishedSquads,
      Map<String, SquadTab>? tabs,
      Position? actionLocation})
      : oxygenValues = oxygenValues ?? <String, double>{},
        newestCheckTimes = newestCheckTimes ?? <String, DateTime>{},
        usageRates = usageRates ?? <String, double>{},
        waitingSquads = waitingSquads ?? <String, Object>{},
        workingSquads = workingSquads ?? <String, SquadPage>{},
        finishedSquads = finishedSquads ?? <String, FinishedSquad>{},
        tabs = tabs ?? <String, SquadTab>{};


  double getOxygenRemaining(int index) {
    if (workingSquads[index.toString()]!.working) {
      return oxygenValues[index.toString()]! -
          (usageRates[index.toString()]! *
              DateTime.now()
                  .difference(newestCheckTimes[index.toString()]!)
                  .inSeconds);
    } else {
      return oxygenValues[index.toString()]!;
    }
  }

  int getTimeRemaining(int index) {
    int remainingTime =
        (getOxygenRemaining(index) - 60.0) ~/ usageRates[index.toString()]!;
    if (remainingTime > 0) {
      return remainingTime;
    } else {
      return 0;
    }
  }

  int getTimeRemainingInCrisis(int index){
        int remainingTime =
        (getOxygenRemaining(index)) ~/ (10);
    if (remainingTime > 0) {
      return remainingTime;
    } else {
      return 0;
    }
  }

  void update(){
    GetIt.I.get<DatabaseService>().currentAction.update();
  }

  void setWorkTimestamp(int index, DateTime newTime) {
    newestCheckTimes[index.toString()] = newTime;
    notifyListeners();
    GetIt.I.get<DatabaseService>().currentAction.update();
  }

  void addCheck(double newOxygen, double usageRate, DateTime newTime, int index) {
    oxygenValues[index.toString()] = newOxygen;
    usageRates[index.toString()] = usageRate;
    newestCheckTimes[index.toString()] = newTime;
    notifyListeners();
    GetIt.I.get<DatabaseService>().currentAction.update();
  }

  void changeStarting(double newOxygen, int index) {
    oxygenValues[index.toString()] = newOxygen;
    notifyListeners();
    GetIt.I.get<DatabaseService>().currentAction.update();
  }

  void startSquadWork(int entryPressure, int exitPressure, int interval, String localization, Worker? firstPerson, Worker? secondPerson, Worker? thirdPerson, bool quick) {
    oxygenValues
        .addAll({(oxygenValues.length).toString(): entryPressure.toDouble()});
    usageRates.addAll({(oxygenValues.length - 1).toString(): 10.0 / 60.0});
    newestCheckTimes
        .addAll({(oxygenValues.length - 1).toString(): DateTime.now()});
    workingSquads.addAll({
      (oxygenValues.length - 1).toString(): SquadPage(
          interval: interval,
          index: oxygenValues.length - 1,
          entryPressure: entryPressure.toDouble(),
          exitPressure: exitPressure,
          text: "R${workingSquads.length + 1}",
          localization: localization,
          firstPerson: firstPerson,
          secondPerson: secondPerson,
          thirdPerson: thirdPerson,
          )
    });
    tabs.addAll({
      (oxygenValues.length - 1).toString(): SquadTab(
          text: "R${workingSquads.length}", index: oxygenValues.length - 1)
    });
    if(!quick){
    notifyListeners();
    GetIt.I.get<DatabaseService>().currentAction.update();
    }
  }

  void endSquadWork(int index){
    SquadPage? ending = workingSquads[index.toString()];
    if(ending == null) return;
    double averageUse = ending.checks.first - getOxygenRemaining(index)/(DateTime.now().difference(ending.checkTimes.first)).inSeconds;
    finishedSquads.addAll({index.toString():FinishedSquad(name: ending.text, index: index, averageUse: averageUse, workers: [ending.firstPerson, ending.secondPerson, ending.thirdPerson])});
    workingSquads.remove(index.toString());
    tabs.remove(index.toString());
    notifyListeners();
    GetIt.I.get<DatabaseService>().currentAction.update();
  }

  Map<String, dynamic> toJson() {
    return {
      "OxygenValues": jsonEncode(oxygenValues),
      "NewestCheckTimes": jsonEncode(
        newestCheckTimes,
        toEncodable: (nonEncodable) {
          if (nonEncodable is DateTime) {
            return nonEncodable.toUtc().toIso8601String();
          } else {
            throw ("Unsupported conversion to JSON");
          }
        },
      ),
      "UsageRates": jsonEncode(usageRates),
      "WaitingSquads": jsonEncode(waitingSquads),
      "WorkingSquads": jsonEncode(workingSquads),
      "FinishedSquads": jsonEncode(finishedSquads),
      "Tabs": jsonEncode(tabs),
    };
  }

  SquadModel.fromJson(Map<String, dynamic> json)
      : this(
          oxygenValues: Map.castFrom(jsonDecode(json["OxygenValues"]!)).map((key, value) => MapEntry(key.toString(), value as double)),
          newestCheckTimes: Map.castFrom(jsonDecode(json["NewestCheckTimes"]!))
              .map((key, value) =>
                  MapEntry(key.toString(), DateTime.parse(value).toLocal())),
          usageRates: Map.castFrom(jsonDecode(json["UsageRates"]!)).map((key, value) => MapEntry(key.toString(), value as double)),
          waitingSquads: Map.castFrom(jsonDecode(json["WaitingSquads"]!)),
          workingSquads: Map.castFrom(jsonDecode(json["WorkingSquads"]!)).map(
              (key, value) =>
                  MapEntry(key.toString(), SquadPage.fromJson(value))),
          finishedSquads: Map.castFrom(jsonDecode(json["FinishedSquads"]!)).map((key, value) => MapEntry(key.toString(), FinishedSquad.fromJson(value))),
          tabs: Map.castFrom(jsonDecode(json["Tabs"]!)).map((key, value) =>
              MapEntry(key.toString(), SquadTab.fromJson(value))),
        );

  SquadModel copyWith({
    Map<String, double>? oxygenValues,
    Map<String, double>? usageRates,
    Map<String, DateTime>? newestCheckTimes,
    Map<String, Object>? waitingSquads,
    Map<String, SquadPage>? workingSquads,
    Map<String, FinishedSquad>? finishedSquads,
    Map<String, SquadTab>? tabs,
    Position? actionLocation,
  }) {
    return SquadModel(
        oxygenValues: oxygenValues ?? this.oxygenValues,
        usageRates: usageRates ?? this.usageRates,
        newestCheckTimes: newestCheckTimes ?? this.newestCheckTimes,
        waitingSquads: waitingSquads ?? this.waitingSquads,
        workingSquads: workingSquads ?? this.workingSquads,
        finishedSquads: finishedSquads ?? this.finishedSquads,
        tabs: tabs ?? this.tabs,
    );
  }

    void copyFrom(SquadModel other) {
        oxygenValues = other.oxygenValues;
        usageRates = other.usageRates;
        newestCheckTimes = other.newestCheckTimes;
        waitingSquads = other.waitingSquads;
        workingSquads = other.workingSquads;
        finishedSquads = other.finishedSquads;
        tabs = other.tabs;
        notifyListeners();
  }
}
