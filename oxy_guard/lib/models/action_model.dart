import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oxy_guard/action/tabs/working/squad_page.dart';
import 'package:oxy_guard/action/tabs/working/squad_tab.dart';
import 'package:oxy_guard/main.dart';
import 'package:oxy_guard/services/database_service.dart';

class ActionModel extends ChangeNotifier {
  Map<String, double> oxygenValues;
  Map<String, DateTime> newestCheckTimes;
  Map<String, double> usageRates;
  Map<String, Object> waitingSquads;
  Map<String, SquadPage> workingSquads;
  Map<String, Object> finishedSquads;
  Map<String, TabSquad> tabs;
  late Position actionLocation;
  ActionModel(
      {Map<String, double>? oxygenValues,
      Map<String, DateTime>? newestCheckTimes,
      Map<String, double>? usageRates,
      Map<String, Object>? waitingSquads,
      Map<String, SquadPage>? workingSquads,
      Map<String, Object>? finishedSquads,
      Map<String, TabSquad>? tabs,
      Position? actionLocation})
      : oxygenValues = oxygenValues ?? <String, double>{},
        newestCheckTimes = newestCheckTimes ?? <String, DateTime>{},
        usageRates = usageRates ?? <String, double>{},
        waitingSquads = waitingSquads ?? <String, Object>{},
        workingSquads = workingSquads ?? <String, SquadPage>{},
        finishedSquads = finishedSquads ?? <String, Object>{},
        tabs = tabs ?? <String, TabSquad>{},
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
                speedAccuracy: 0){
                  
                }

  void listenToChanges() {
    final listener = NavigationService.databaseSevice
        .getActionsRef().listen((event) {
      final source = (event.metadata.hasPendingWrites);
      if (true) {
        ActionModel newData = event.data() as ActionModel;
        print(newData.toJson());
        copyFrom(newData);
        notifyListeners();
      } else {
        print("current data: ${event.data()}");
        print("local change");
      }
    });
  }

  void setActionLocation() async {
    actionLocation = await Geolocator.getCurrentPosition();
    NavigationService.databaseSevice.updateAction(this);
    listenToChanges();
  }

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
    NavigationService.databaseSevice.updateAction(this);
  }

  void update(double newOxygen, double usageRate, DateTime newTime, int index) {
    oxygenValues[index.toString()] = newOxygen;
    usageRates[index.toString()] = usageRate;
    newestCheckTimes[index.toString()] = newTime;
    notifyListeners();
    NavigationService.databaseSevice.updateAction(this);
  }

  void changeStarting(double newOxygen, int index) {
    oxygenValues[index.toString()] = newOxygen;
    notifyListeners();
    NavigationService.databaseSevice.updateAction(this);
  }

  void advanceTime(int index) {
    notifyListeners();
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
      (oxygenValues.length - 1).toString(): TabSquad(
          text: "R${workingSquads.length}", index: oxygenValues.length - 1)
    });
    notifyListeners();
    NavigationService.databaseSevice.updateAction(this);
  }
  //TODO: Funkcja, która rusza oxygen value z czasem, jeśli tego potrzebujemy

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
      "Location": jsonEncode(actionLocation)
    };
  }

  ActionModel.fromJson(Map<String, dynamic> json)
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
              MapEntry(key.toString(), TabSquad.fromJson(value))),
          actionLocation: Position.fromMap(jsonDecode(json["Location"])),
        );

  ActionModel copyWith({
    Map<String, double>? oxygenValues,
    Map<String, double>? usageRates,
    Map<String, DateTime>? newestCheckTimes,
    Map<String, Object>? waitingSquads,
    Map<String, SquadPage>? workingSquads,
    Map<String, Object>? finishedSquads,
    Map<String, TabSquad>? tabs,
    Position? actionLocation,
  }) {
    return ActionModel(
        oxygenValues: oxygenValues ?? this.oxygenValues,
        usageRates: usageRates ?? this.usageRates,
        newestCheckTimes: newestCheckTimes ?? this.newestCheckTimes,
        waitingSquads: waitingSquads ?? this.waitingSquads,
        workingSquads: workingSquads ?? this.workingSquads,
        finishedSquads: finishedSquads ?? this.finishedSquads,
        tabs: tabs ?? this.tabs,
        actionLocation: actionLocation ?? this.actionLocation);
  }

    void copyFrom(ActionModel other) {
        oxygenValues = other.oxygenValues;
        usageRates = other.usageRates;
        newestCheckTimes = other.newestCheckTimes;
        waitingSquads = other.waitingSquads;
        workingSquads = other.workingSquads;
        finishedSquads = other.finishedSquads;
        tabs = other.tabs;
        actionLocation = other.actionLocation;
  }
}
