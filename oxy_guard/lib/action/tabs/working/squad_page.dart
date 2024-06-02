import 'dart:async';
import 'dart:convert';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/squad_model.dart';
import '../../../global_service.dart';

class SquadPage extends StatefulWidget {
  double usageRate;
  double entryPressure;
  int exitPressure;
  String text = "R";
  double returnPressure;
  double plannedReturnPressure;
  int exitTime;
  final int interval;
  final int index;
  List<double> checks;
  List<DateTime> checkTimes;
  bool working;
  SquadPage(
      {super.key,
      required this.interval,
      required this.index,
      required this.entryPressure,
      required this.exitPressure,
      required this.text,
      int? exitTime,
      double? usageRate,
      double? returnPressure,
      double? plannedReturnPressure,
      List<double>? checks,
      List<DateTime>? checkTimes,
      bool? working})
      : exitTime = exitTime ?? 0,
        usageRate = usageRate ?? 10.0 / 60.0,
        returnPressure = returnPressure ?? 100.0,
        plannedReturnPressure = plannedReturnPressure ?? 120.0,
        checks = checks ?? <double>[],
        checkTimes = checkTimes ?? <DateTime>[],
        working = working ?? false;
  SquadPage.fromJson(Map<String, dynamic> json)
      : this(
          usageRate: json["UsageRate"]! as double,
          entryPressure: json["EntryPressure"]! as double,
          exitPressure: json["ExitPressure"]! as int,
          text: json["Text"]! as String,
          returnPressure: json["ReturnPressure"]! as double,
          plannedReturnPressure: json["PlannedReturnPressure"]! as double,
          exitTime: json["ExitTime"]! as int,
          interval: json["Interval"]! as int,
          index: json["Index"]! as int,
          checks: List<double>.from(jsonDecode(json["Checks"]!)),
          checkTimes: (jsonDecode(json["CheckTimes"]!) as List).map((time) => DateTime.parse(time).toLocal()).toList(),
          working: json["Working"] as bool,
        );
  @override
  State<SquadPage> createState() => _SquadPageState();

  SquadPage copyWith({
    double? usageRate,
    double? entryPressure,
    int? exitPressure,
    String? text,
    double? returnPressure,
    double? plannedReturnPressure,
    int? exitTime,
    int? interval,
    int? index,
    List<double>? checks,
    List<DateTime>? checkTimes,
    bool? working,
  }) {
    return SquadPage(
        usageRate: usageRate ?? this.usageRate,
        returnPressure: returnPressure ?? this.returnPressure,
        plannedReturnPressure:
            plannedReturnPressure ?? this.plannedReturnPressure,
        exitTime: exitTime ?? this.exitTime,
        checks: checks ?? this.checks,
        checkTimes: checkTimes ?? this.checkTimes,
        interval: interval ?? this.interval,
        index: index ?? this.index,
        entryPressure: entryPressure ?? this.entryPressure,
        exitPressure: exitPressure ?? this.exitPressure,
        text: text ?? this.text,
        working: working ?? this.working);
  }

  Map<String, dynamic> toJson() {
    return {
      "UsageRate": usageRate,
      "EntryPressure": entryPressure,
      "ExitPressure": exitPressure,
      "Text": text,
      "ReturnPressure": returnPressure,
      "PlannedReturnPressure": plannedReturnPressure,
      "ExitTime": exitTime,
      "Interval": interval,
      "Index": index,
      "Checks": jsonEncode(checks),
      "CheckTimes": jsonEncode(
        checkTimes,
        toEncodable: (nonEncodable) => nonEncodable is DateTime
            ? nonEncodable.toUtc().toIso8601String()
            : throw UnsupportedError('Cannot convert to JSON: $nonEncodable'),
      ),
      "Working": working,
    };
  }
}

