import 'package:OxyGuard/context_windows.dart';
import 'package:OxyGuard/repositories/location_repository.dart';
import 'package:OxyGuard/models/models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

class WaitingBody extends StatefulWidget {
  const WaitingBody({super.key});

  @override
  State<WaitingBody> createState() => _WaitingBodyState();
}

class _WaitingBodyState extends State<WaitingBody> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var checkInterval = 600;
  var entryPressure = 300;
  var exitPressure = 60;
  String localization = "";
  Worker? firstPerson;
  Worker? secondPerson;
  Worker? thirdPerson;

  bool _tripleSqaud = false;

  late FixedExtentScrollController pressureController = FixedExtentScrollController();
  late FixedExtentScrollController secondsController = FixedExtentScrollController();
  late FixedExtentScrollController minuteController = FixedExtentScrollController();

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

    _loadStartingPresssure();
    _loadTimePeriod();
    _loadExtremePresssure();
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
    var screenHeight = MediaQuery.of(GetIt.I.get<LocationRepository>().navigatorKey.currentContext!).size.height -
        MediaQuery.of(GetIt.I.get<LocationRepository>().navigatorKey.currentContext!).viewPadding.vertical;
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
        foregroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColorDark),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0)),
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
                        var selectedItem = await selectFromList(context,
                            ['Piwnica', 'Parter', 'Pierwsze piętro', 'Drugie piętro', 'Poddasze', 'Garaż', 'Inne']);
                        setState(() {
                          localization = selectedItem ?? localization;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(Colors.white),
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
                                        fontSize: screenWidth * 0.05, color: Theme.of(context).primaryColorDark),
                                  )
                                : Text(
                                    localization,
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.05, color: Theme.of(context).primaryColorDark),
                                  ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildWorkerPicker(firstPerson, (Worker? worker) => firstPerson = worker),
              _buildWorkerPicker(secondPerson, (Worker? worker) => secondPerson = worker),
              _tripleSqaud
                  ? _buildWorkerPicker(thirdPerson, (Worker? worker) => thirdPerson = worker)
                  : Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.fire_extinguisher, size: screenWidth * 0.1),
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
                        style:
                            genericButtonStyle.copyWith(fixedSize: WidgetStatePropertyAll(Size(screenWidth * 0.22, 0))),
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
                          var newEntryPressure =
                              await checkListDialog(context, 330, 160, "Wprowadź nowy pomiar", unitText: "bar");
                          if (newEntryPressure != null) {
                            setState(() {
                              entryPressure = newEntryPressure;
                            });
                          }
                        },
                        style:
                            genericButtonStyle.copyWith(fixedSize: WidgetStatePropertyAll(Size(screenWidth * 0.22, 0))),
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
                          var newExitPressure =
                              await checkListDialog(context, 150, 0, "Wprowadź nowy pomiar", unitText: "bar");
                          if (newExitPressure == null) {
                            return;
                          }
                          if (newExitPressure >= entryPressure) {
                            await warningDialog("Ciśnienie wyjściowe nie może być większe nić wejściowe");
                            return;
                          }
                          setState(() {
                            exitPressure = newExitPressure;
                          });
                        },
                        style:
                            genericButtonStyle.copyWith(fixedSize: WidgetStatePropertyAll(Size(screenWidth * 0.22, 0))),
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
                  //TODO: Start this teams work
                },
                style: genericButtonStyle.copyWith(
                    fixedSize: WidgetStatePropertyAll(Size(screenWidth * 0.6, screenHeight * 0.1))),
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

  Widget _buildWorkerPicker(Worker? worker, Function(Worker?) direction) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(GetIt.I.get<LocationRepository>().navigatorKey.currentContext!).size.height -
        MediaQuery.of(GetIt.I.get<LocationRepository>().navigatorKey.currentContext!).viewPadding.vertical;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(Icons.fire_extinguisher, size: screenWidth * 0.1),
          SizedBox(width: screenWidth * 0.1),
          ElevatedButton(
            onPressed: () async {
              var selectedWorker = await selectWorkerFromList(context);
              setState(() {
                direction(selectedWorker);
              });
            },
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(Colors.white),
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
                    secondPerson != null ? '${secondPerson!.name} ${secondPerson!.surname}' : 'Wprowadź imię',
                    style: TextStyle(fontSize: screenWidth * 0.05, color: Theme.of(context).primaryColorDark),
                  ),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ],
      ),
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
                                  fontSize: MediaQuery.of(context).size.width * 0.06, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "(min:sek)",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.normal),
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
                                itemExtent: MediaQuery.of(context).size.width * 0.14,
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
                                          vertical: MediaQuery.of(context).size.height * .01,
                                          horizontal: MediaQuery.of(context).size.width * .04),
                                      child: Text("$index",
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColorDark,
                                              fontSize: MediaQuery.of(context).size.width * 0.06,
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
                                    fontSize: MediaQuery.of(context).size.width * 0.06,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: ListWheelScrollView.useDelegate(
                                controller: secondsController,
                                itemExtent: MediaQuery.of(context).size.width * 0.14,
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
                                          vertical: MediaQuery.of(context).size.height * .01,
                                          horizontal: MediaQuery.of(context).size.width * .04),
                                      child: Text("${index * 15}",
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColorDark,
                                              fontSize: MediaQuery.of(context).size.width * 0.06,
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
                                    fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width * 0.5,
                                        MediaQuery.of(context).size.height * 0.07)),
                                    elevation: const WidgetStatePropertyAll(5),
                                    shape: const WidgetStatePropertyAll(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                                    backgroundColor: const WidgetStatePropertyAll(Colors.white),
                                    foregroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColorDark),
                                    textStyle: WidgetStatePropertyAll(TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.width * 0.05,
                                    ))),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(15 * secondsController.selectedItem + 60 * minuteController.selectedItem);
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
      barrierDismissible: false,
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
