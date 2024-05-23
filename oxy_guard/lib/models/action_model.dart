import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/action/tabs/working/squad_page.dart';
import 'package:oxy_guard/action/tabs/working/squad_tab.dart';
import 'package:oxy_guard/main.dart';

class ActionModel extends ChangeNotifier {
  List<double> oxygenValues;
  List<int> remainingTimes;
  List<double> usageRates;
  List<Object> waitingSquads;
  List<SquadPage> workingSquads;
  List<Object> finishedSquads;
  List<TabSquad> tabs;
  ActionModel({List<double>? oxygenValues, List<int>? remainingTimes, List<double>? usageRates, List<Object>? waitingSquads, List<SquadPage>? workingSquads, List<Object>? finishedSquads, List<TabSquad>? tabs}):
  oxygenValues = oxygenValues ?? <double>[],
  remainingTimes = remainingTimes ?? <int>[],
  usageRates = usageRates ?? <double>[],
  waitingSquads = waitingSquads ?? [],
  workingSquads = workingSquads ?? <SquadPage>[],
  finishedSquads = finishedSquads ?? [],
  tabs = tabs ?? <TabSquad>[]{
        NavigationService.databaseSevice.addAction(this);
  }

  void update(double newOxygen, double usageRate, int index) {
    oxygenValues[index] = newOxygen;
    usageRates[index] = usageRate;
    remainingTimes[index] = (oxygenValues[index] - 60) ~/ usageRate;
    notifyListeners();
  }

  void changeStarting(double newOxygen, int index){
    oxygenValues[index] = newOxygen;
    notifyListeners();
  }

  void advanceTime(int index) {
    remainingTimes[index]--;
    oxygenValues[index] -= usageRates[index];
    if (remainingTimes[index] < 0) remainingTimes[index] = 0;
    notifyListeners();
    NavigationService.databaseSevice.updateAction(this);
  }

  void startSquadWork(int entryPressure, int exitPressure, int interval) {
    oxygenValues.add(entryPressure.toDouble());
    usageRates.add(0.0);
    remainingTimes.add(entryPressure~/2); //TODO: Ustalić, czy i jeśli tak to jaki wpisujemy czas na start (aktualnie pesymistyczne założenie, ale możemy np. NaN czy coś)
    workingSquads.add(SquadPage(interval: interval, index: oxygenValues.length-1, entryPressure: entryPressure.toDouble(), exitPressure: exitPressure, text: "R${workingSquads.length+1}"));
    tabs.add(TabSquad(text: "R${workingSquads.length}", index: oxygenValues.length-1));
    notifyListeners();
  }
  //TODO: Funkcja, która rusza oxygen value z czasem, jeśli tego potrzebujemy

  Map<String, Object?> toJson(){
    return{
      "OxygenValues": jsonEncode(oxygenValues),
      "RemainingTimes": jsonEncode(remainingTimes),
      "UsageRates": jsonEncode(usageRates),
      "WaitingSquads": jsonEncode(waitingSquads),
      "WorkingSquads": jsonEncode(workingSquads),
      "FinishedSquads": jsonEncode(finishedSquads),
      "Tabs": jsonEncode(tabs)
    };
  }
  ActionModel.fromJson(Map<String, Object?> json):this(
    oxygenValues: jsonDecode(json["OxygenValues"]! as String),
    remainingTimes: jsonDecode(json["RemainingTimes"]! as String),
    usageRates: jsonDecode(json["UsageRates"]! as String),
    waitingSquads: jsonDecode(json["WaitingSquads"]! as String),
    workingSquads: jsonDecode(json["WorkingSquads"]! as String),
    finishedSquads: jsonDecode(json["FinishedSquads"]! as String),
    tabs: jsonDecode(json["Tabs"]! as String)
  );

  ActionModel copyWith({
    List<double>? oxygenValues,
    List<int>? remainingTimes,
    List<double>? usageRates,
    List<Object>? waitingSquads,
    List<SquadPage>? workingSquads,
    List<Object>? finishedSquads,
    List<TabSquad>? tabs}){
    return ActionModel(
      oxygenValues: oxygenValues ?? this.oxygenValues,
      remainingTimes: remainingTimes ?? this.remainingTimes,
      usageRates: usageRates ?? this.usageRates,
      waitingSquads: waitingSquads ?? this.waitingSquads,
      workingSquads: workingSquads ?? this.workingSquads,
      finishedSquads: finishedSquads ?? this.finishedSquads,
      tabs: tabs ?? this.tabs
    );
  }
}
