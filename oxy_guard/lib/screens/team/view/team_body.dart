import 'dart:async';

import 'package:OxyGuard/context_windows.dart';
import 'package:OxyGuard/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:watch_it/watch_it.dart';

import '../../../repositories/location_repository.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class TeamBody extends StatefulWidget {
  const TeamBody({super.key, required this.team});

  final Team team;

  @override
  State<TeamBody> createState() => _TeamBodyState();
}

class _TeamBodyState extends State<TeamBody> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  //Declarations
  DateTime? lastCheckAllert;
  DateTime? lastExitAllert;
  late Timer halfSec;
  late FixedExtentScrollController checkController = FixedExtentScrollController();
  late FixedExtentScrollController lastCheckController = FixedExtentScrollController();
  late FixedExtentScrollController secondLastCheckController = FixedExtentScrollController();
  late FixedExtentScrollController exitMinuteController = FixedExtentScrollController();
  late FixedExtentScrollController exitSecondsController = FixedExtentScrollController();

  bool isCheckAllertInactive = true;
  bool isExitAllertInactive = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(covariant TeamBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    //TODO: High consumption alert
  }

  @override
  void initState() {
    super.initState();
    halfSec = Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      if (!mounted) return;
      setState(() {
        _checkPressureAndNotify();
      });
    });
  }

  @override
  void dispose() {
    checkController.dispose();
    exitMinuteController.dispose();
    exitSecondsController.dispose();
    lastCheckController.dispose();
    secondLastCheckController.dispose();
    super.dispose();
  }

  //UI
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: Row(
            children: [
              Expanded(
                  flex: 68,
                  child: Column(
                    children: [
                      _buildWorkersAndLocationInfo(),
                      _buildInfo(),
                    ],
                  )),
              Expanded(
                  flex: 32,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                widget.team.isInCrisis = !widget.team.isInCrisis;
                                //TODO: add check with max consumption (15/60) and current oxygen and current date
                              });
                            },
                            icon: const Icon(IconData(0xf3e1,
                                fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage)),
                            style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(Colors.red),
                                foregroundColor: WidgetStatePropertyAll(Colors.white),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))))),
                      ),
                      _buildOxygenMeter(),
                    ],
                  )),
            ],
          ),
        ),
        ..._buildButtons(),
      ],
    );
  }

  Future<List<(DateTime, double)>?> editChecksDialog() => showDialog<List<(DateTime, double)>>(
      context: context,
      builder: (context) {
        //TODO: Edit dialog
        throw UnimplementedError();
      });

  void _checkPressureAndNotify() async {
    //TODO: Notifications about oxygen running out
  }

  Widget _buildLocationPicker() {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(GetIt.I.get<LocationRepository>().navigatorKey.currentContext!).size.height -
        MediaQuery.of(GetIt.I.get<LocationRepository>().navigatorKey.currentContext!).viewPadding.vertical;
    var squadTextStyle = TextStyle(
      fontSize: screenWidth * 0.06,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.location_pin,
            size: screenWidth * 0.1,
          ),
          widget.team.workingArea == null
              ? Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      var selectedItem = await selectFromList(context,
                          ['piwnica', 'parter', 'pierwsze piętro', 'drugie piętro', 'poddasze', 'garaż', 'inne']);
                      setState(() {
                        widget.team.workingArea = selectedItem ?? "";
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
                            "Wprowadź lokalizację",
                            style: TextStyle(fontSize: screenWidth * 0.035, color: Theme.of(context).primaryColorDark),
                          ),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  width: screenWidth * 0.5,
                  child: Center(
                    child: Text(
                      widget.team.workingArea!,
                      style: squadTextStyle,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildWorkerPicker(Worker? worker, int index) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(GetIt.I.get<LocationRepository>().navigatorKey.currentContext!).size.height -
        MediaQuery.of(GetIt.I.get<LocationRepository>().navigatorKey.currentContext!).viewPadding.vertical;

    var squadTextStyle = TextStyle(
      fontSize: screenWidth * 0.06,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.fire_extinguisher,
            size: screenWidth * 0.1,
          ),
          worker == null
              ? Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Worker? selectedWorker = await selectWorkerFromList(context);
                      if (worker == null) return;
                      switch (index) {
                        case 1:
                          widget.team.firstWorker = selectedWorker;
                        case 2:
                          widget.team.secondWorker = selectedWorker;
                        case 3:
                          widget.team.thirdWorker = selectedWorker;
                      }
                      //TODO: Update Team with a new worker
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
                            "Wprowadź imię",
                            style: TextStyle(fontSize: screenWidth * 0.035, color: Theme.of(context).primaryColorDark),
                          ),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  width: screenWidth * 0.5,
                  child: Center(
                    child: Text(
                      '${worker.name} ${worker.surname}',
                      style: squadTextStyle,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildWorkersAndLocationInfo() {
    return Expanded(
        flex: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            children: [
              _buildLocationPicker(),
              _buildWorkerPicker(widget.team.firstWorker, 1),
              _buildWorkerPicker(widget.team.secondWorker, 2),
              _buildWorkerPicker(widget.team.thirdWorker, 3),
            ],
          ),
        ));
  }

  Widget _buildOxygenMeter() {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(GetIt.I.get<LocationRepository>().navigatorKey.currentContext!).size.height -
        MediaQuery.of(GetIt.I.get<LocationRepository>().navigatorKey.currentContext!).viewPadding.vertical;
    var varTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: screenWidth * 0.05,
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025, horizontal: screenWidth * 0.042),
      child: Container(
        height: screenHeight * 0.45,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey.withOpacity(0.8), width: 7),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          gradient: const LinearGradient(
            colors: [Colors.green, Colors.red],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(widget.team.entryPressure.toString(), style: varTextStyle),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(widget.team.isInCrisis ? "0" : widget.team.criticalPressure.toString(),
                        style: varTextStyle),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: Text(widget.team.name,
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.3),
                            fontSize: MediaQuery.of(context).size.width * 0.15,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Positioned(
                  top: widget.team.isInCrisis
                      ? widget.team.getOxygenRemaining() >= 0
                          ? 14 +
                              ((constraints.maxHeight - 69) /
                                  (widget.team.checks.first.$2) *
                                  (widget.team.checks.first.$2 - widget.team.getOxygenRemaining()))
                          : 14 + ((constraints.maxHeight - 69))
                      : widget.team.getOxygenRemaining() >= widget.team.criticalPressure
                          ? 14 +
                              ((constraints.maxHeight - 69) /
                                  (widget.team.checks.first.$2 - widget.team.criticalPressure) *
                                  (widget.team.checks.first.$2 - widget.team.getOxygenRemaining()))
                          : 14 +
                              ((constraints.maxHeight - 69) /
                                  (widget.team.checks.first.$2 - widget.team.criticalPressure) *
                                  (widget.team.checks.first.$2 - widget.team.criticalPressure)),
                  left: 1,
                  right: 1,
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.team.getOxygenRemaining() >= 0
                                ? widget.team.getOxygenRemaining().toInt().toString()
                                : "0",
                            style: varTextStyle,
                          ))),
                ),
                Positioned(
                    top: 24.5 +
                        ((constraints.maxHeight - 69) /
                            (widget.team.checks.first.$2 - widget.team.criticalPressure) *
                            (widget.team.checks.first.$2 -
                                ((((widget.team.travelTime * widget.team.oxygenUsageRate).toInt()) >
                                                widget.team.criticalPressure
                                            ? ((widget.team.travelTime * widget.team.oxygenUsageRate).toInt())
                                            : widget.team.criticalPressure) <
                                        widget.team.checks.first.$2
                                    ? (((widget.team.travelTime * widget.team.oxygenUsageRate).toInt()) >
                                            widget.team.criticalPressure
                                        ? ((widget.team.travelTime * widget.team.oxygenUsageRate).toInt())
                                        : widget.team.criticalPressure)
                                    : widget.team.checks.first.$2))),
                    left: -3,
                    child: ClipPath(
                      clipper: LeftTriangle(),
                      child: Container(
                        color: Colors.grey,
                        height: 20,
                        width: 20,
                      ),
                    )),
                Positioned(
                    top: 24.5 +
                        ((constraints.maxHeight - 69) /
                            (widget.team.checks.first.$2 - widget.team.criticalPressure) *
                            (widget.team.checks.first.$2 -
                                (((widget.team.travelTime * widget.team.oxygenUsageRate).toInt() +
                                            widget.team.criticalPressure) <
                                        widget.team.checks.first.$2
                                    ? ((widget.team.travelTime * widget.team.oxygenUsageRate).toInt() +
                                        widget.team.criticalPressure)
                                    : widget.team.checks.first.$2))),
                    right: -3,
                    child: ClipPath(
                      clipper: RightTriangle(),
                      child: Container(
                        color: Colors.blue,
                        height: 20,
                        width: 20,
                      ),
                    )),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfo() {
    var screenWidth = MediaQuery.of(context).size.width;
    var infoTextStyle = TextStyle(
      fontSize: screenWidth * 0.05,
    );
    var varTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: screenWidth * 0.05,
    );
    var unitTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: screenWidth * 0.03,
    );
    return Expanded(
        flex: 5,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: 8,
            right: 8,
          ),
          child: widget.team.isInCrisis
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text("TRYB ALARMOWY",
                          style: infoTextStyle.copyWith(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Text(
                              "Pozostały czas",
                              style: infoTextStyle,
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Center(
                                child: Row(
                                  children: [
                                    Text(
                                      widget.team.checks.isNotEmpty
                                          ? "${widget.team.getTimeRemainingInCrisis() ~/ 60}:${widget.team.getTimeRemainingInCrisis() % 60 < 10 ? "0${(widget.team.getTimeRemainingInCrisis() % 60).toInt()}" : (widget.team.getTimeRemainingInCrisis() % 60).toInt()}"
                                          : "NaN",
                                      style: varTextStyle.apply(
                                          color: HSVColor.lerp(
                                                  HSVColor.fromColor(Colors.green),
                                                  HSVColor.fromColor(Colors.red),
                                                  1 - (widget.team.getOxygenRemaining() - 60) / 270)!
                                              .toColor()),
                                    ),
                                    Text("min",
                                        style: unitTextStyle.apply(
                                            color: HSVColor.lerp(
                                                    HSVColor.fromColor(Colors.green),
                                                    HSVColor.fromColor(Colors.red),
                                                    1 - (widget.team.getOxygenRemaining() - 60) / 270)!
                                                .toColor()))
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Text("Intensywność", style: infoTextStyle),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                  color: widget.team.oxygenUsageRate * 60 < 10
                                      ? widget.team.oxygenUsageRate * 60 < 5
                                          ? Colors.blue
                                          : Colors.yellow
                                      : Colors.red,
                                  borderRadius: const BorderRadius.all(Radius.circular(5))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Text(
                              "Bezp. czas.",
                              style: infoTextStyle,
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Center(
                                child: Row(
                                  children: [
                                    Text(
                                      widget.team.checks.isNotEmpty
                                          ? "${widget.team.getTimeRemaining() ~/ 60}:${widget.team.getTimeRemaining() % 60 < 10 ? "0${(widget.team.getTimeRemaining() % 60).toInt()}" : (widget.team.getTimeRemaining() % 60).toInt()}"
                                          : "NaN",
                                      style: varTextStyle.apply(
                                          color: HSVColor.lerp(
                                                  HSVColor.fromColor(Colors.green),
                                                  HSVColor.fromColor(Colors.red),
                                                  1 - (widget.team.getOxygenRemaining() - 60) / 270)!
                                              .toColor()),
                                    ),
                                    Text("min",
                                        style: unitTextStyle.apply(
                                            color: HSVColor.lerp(
                                                    HSVColor.fromColor(Colors.green),
                                                    HSVColor.fromColor(Colors.red),
                                                    1 - (widget.team.getOxygenRemaining() - 60) / 270)!
                                                .toColor()))
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Text("Ostatni pomiar", style: infoTextStyle),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                                child: Row(
                              children: [
                                widget.team.checks.isEmpty
                                    ? Text(
                                        "0:00",
                                        style: varTextStyle,
                                      )
                                    : Text(
                                        "${DateTime.now().difference(widget.team.checks.last.$1).inMinutes}:${DateTime.now().difference(widget.team.checks.last.$1).inSeconds % 60 < 10 ? "0${DateTime.now().difference(widget.team.checks.last.$1).inSeconds % 60}" : "${DateTime.now().difference(widget.team.checks.last.$1).inSeconds % 60}"}",
                                        style: varTextStyle),
                                Text("min", style: unitTextStyle)
                              ],
                            )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Text("Punkt pracy", style: infoTextStyle),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                                child: Row(
                              children: [
                                Text(
                                    widget.team.travelTime == 0
                                        ? "BRAK"
                                        : "${widget.team.travelTime ~/ 60}:${widget.team.travelTime % 60 < 10 ? "0${(widget.team.travelTime % 60).toInt()}" : (widget.team.travelTime % 60).toInt()}",
                                    style: varTextStyle),
                                Text(widget.team.travelTime == 0 ? "" : "min", style: unitTextStyle)
                              ],
                            )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 3),
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: const Text("BAR", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text("bezp. powrót", style: infoTextStyle),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                                child: Row(
                              children: [
                                Text("${(widget.team.travelTime * widget.team.oxygenUsageRate).toInt()}",
                                    style: varTextStyle),
                                Text("BAR", style: unitTextStyle)
                              ],
                            )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 3),
                                  decoration: const BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: const Text("BAR", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text("zał. wyjście", style: infoTextStyle),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                                child: Row(
                              children: [
                                Text(
                                    "${(widget.team.travelTime * widget.team.oxygenUsageRate).toInt() + widget.team.criticalPressure}",
                                    style: varTextStyle),
                                Text("BAR", style: unitTextStyle)
                              ],
                            )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ));
  }

  List<Widget> _buildButtons() {
    var screenWidth = MediaQuery.of(context).size.width;

    var varTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: screenWidth * 0.05,
    );
    var unitTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: screenWidth * 0.03,
    );

    var bottomButtonStyle = ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.white),
        foregroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColorDark),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 1.0)),
        elevation: const WidgetStatePropertyAll(5),
        shape:
            const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))));
    return <Widget>[
      Expanded(
        flex: 1,
        child: Row(
          children: [
            Expanded(
                flex: 40,
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (!widget.team.isWorking) {
                            setState(() {
                              widget.team.isWorking = true;
                              //TODO: Add first check with max oxygen and current date to mark the beginning of work
                            });
                          } else if (widget.team.travelTime == 0) {
                            setState(() {
                              widget.team.travelTime = DateTime.now().difference(widget.team.checks.first.$1).inSeconds;
                              //TODO: Update team
                            });
                          } else {
                            setState(() {
                              //TODO: End this teams work, make a finishedTeam etc
                            });
                          }
                        },
                        style: bottomButtonStyle,
                        child: Center(
                          child: Text(
                            !widget.team.isWorking
                                ? "START PRACY"
                                : widget.team.travelTime == 0
                                    ? "PUNKT PRACY"
                                    : "WYCOFAJ",
                            style: varTextStyle,
                          ),
                        )))),
            Expanded(
                flex: 60,
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (!widget.team.isWorking) {
                            await warningDialog(
                                context, "Nie można wprowadzać nowych pomiarów przed rozpoczęciem pracy");
                            return;
                          }
                          final parse = await checkListDialog(
                              context, (widget.team.getOxygenRemaining() ~/ 10 - 1) * 10, 0, "Wprowadź nowy pomiar",
                              unitText: "bar");
                          if (parse == null) return;
                          final valid = parse.toDouble();
                          setState(() {
                            DateTime timestamp = DateTime.now();
                            if (widget.team.checks.isNotEmpty) {
                              widget.team.oxygenUsageRate = (widget.team.checks.last.$2 - valid) /
                                  (timestamp.difference(widget.team.checks.last.$1).inSeconds);
                            }

                            widget.team.checks.add((timestamp, valid));
                            //TODO: Update Team
                          });
                        },
                        style: bottomButtonStyle,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("POMIAR (", style: varTextStyle),
                              Text(
                                "ost. ",
                                style: unitTextStyle,
                              ),
                              Text(
                                "${widget.team.checks.last.$2.toInt()}",
                                style: varTextStyle,
                              ),
                              Text(
                                "BAR",
                                style: unitTextStyle,
                              ),
                              Text(
                                ")",
                                style: varTextStyle,
                              ),
                            ],
                          ),
                        )))),
          ],
        ),
      ),
      Expanded(
        flex: 1,
        child: Row(
          children: [
            Expanded(
                flex: 40,
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          final List<(DateTime, double)>? edits = await editChecksDialog();
                          if (edits != null) {
                            widget.team.checks = edits;
                            final (DateTime, double) last = widget.team.checks.last;
                            final (DateTime, double) secondToLast = widget.team.checks[widget.team.checks.length - 2];
                            final double oxygenConsumed = secondToLast.$2 - last.$2;
                            final Duration timePassed = last.$1.difference(secondToLast.$1);
                            widget.team.oxygenUsageRate = oxygenConsumed / timePassed.inSeconds;
                            //TODO: Update team
                          }
                        },
                        style: bottomButtonStyle,
                        child: Center(
                          child: Text("EDYTUJ", style: varTextStyle),
                        )))),
            Expanded(
                flex: 60,
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          final int? newTravelTime = await timeDialog(context, "Wprowadź czas wyjścia");
                          if (newTravelTime == null) return;
                          setState(() {
                            widget.team.travelTime = newTravelTime;
                          });
                        },
                        style: bottomButtonStyle,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "CZAS WYJŚCIA: ${widget.team.travelTime ~/ 60}${(widget.team.travelTime % 60).toInt() == 0 ? "" : ":${(widget.team.travelTime % 60).toInt() < 10 ? "0${(widget.team.travelTime % 60).toInt()}" : "${(widget.team.travelTime % 60).toInt()}"}"}",
                                style: varTextStyle,
                              ),
                              Text(
                                "MIN",
                                style: unitTextStyle,
                              )
                            ],
                          ),
                        )))),
          ],
        ),
      ),
    ];
  }
}

class LeftTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height / 2.0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class RightTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height / 2.0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
