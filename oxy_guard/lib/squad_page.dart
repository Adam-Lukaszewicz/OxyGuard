import 'dart:async';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:oxy_guard/manage_page.dart';
import 'package:provider/provider.dart';

class SquadPage extends StatefulWidget {
  var usageRate = 10.0 / 60.0;
  double entryPressure;
  int exitPressure;
  String text = "R";
  var returnPressure = 100.0;
  var plannedReturnPressure = 120.0;
  var exitTime = 0;
  final int interval;
  final int index;
  SquadPage(
      {super.key,
      required this.interval,
      required this.index,
      required this.entryPressure,
      required this.exitPressure,
      required this.text});

  @override
  State<SquadPage> createState() => _SquadPageState();
}

class _SquadPageState extends State<SquadPage>
    with AutomaticKeepAliveClientMixin {
  //Declarations
  bool working = false;
  final lastCheckStopwatch =
      Stopwatch(); //TODO: Wynieść stopwatch każdej roty nad stan pojedynczego widgetu (zmiana zakladki nie spowoduje zerowania stopwatcha)
  final workStartStopwatch = Stopwatch();
  var checks =
      <double>[]; //TODO: Wynieść te tablicę ponad, żeby nie traciła się przy zmianie zakładki
  late Timer oneSec;
  late FixedExtentScrollController checkController;
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
    checks.add(widget.entryPressure);
    oneSec = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!mounted) return;
      setState(() {
        if (working){
          Provider.of<CategoryModel>(context, listen: false)
              .advanceTime(widget.index);
        }
      });
    });
  }

  @override
  void dispose() {
    checkController.dispose();
    exitMinuteController.dispose();
    exitSecondsController.dispose();
    super.dispose();
  }

  //UI
  @override
  Widget build(BuildContext context) {
    var oxygenValue = Provider.of<CategoryModel>(context, listen: false)
        .oxygenValues[widget.index];
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
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
                                            child: Row(
                                          children: [
                                            Consumer<CategoryModel>(
                                                builder: (context, cat, child) {
                                              return Text(
                                                checks.length >= 2 ? "${cat.remainingTimes[widget.index] ~/ 60}:${cat.remainingTimes[widget.index] % 60 < 10 ? "0${(cat.remainingTimes[widget.index] % 60).toInt()}" : (cat.remainingTimes[widget.index] % 60).toInt()}" : "NaN",
                                                style: varTextStyle.apply(
                                                    color: HSVColor.lerp(
                                                            HSVColor.fromColor(
                                                                Colors.green),
                                                            HSVColor.fromColor(
                                                                Colors.red),
                                                            1 -
                                                                (cat.oxygenValues[
                                                                            widget.index] -
                                                                        60) /
                                                                    270)!
                                                        .toColor()),
                                              );
                                            }),
                                            Text("min",
                                                style: unitTextStyle.apply(
                                                    color: HSVColor.lerp(
                                                            HSVColor.fromColor(
                                                                Colors.green),
                                                            HSVColor.fromColor(
                                                                Colors.red),
                                                            1 -
                                                                (oxygenValue -
                                                                        60) /
                                                                    270)!
                                                        .toColor()))
                                          ],
                                        )),
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
                                                widget.exitTime == 0 ? "BRAK" : "${widget.exitTime ~/ 60}:${widget.exitTime % 60 < 10 ? "0${(widget.exitTime % 60).toInt()}" : (widget.exitTime % 60).toInt()}",
                                                style: varTextStyle),
                                            Text(
                                                widget.exitTime == 0 ? "" : "min",
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
                              Positioned(
                                top: 20 +
                                    ((constraints.maxHeight - 40) / 270) *
                                        (330 - oxygenValue),
                                left: 1,
                                right: 1,
                                child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          oxygenValue.toInt().toString(),
                                          style: varTextStyle,
                                        ))),
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
                              if (working) {
                                setState(() {
                                  workStartStopwatch.stop();
                                  widget.exitTime =
                                      workStartStopwatch.elapsedMilliseconds ~/
                                          1000;
                                  workStartStopwatch.reset();
                                });
                              } else {
                                working = true;
                                workStartStopwatch.start();
                                lastCheckStopwatch.start();
                              }
                            } else {
                              working =
                                  false; //TODO: Wycofywanie roty i przesuwanie do zakończonych
                            }
                          },
                          style: bottomButtonStyle,
                          child: Center(
                            child: Text(
                              widget.exitTime == 0
                                  ? working
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
                            final parse = await checkListDialog(oxygenValue);
                            if (parse == null) return;
                            final valid = parse.toDouble();
                            setState(() {
                              if (valid < oxygenValue) {
                                widget.entryPressure = valid;
                                if (checks.isNotEmpty) {
                                  widget.usageRate = (checks.last -
                                          widget.entryPressure) /
                                      (lastCheckStopwatch.elapsedMilliseconds /
                                          1000);
                                }
                                Provider.of<CategoryModel>(context,
                                        listen: false)
                                    .update(widget.entryPressure,
                                        widget.usageRate, widget.index);
                                checks.add(widget.entryPressure);
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
                                //TODO: musi być lepszy sposób niż takie chainowanie Textów, musi.
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
                          onPressed: () {},
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
                          physics: const FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: (oxygenValue.toInt() - 60) ~/ 10,
                            builder: (context, index) =>
                                Text("${oxygenValue.toInt() - 10 * index}",
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
                        child: Text(
                          "Wprowadź czas wyjścia",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
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
