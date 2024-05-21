import 'package:flutter/cupertino.dart';
import 'package:oxy_guard/squad_page.dart';
import 'package:oxy_guard/squad_tab.dart';

class ActionModel extends ChangeNotifier {
  double screenHeight;//TODO: Usunąć to pole, ta klasa będzie zapisywana w firestorze
  var oxygenValues = <double>[];
  var remainingTimes = <int>[];
  var usageRates = <double>[];
  var waitingSquads = [];
  var workingSquads = <SquadPage>[];
  var finishedSquads = [];
  var tabs = <TabSquad>[];
  ActionModel({required this.screenHeight});
  ActionModel.sync({required this.screenHeight, required this.oxygenValues, required this.remainingTimes, required this.usageRates, required this.waitingSquads, required this.workingSquads, required this.finishedSquads, required this.tabs});

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

  toJson(){
    return{
      "OxygenValues": oxygenValues,
      "RemainingTimes": remainingTimes,
      "UsageRates": usageRates,
      "WaitingSquads": waitingSquads,
      "WorkingSquads": workingSquads,
      "FinishedSquads": finishedSquads,
      "Tabs": tabs
    };
  }
}
