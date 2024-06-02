import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/squad_model.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPage2State();
}

class _SetupPage2State extends State<SetupPage> {
  var baseTextStyle = const TextStyle(
    fontSize: 26,
  );
  var unitTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  var checkInterval = 600;
  var entryPressure = 300;
  var exitPressure = 60;

  late FixedExtentScrollController pressureController;
  late FixedExtentScrollController secondsController;
  late FixedExtentScrollController minuteController;
  var genericButtonStyle = const ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.grey),
      foregroundColor: MaterialStatePropertyAll(Colors.black),
      padding: MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0)),
      textStyle: MaterialStatePropertyAll(TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      )));

  @override
  void initState() {
    pressureController = FixedExtentScrollController();
    secondsController = FixedExtentScrollController();
    minuteController = FixedExtentScrollController();
    super.initState();
  }

  @override
  void dispose() {
    pressureController.dispose();
    secondsController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.location_pin, size: 40),
                    Text("Lokalizacja", style: baseTextStyle),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.fire_extinguisher, size: 40),
                    Text(
                      "Jacek Jaworek",
                      style: baseTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.fire_extinguisher,
                      size: 40,
                    ),
                    Text("Jakub Nalepa", style: baseTextStyle),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.fire_extinguisher, size: 40),
                    Text("Janusz Kowalski", style: baseTextStyle),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Okres pomiarów",
                      style: baseTextStyle,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          var newCheckInterval = await timeDialog();
                          if (newCheckInterval != null) {
                            setState(() {
                              checkInterval = newCheckInterval;
                            });
                          }
                        },
                        style: genericButtonStyle,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${checkInterval ~/ 60}${checkInterval % 60 == 0 ? "" : ":${checkInterval % 60 < 10 ? "0${checkInterval % 60}" : checkInterval % 60}"}",
                                style: baseTextStyle,
                              ),
                              Text(
                                "MIN",
                                style: unitTextStyle,
                              )
                            ]))
                  ],
                ),
              ),
              //TODO: szerokosc tych rzedow ogarnac layoutbuilderem (po prostu sciagnac szerokosc z widgetinspectora, jesli nie ma dla nich miejsca to zwijać ciśnienie w ciśn. czy coś takiego)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ciśnienie początkowe",
                      style: baseTextStyle,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          var newEntryPressure = await pressureDialog();
                          if (newEntryPressure != null) {
                            setState(() {
                              entryPressure = newEntryPressure;
                            });
                          }
                        },
                        style: genericButtonStyle,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                entryPressure.toString(),
                                style: baseTextStyle,
                              ),
                              Text(
                                "BAR",
                                style: unitTextStyle,
                              )
                            ]))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ciśnienie wyjściowe",
                      style: baseTextStyle,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          var newExitPressure = await pressureDialog();
                          if (newExitPressure == null) {
                            return;
                          }
                          if(newExitPressure >= entryPressure){
                            await warningDialog("Ciśnienie wyjściowe nie może być większe nić wejściowe");
                            return;
                          }
                          setState(() {
                            exitPressure = newExitPressure;
                          });
                        },
                        style: genericButtonStyle,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                exitPressure.toString(),
                                style: baseTextStyle,
                              ),
                              Text(
                                "BAR",
                                style: unitTextStyle,
                              )
                            ]))
                  ],
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                //TODO: Ten system z gotowościa bo nie wiem co jest 5
                onPressed: () async {
                  if (Provider.of<SquadModel>(context, listen: false)
                          .workingSquads
                          .length <
                      3) {
                    Provider.of<SquadModel>(context, listen: false)
                        .startSquadWork(
                            entryPressure, exitPressure, checkInterval);
                  } else {
                    await warningDialog('Maksymalnie 3 pracujace roty na raz');
                  }
                },
                style: genericButtonStyle,
                child: const Center(
                  child: Text("Dodaj rotę"),
                ))
          ],
        )
      ],
    );
  }

  Future<int?> pressureDialog() => showDialog<int>(
      context: context,
      builder: (context) => Dialog(
            child: SizedBox(
              height: 500,
              width: 600,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                        flex: 2,
                        child: Text(
                          "Wprowadź nowy pomiar",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                      flex: 6,
                      child: ListWheelScrollView.useDelegate(
                          controller: pressureController,
                          itemExtent: 50,
                          perspective: 0.005,
                          overAndUnderCenterOpacity: 0.6,
                          squeeze: 1,
                          magnification: 1.1,
                          diameterRatio: 1.5,
                          physics: const FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 34,
                            builder: (context, index) =>
                                Text("${330 - 10 * index}",
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    )),
                          )),
                    ),
                    Expanded(
                        flex: 2,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(
                                  330 - 10 * pressureController.selectedItem);
                            },
                            child: const Text("Wprowadź")))
                  ],
                ),
              ),
            ),
          ));

  Future<int?> timeDialog() => showDialog<int>(
      context: context,
      builder: (context) => Dialog(
            child: SizedBox(
              height: 500,
              width: 600,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text(
                              "Wprowadź czas wyjścia",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "(min)",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ListWheelScrollView.useDelegate(
                                controller: minuteController,
                                itemExtent: 50,
                                perspective: 0.005,
                                overAndUnderCenterOpacity: 0.6,
                                squeeze: 1,
                                magnification: 1.1,
                                diameterRatio: 1.5,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 16,
                                  builder: (context, index) => Text("$index",
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                )),
                          ),
                          Container(
                            width: 10,
                            padding: const EdgeInsets.only(bottom: 18),
                            child: const Text(":",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: 100,
                            child: ListWheelScrollView.useDelegate(
                                controller: secondsController,
                                itemExtent: 50,
                                perspective: 0.005,
                                overAndUnderCenterOpacity: 0.6,
                                squeeze: 1,
                                magnification: 1.1,
                                diameterRatio: 1.5,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 4,
                                  builder: (context, index) => Text(
                                      "${index * 15}",
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(
                                  15 * secondsController.selectedItem +
                                      60 * minuteController.selectedItem);
                            },
                            child: const Text("Wprowadź")))
                  ],
                ),
              ),
            ),
          ));

  Future<void> warningDialog(String warningText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('OSTRZEŻENIE'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Text(warningText)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
