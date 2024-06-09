import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oxy_guard/action/tabs/working/squad_page.dart';
import 'package:oxy_guard/action/tabs/working/squad_tab.dart';

import '../global_service.dart';

class SquadModel extends ChangeNotifier {
  Map<String, double> oxygenValues;
  Map<String, DateTime> newestCheckTimes;
  Map<String, double> usageRates;
  Map<String, Object> waitingSquads;
  Map<String, SquadPage> workingSquads;
  Map<String, Object> finishedSquads;
  Map<String, SquadTab> tabs;
  SquadModel(
      {Map<String, double>? oxygenValues,
      Map<String, DateTime>? newestCheckTimes,
      Map<String, double>? usageRates,
      Map<String, Object>? waitingSquads,
      Map<String, SquadPage>? workingSquads,
      Map<String, Object>? finishedSquads,
      Map<String, SquadTab>? tabs,
      Position? actionLocation})
      : oxygenValues = oxygenValues ?? <String, double>{},
        newestCheckTimes = newestCheckTimes ?? <String, DateTime>{},
        usageRates = usageRates ?? <String, double>{},
        waitingSquads = waitingSquads ?? <String, Object>{},
        workingSquads = workingSquads ?? <String, SquadPage>{},
        finishedSquads = finishedSquads ?? <String, Object>{},
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

  void setWorkTimestamp(int index, DateTime newTime) {
    newestCheckTimes[index.toString()] = newTime;
    notifyListeners();
    GlobalService.currentAction.update();
  }

  void update(double newOxygen, double usageRate, DateTime newTime, int index) {
    oxygenValues[index.toString()] = newOxygen;
    usageRates[index.toString()] = usageRate;
    newestCheckTimes[index.toString()] = newTime;
    notifyListeners();
    GlobalService.currentAction.update();
  }

  void changeStarting(double newOxygen, int index) {
    oxygenValues[index.toString()] = newOxygen;
    notifyListeners();
    GlobalService.currentAction.update();
  }

  void startSquadWork(int entryPressure, int exitPressure, int interval) {
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
          text: "R${workingSquads.length + 1}")
    });
    tabs.addAll({
      (oxygenValues.length - 1).toString(): SquadTab(
          text: "R${workingSquads.length}", index: oxygenValues.length - 1)
    });
    notifyListeners();
    GlobalService.currentAction.update();
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
          finishedSquads: Map.castFrom(jsonDecode(json["FinishedSquads"]!)),
          tabs: Map.castFrom(jsonDecode(json["Tabs"]!)).map((key, value) =>
              MapEntry(key.toString(), SquadTab.fromJson(value))),
        );

  SquadModel copyWith({
    Map<String, double>? oxygenValues,
    Map<String, double>? usageRates,
    Map<String, DateTime>? newestCheckTimes,
    Map<String, Object>? waitingSquads,
    Map<String, SquadPage>? workingSquads,
    Map<String, Object>? finishedSquads,
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
