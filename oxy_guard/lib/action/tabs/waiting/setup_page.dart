import 'package:flutter/material.dart';
import 'package:oxy_guard/global_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oxy_guard/context_windows.dart';
import 'package:oxy_guard/models/personnel/worker.dart';

import '../../../models/squad_model.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPage2State();
}

class _SetupPage2State extends State<SetupPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  var checkInterval = 600;
  var entryPressure = 300;
  var exitPressure = 60;
  String localization = "";
  Worker? firstPerson;
  Worker? secondPerson;
  Worker? thirdPerson;
  List<Worker> workerList = [];
  bool _tripleSqaud = false;

  late FixedExtentScrollController pressureController;
  late FixedExtentScrollController secondsController;
  late FixedExtentScrollController minuteController;

  Future<void> _loadExtremePresssure() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      exitPressure = (prefs.getInt('extremePressure') ?? 60);
    });
  }

  Future<void> _loadTimePeriod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkInterval = (prefs.getInt('timePeriod') ?? 600);
    });
  }

  Future<void> _loadStartingPresssure() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      entryPressure = (prefs.getInt('startingPressure') ?? 300);
    });
  }

  @override
  void initState() {
    super.initState();

    workerList.addAll(GlobalService.currentPersonnel.team);

    _loadStartingPresssure();
    _loadTimePeriod();
    _loadExtremePresssure();
    pressureController = FixedExtentScrollController();
    secondsController = FixedExtentScrollController();
    minuteController = FixedExtentScrollController();
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
    super.build(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight =
        MediaQuery.of(GlobalService.navigatorKey.currentContext!).size.height -
            MediaQuery.of(GlobalService.navigatorKey.currentContext!)
                .viewPadding
                .vertical;
    var baseTextStyle = TextStyle(
      fontSize: screenWidth * 0.065,
    );
    var unitTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: screenWidth * 0.03,
    );
    var genericButtonStyle = ButtonStyle(
        elevation: const WidgetStatePropertyAll(5),
        backgroundColor: const WidgetStatePropertyAll(Colors.white),
        foregroundColor:
            WidgetStatePropertyAll(Theme.of(context).primaryColorDark),
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0)),
        textStyle: WidgetStatePropertyAll(TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: screenWidth * 0.05,
        )));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_pin, size: screenWidth * 0.1),
                    SizedBox(width: screenWidth * 0.1),
                    ElevatedButton(
                      onPressed: () async {
                        var selectedItem = await selectFromList(context, [
                          'Piwnica',
                          'Parter',
                          'Pierwsze piętro',
                          'Drugie piętro',
                          'Poddasze',
                          'Garaż',
                          'Inne'
                        ]);
                        setState(() {
                          localization = selectedItem ?? localization;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                        elevation: const WidgetStatePropertyAll(5),
                        minimumSize: WidgetStatePropertyAll(
                          Size(
                            screenWidth * 0.58,
                            screenHeight * 0.06,
                          ),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            localization.isEmpty
                                ? Text(
                                    "Wprowadź lokalizację",
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        color:
                                            Theme.of(context).primaryColorDark),
                                  )
                                : Text(
                                    localization,
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        color:
                                            Theme.of(context).primaryColorDark),
                                  ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.fire_extinguisher, size: screenWidth * 0.1),
                    SizedBox(width: screenWidth * 0.1),
                    ElevatedButton(
                      onPressed: () async {
                        var selectedItem = await selectWorkerFromList(context);
                        setState(() {
                          firstPerson = selectedItem ?? firstPerson;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                        elevation: const WidgetStatePropertyAll(5),
                        minimumSize: WidgetStatePropertyAll(
                          Size(
                            screenWidth * 0.58,
                            screenHeight * 0.06,
                          ),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              firstPerson != null
                                  ? '${firstPerson!.name} ${firstPerson!.surname}'
                                  : 'Wprowadź imię',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Theme.of(context).primaryColorDark),
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.fire_extinguisher, size: screenWidth * 0.1),
                    SizedBox(width: screenWidth * 0.1),
                    ElevatedButton(
                      onPressed: () async {
                        List<String> workierString = [];
                        for (Worker worker in workerList) {
                          workierString.add(
                              "${worker.name}+ ${worker.surname}"); // Przykładowo wypisanie imion pracowników
                        }
                        var selectedItem = await selectWorkerFromList(context);
                        setState(() {
                          secondPerson = selectedItem ?? secondPerson;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                        elevation: const WidgetStatePropertyAll(5),
                        minimumSize: WidgetStatePropertyAll(
                          Size(
                            screenWidth * 0.58,
                            screenHeight * 0.06,
                          ),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              secondPerson != null
                                  ? '${secondPerson!.name} ${secondPerson!.surname}'
                                  : 'Wprowadź imię',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Theme.of(context).primaryColorDark),
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _tripleSqaud
                  ? Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.fire_extinguisher,
                              size: screenWidth * 0.1),
                          SizedBox(width: screenWidth * 0.1),
                          ElevatedButton(
                            onPressed: () async {
                              var selectedItem =
                                  await selectWorkerFromList(context);
                              setState(() {
                                thirdPerson = selectedItem ?? thirdPerson;
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  const WidgetStatePropertyAll(Colors.white),
                              elevation: const WidgetStatePropertyAll(5),
                              minimumSize: WidgetStatePropertyAll(
                                Size(
                                  screenWidth * 0.58,
                                  screenHeight * 0.06,
                                ),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    thirdPerson != null
                                        ? '${thirdPerson!.name} ${thirdPerson!.surname}'
                                        : 'Wprowadź imię',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        color:
                                            Theme.of(context).primaryColorDark),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.fire_extinguisher,
                              size: screenWidth * 0.1),
                          SizedBox(width: screenWidth * 0.1),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _tripleSqaud = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                screenWidth * 0.58,
                                screenHeight * 0.06,
                              ),
                              backgroundColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Theme.of(context).primaryColorDark,
                              size: screenWidth * 0.1,
                            ),
                          ),
                        ],
                      ),
                    )
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
                        style: genericButtonStyle.copyWith(
                            fixedSize: WidgetStatePropertyAll(
                                Size(screenWidth * 0.22, 0))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                          var newEntryPressure = await checkListDialog(
                              context, 330, 160, "Wprowadź nowy pomiar",
                              unitText: "bar");
                          if (newEntryPressure != null) {
                            setState(() {
                              entryPressure = newEntryPressure;
                            });
                          }
                        },
                        style: genericButtonStyle.copyWith(
                            fixedSize: WidgetStatePropertyAll(
                                Size(screenWidth * 0.22, 0))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                          var newExitPressure = await checkListDialog(
                              context, 150, 0, "Wprowadź nowy pomiar",
                              unitText: "bar");
                          if (newExitPressure == null) {
                            return;
                          }
                          if (newExitPressure >= entryPressure) {
                            await warningDialog(
                                "Ciśnienie wyjściowe nie może być większe nić wejściowe");
                            return;
                          }
                          setState(() {
                            exitPressure = newExitPressure;
                          });
                        },
                        style: genericButtonStyle.copyWith(
                            fixedSize: WidgetStatePropertyAll(
                                Size(screenWidth * 0.22, 0))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                onPressed: () async {
                  if (Provider.of<SquadModel>(context, listen: false)
                          .workingSquads
                          .length <
                      3) {
                    Provider.of<SquadModel>(context, listen: false)
                        .startSquadWork(
                            entryPressure,
                            exitPressure,
                            checkInterval,
                            localization,
                            firstPerson,
                            secondPerson,
                            thirdPerson,
                            false);
                    await succesDialog(
                        context, 'Pomyślnie dodano rotę do pracujących');
                  } else {
                    await warningDialog('Maksymalnie 3 pracujace roty na raz');
                  }
                },
                style: genericButtonStyle.copyWith(
                    fixedSize: WidgetStatePropertyAll(
                        Size(screenWidth * 0.6, screenHeight * 0.1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColorDark,
                      size: screenWidth * 0.15,
                    ),
                    Center(
                      child: Text(
                        "Dodaj rotę",
                        style: TextStyle(fontSize: screenWidth * 0.08),
                      ),
                    ),
                  ],
                ))
          ],
        )
      ],
    );
  }

  Future<int?> timeDialog() => showDialog<int>(
      context: context,
      builder: (context) => Dialog(
            backgroundColor: const Color(0xfffcfcfc),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              "Wprowadź czas wyjścia",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.06,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "(min:sek)",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: ListWheelScrollView.useDelegate(
                                controller: minuteController,
                                itemExtent:
                                    MediaQuery.of(context).size.width * 0.14,
                                perspective: 0.005,
                                overAndUnderCenterOpacity: 0.6,
                                squeeze: 1,
                                magnification: 1.1,
                                diameterRatio: 1.5,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 16,
                                  builder: (context, index) => Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .01,
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .04),
                                      child: Text("$index",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.06,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                            child: Text(":",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: ListWheelScrollView.useDelegate(
                                controller: secondsController,
                                itemExtent:
                                    MediaQuery.of(context).size.width * 0.14,
                                perspective: 0.005,
                                overAndUnderCenterOpacity: 0.6,
                                squeeze: 1,
                                magnification: 1.1,
                                diameterRatio: 1.5,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 4,
                                  builder: (context, index) => Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .01,
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .04),
                                      child: Text("${index * 15}",
                                          //To powoduje, że Card zawierający 0 sekund jest mniejszy niż 15/30/45. Brzydkie, ale nie widzę szybkiej poprawki na to.
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.06,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    fixedSize: WidgetStatePropertyAll(Size(
                                        MediaQuery.of(context).size.width * 0.5,
                                        MediaQuery.of(context).size.height *
                                            0.07)),
                                    elevation: const WidgetStatePropertyAll(5),
                                    shape: const WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                    backgroundColor:
                                        const WidgetStatePropertyAll(
                                            Colors.white),
                                    foregroundColor: WidgetStatePropertyAll(
                                        Theme.of(context).primaryColorDark),
                                    textStyle: WidgetStatePropertyAll(TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ))),
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      15 * secondsController.selectedItem +
                                          60 * minuteController.selectedItem);
                                },
                                child: const Text("Wprowadź")),
                          ],
                        ))
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
          backgroundColor: const Color(0xfffcfcfc),
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