class _SquadPageState extends State<SquadPage>
    with AutomaticKeepAliveClientMixin {
  //Declarations
  final lastCheckStopwatch = Stopwatch();
  final workStartStopwatch = Stopwatch();
  late Timer halfSec;
  late FixedExtentScrollController checkController;
  late FixedExtentScrollController lastCheckController;
  late FixedExtentScrollController secondLastCheckController;
  late FixedExtentScrollController exitMinuteController;
  late FixedExtentScrollController exitSecondsController;

  //Placeholder values, consider using late inits
  //var oxygenValue = 320.0;

  //Base TextStyles to be used for quick formatting (look into themes, maybe there's a better way of doing this)
  var squadTextStyle = const TextStyle(
    fontSize: 22,
  );
  var infoTextStyle = const TextStyle(
    fontSize: 20,
  );
  var varTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  var unitTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  //Base ButtonStyles
  var bottomButtonStyle = const ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(Colors.grey),
    foregroundColor: MaterialStatePropertyAll(Colors.black),
    padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 1.0)),
  );

  //Overrides necessary for functioning
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    checkController = FixedExtentScrollController();
    exitMinuteController = FixedExtentScrollController();
    exitSecondsController = FixedExtentScrollController();
    lastCheckController = FixedExtentScrollController();
    secondLastCheckController = FixedExtentScrollController();
    widget.checks.add(widget.entryPressure);
    halfSec = Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      if (!mounted) return;
      setState(() {
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
    var oxygenValue = Provider.of<SquadModel>(context, listen: false)
        .oxygenValues[widget.index.toString()];
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight =
        MediaQuery.of(GlobalService.navigatorKey.currentContext!)
                .size
                .height -
            MediaQuery.of(GlobalService.navigatorKey.currentContext!)
                .viewPadding
                .vertical;
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
                      Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_pin),
                                      Text("Lokalizacja",
                                          style: squadTextStyle),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.fire_extinguisher),
                                      Text(
                                        "Jacek Jaworek",
                                        style: squadTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.fire_extinguisher),
                                      Text("Jakub Nalepa",
                                          style: squadTextStyle),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.fire_extinguisher),
                                      Text("Janusz Kowalski",
                                          style: squadTextStyle),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                              left: 8,
                              right: 8,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Text("Intensywność",
                                            style: infoTextStyle),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          height: 20,
                                          decoration: BoxDecoration(
                                              color: widget.usageRate * 60 < 10
                                                  ? widget.usageRate * 60 < 5
                                                      ? Colors.blue
                                                      : Colors.yellow
                                                  : Colors.red,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          "Bezp. czas.",
                                          style: infoTextStyle,
                                        ), //TODO: Rozszerzanie zależnie od szerokości kontenera
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Center(
                                            child: Consumer<SquadModel>(
                                                builder: (context, cat, child) {
                                              return Row(
                                                children: [
                                                  Text(
                                                    widget.checks.isNotEmpty
                                                        ? "${cat.getTimeRemaining(widget.index) ~/ 60}:${cat.getTimeRemaining(widget.index) % 60 < 10 ? "0${(cat.getTimeRemaining(widget.index) % 60).toInt()}" : (cat.getTimeRemaining(widget.index) % 60).toInt()}"
                                                        : "NaN",
                                                    style: varTextStyle.apply(
                                                        color: HSVColor.lerp(
                                                                HSVColor.fromColor(
                                                                    Colors
                                                                        .green),
                                                                HSVColor
                                                                    .fromColor(
                                                                        Colors
                                                                            .red),
                                                                1 -
                                                                    (cat.getOxygenRemaining(widget.index) -
                                                                            60) /
                                                                        270)!
                                                            .toColor()),
                                                  ),
                                                  Text("min",
                                                      style: unitTextStyle.apply(
                                                          color: HSVColor.lerp(
                                                                  HSVColor.fromColor(
                                                                      Colors
                                                                          .green),
                                                                  HSVColor.fromColor(
                                                                      Colors
                                                                          .red),
                                                                  1 -
                                                                      (cat.getOxygenRemaining(widget.index) -
                                                                              60) /
                                                                          270)!
                                                              .toColor()))
                                                ],
                                              );
                                            }),
                                          )),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Text("Ostatni pomiar",
                                            style: infoTextStyle),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                            child: Row(
                                          children: [
                                            Text(
                                                "${lastCheckStopwatch.elapsedMilliseconds ~/ 1000 ~/ 60}:${(lastCheckStopwatch.elapsedMilliseconds ~/ 1000 % 60).toInt() < 10 ? "0${(lastCheckStopwatch.elapsedMilliseconds ~/ 1000 % 60).toInt()}" : "${(lastCheckStopwatch.elapsedMilliseconds ~/ 1000 % 60).toInt()}"}",
                                                style: varTextStyle),
                                            Text("min", style: unitTextStyle)
                                          ],
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Text("Punkt pracy",
                                            style: infoTextStyle),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                            child: Row(
                                          children: [
                                            Text(
                                                widget.exitTime == 0
                                                    ? "BRAK"
                                                    : "${widget.exitTime ~/ 60}:${widget.exitTime % 60 < 10 ? "0${(widget.exitTime % 60).toInt()}" : (widget.exitTime % 60).toInt()}",
                                                style: varTextStyle),
                                            Text(
                                                widget.exitTime == 0
                                                    ? ""
                                                    : "min",
                                                style: unitTextStyle)
                                          ],
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0.5,
                                                      horizontal: 3),
                                              decoration: const BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                              child: const Text("BAR",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text("bezp. powrót",
                                                  style: infoTextStyle),
                                            ),
                                          ],
                                        ), //TODO: Rozszerzanie zależnie od szerokości kontenera
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                            child: Row(
                                          children: [
                                            Text(
                                                "${widget.exitTime * 1 ~/ 2 + 60}",
                                                style: varTextStyle),
                                            Text("BAR", style: unitTextStyle)
                                          ],
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0.5,
                                                      horizontal: 3),
                                              decoration: const BoxDecoration(
                                                color: Colors.blueAccent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                              child: const Text("BAR",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Text("zał. wyjście",
                                                  style: infoTextStyle),
                                            ),
                                          ],
                                        ), //TODO: Rozszerzanie zależnie od szerokości kontenera
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                            child: Row(
                                          children: [
                                            Text(
                                                "${(widget.exitTime * widget.usageRate).toInt() + 60}",
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
                          ))
                    ],
                  )),
              Expanded(
                  flex: 32,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.025,
                        horizontal: screenWidth * 0.042),
                    child: Container(
                      height: screenHeight * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.blueGrey.withOpacity(0.8), width: 7),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.red],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: 20,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Text("330", style: varTextStyle),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Text("60", style: varTextStyle),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Center(
                                  child: Text(widget.text,
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.3),
                                          fontSize: 65,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Consumer<SquadModel>(
                                builder: (context, cat, child) {
                                  return Positioned(
                                    top: 20 +
                                        ((constraints.maxHeight - 40) / 270) *
                                            (330 - cat.getOxygenRemaining(widget.index)),
                                    left: 1,
                                    right: 1,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              cat.getOxygenRemaining(widget.index).toInt().toString(),
                                              style: varTextStyle,
                                            ))),
                                  );
                                },
                              ),
                              Positioned(
                                  top: 20 +
                                      ((constraints.maxHeight - 40) / 270) *
                                          (330 - widget.returnPressure),
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
                                  top: 20 +
                                      ((constraints.maxHeight - 40) / 270) *
                                          (330 - widget.plannedReturnPressure),
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
                  )),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5.0),
                      child: ElevatedButton(
                          onPressed: () {
                            if (widget.exitTime == 0) {
                              if (widget.working) {
                                setState(() {
                                  workStartStopwatch.stop();
                                  widget.exitTime =
                                      workStartStopwatch.elapsedMilliseconds ~/
                                          1000;
                                  workStartStopwatch.reset();
                                });
                              } else {
                                widget.working = true;
                                workStartStopwatch.start();
                                lastCheckStopwatch.start();
                                DateTime timestamp = DateTime.now();
                                widget.checkTimes.add(timestamp);
                                Provider.of<SquadModel>(context, listen: false).setWorkTimestamp(widget.index, timestamp);
                              }
                            } else {
                              widget.working =
                                  false; //TODO: Wycofywanie roty i przesuwanie do zakończonych
                            }
                          },
                          style: bottomButtonStyle,
                          child: Center(
                            child: Text(
                              widget.exitTime == 0
                                  ? widget.working
                                      ? "PUNKT PRACY"
                                      : "START PRACY"
                                  : "WYCOFAJ",
                              style: varTextStyle,
                            ),
                          )))),
              Expanded(
                  flex: 60,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            final parse = await checkListDialog(
                                (oxygenValue! ~/ 10) * 10 + 10);
                            if (parse == null) return;
                            final valid = parse.toDouble();
                            setState(() {
                              if (valid < oxygenValue) {
                                widget.entryPressure = valid;
                                DateTime timestamp = DateTime.now();
                                if (widget.checks.isNotEmpty) {
                                  widget.usageRate = (widget.checks.last -
                                          widget.entryPressure) /
                                      (timestamp
                                          .difference(widget.checkTimes.last)
                                          .inSeconds);
                                }
                                Provider.of<SquadModel>(context, listen: false)
                                    .update(
                                        widget.entryPressure,
                                        widget.usageRate,
                                        timestamp,
                                        widget.index);
                                widget.checkTimes.add(timestamp);
                                widget.checks.add(widget.entryPressure);
                                lastCheckStopwatch.reset();
                              }
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
                                  "${widget.entryPressure.toInt()}",
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            var edits = await editChecksDialog();
                            if (edits != null) {
                              widget.checks.last = edits.last;
                              if (widget.checks.length == 1) {
                                Provider.of<SquadModel>(context, listen: false)
                                    .changeStarting(
                                        widget.checks.last, widget.index);
                              } else {
                                widget.checks[widget.checks.length - 2] =
                                    edits.first;
                                recalculateTime();
                              }
                              setState(() {
                                widget.entryPressure = widget.checks.last;
                              });
                            }
                          },
                          style: bottomButtonStyle,
                          child: Center(
                            child: Text("EDYTUJ", style: varTextStyle),
                          )))),
              Expanded(
                  flex: 60,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 5.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            var newExitTime = await exitTimeDialog();
                            if (newExitTime == null) return;
                            setState(() {
                              widget.exitTime = newExitTime;
                            });
                          },
                          style: bottomButtonStyle,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "CZAS WYJŚCIA: ${widget.exitTime ~/ 60}${(widget.exitTime % 60).toInt() == 0 ? "" : ":${(widget.exitTime % 60).toInt() < 10 ? "0${(widget.exitTime % 60).toInt()}" : "${(widget.exitTime % 60).toInt()}"}"}",
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
      ],
    );
  }

  void recalculateTime() {
    var newUsageRate =
        (widget.checks[widget.checks.length - 2] - widget.checks.last) /
            (widget.checkTimes.last
                .difference(widget.checkTimes[widget.checkTimes.length - 2])
                .inSeconds);
    setState(() {
      Provider.of<SquadModel>(context, listen: false).update(
          widget.checks.last,
          newUsageRate,
          widget.checkTimes.last,
          widget.index);
    });
  }

  Future<int?> checkListDialog(double oxygenValue) => showDialog<int>(
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
                          controller: checkController,
                          itemExtent: 50,
                          perspective: 0.005,
                          overAndUnderCenterOpacity: 0.6,
                          squeeze: 1,
                          magnification: 1.1,
                          diameterRatio: 1.5,
                          physics: const FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: (oxygenValue.toInt() - 60) ~/ 10,
                            builder: (context, index) =>
                                Text("${oxygenValue.toInt() - 10 * index}",
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
                              Navigator.of(context).pop(oxygenValue.toInt() -
                                  10 * checkController.selectedItem);
                            },
                            child: const Text("Wprowadź")))
                  ],
                ),
              ),
            ),
          ));

  Future<int?> exitTimeDialog() => showDialog<int>(
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
                        children:[
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
                                controller: exitMinuteController,
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
                                controller: exitSecondsController,
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
                                  15 * exitSecondsController.selectedItem +
                                      60 * exitMinuteController.selectedItem);
                            },
                            child: const Text("Wprowadź")))
                  ],
                ),
              ),
            ),
          ));

  Future<List<double>?> editChecksDialog() => showDialog<List<double>>(
      context: context,
      builder: (context) {
        if (widget.checks.length == 1) {
          WidgetsBinding.instance.addPostFrameCallback((context) =>
              lastCheckController.jumpToItem((330 - widget.checks.last) ~/ 10));
          return Dialog(
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
                          "Popraw początkową wartość",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                      flex: 6,
                      child: ListWheelScrollView.useDelegate(
                          controller: lastCheckController,
                          itemExtent: 50,
                          physics: const FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: (330 - 60) ~/ 10,
                            builder: (context, index) =>
                                Text("${330 - 10 * index}",
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    )),
                          )),
                    ),
                    Expanded(
                        flex: 2,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop([
                                (330 - 10 * lastCheckController.selectedItem)
                                    .toDouble()
                              ]);
                            },
                            child: const Text("Wprowadź")))
                  ],
                ),
              ),
            ),
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((context) =>
              lastCheckController.jumpToItem((330 - widget.checks.last) ~/ 10));
          WidgetsBinding.instance.addPostFrameCallback((context) =>
              secondLastCheckController.jumpToItem(
                  (330 - widget.checks[widget.checks.length - 2]) ~/ 10));
          return Dialog(
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
                          Expanded(
                              flex: 5,
                              child: Text(
                                "Popraw przedostatni pomiar",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )),
                          Expanded(
                              flex: 5,
                              child: Text(
                                "Popraw ostatni pomiar",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: ListWheelScrollView.useDelegate(
                                controller: secondLastCheckController,
                                itemExtent: 50,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: (330 - 60) ~/ 10,
                                  builder: (context, index) =>
                                      Text("${330 - 10 * index}",
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          )),
                                )),
                          ),
                          Expanded(
                            flex: 5,
                            child: ListWheelScrollView.useDelegate(
                                controller: lastCheckController,
                                itemExtent: 50,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: (330 - 60) ~/ 10,
                                  builder: (context, index) =>
                                      Text("${330 - 10 * index}",
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          )),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop([
                                (330 -
                                        10 *
                                            secondLastCheckController
                                                .selectedItem)
                                    .toDouble(),
                                (330 - 10 * lastCheckController.selectedItem)
                                    .toDouble()
                              ]);
                            },
                            child: const Text("Wprowadź")))
                  ],
                ),
              ),
            ),
          );
        }
      });
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
