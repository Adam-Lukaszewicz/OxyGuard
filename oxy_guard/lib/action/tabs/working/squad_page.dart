import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oxy_guard/models/personnel/worker.dart';
import 'package:provider/provider.dart';
import 'package:oxy_guard/context_windows.dart';

import '../../../models/squad_model.dart';
import '../../../global_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:oxy_guard/notification.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
  String localization;
  Worker? firstPerson, secondPerson, thirdPerson;
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
      bool? working,
      required this.localization,
      this.firstPerson,
      this.secondPerson,
      this.thirdPerson})
      : exitTime = exitTime ?? 0,
        usageRate = usageRate ?? 10.0 / 60.0,
        returnPressure = returnPressure ?? exitPressure.toDouble(),
        plannedReturnPressure = plannedReturnPressure ?? exitPressure.toDouble(),
        checks = checks ?? <double>[entryPressure],
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
          localization: json["Localization"]! as String,
          firstPerson: jsonDecode(json["FirstPerson"]) != null ? Worker.fromJson(jsonDecode(json["FirstPerson"])) : null,
          secondPerson: jsonDecode(json["SecondPerson"]) != null ? Worker.fromJson(jsonDecode(json["SecondPerson"])) : null,
          thirdPerson: jsonDecode(json["ThirdPerson"]) != null ? Worker.fromJson(jsonDecode(json["ThirdPerson"])) : null,


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
    String localization = "",
    Worker? firstPerson,
    Worker? secondPerson,
    Worker? thirdPerson,
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
        working: working ?? this.working,
        localization: localization,
        firstPerson: firstPerson ?? this.firstPerson,
        secondPerson: secondPerson ?? this.secondPerson,
        thirdPerson: thirdPerson ?? this.thirdPerson);
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
      "Localization": localization,
      "FirstPerson": jsonEncode(firstPerson),
      "SecondPerson": jsonEncode(secondPerson),
      "ThirdPerson": jsonEncode(thirdPerson),
    };
  }
}

class _SquadPageState extends State<SquadPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver{
  //Declarations
  DateTime? lastCheckAllert;
  DateTime? lastExitAllert;
  late Timer halfSec;
  late FixedExtentScrollController checkController;
  late FixedExtentScrollController lastCheckController;
  late FixedExtentScrollController secondLastCheckController;
  late FixedExtentScrollController exitMinuteController;
  late FixedExtentScrollController exitSecondsController;
  DateTime? lastCheck;
  int entryPressureLabel = 0;
  double _usageRate = 0.0;
  double _returnPressure =0;
  AudioPlayer _audioPlayer= AudioPlayer();
  bool _isInForeground = true;
  bool isCheckAllertInactive = true;
  bool isExitAllertInactive = true;

 @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
  }




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
    backgroundColor: WidgetStatePropertyAll(Colors.grey),
    foregroundColor: WidgetStatePropertyAll(Colors.black),
    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 1.0)),
  );

  //Overrides necessary for functioning
  @override
  bool get wantKeepAlive => true;

@override
void didUpdateWidget(covariant SquadPage oldWidget) {
  super.didUpdateWidget(oldWidget);
  
  if (widget.usageRate != _usageRate) {
    setState(() {
      _usageRate = widget.usageRate;
      
      if (widget.usageRate * 60 > 10) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if(!_isInForeground)
          {
            Noti.showBigTextNotification(title: "Przypomnienie", 
            body: "Obecne zużycie jest bardzo duże. Upewnij się czy wprowadziłeś poprawny pomiar!!!" , 
            fln: _flutterLocalNotificationsPlugin);
          }
          _audioPlayer.setAsset('media_files/not.mp3');
          _audioPlayer.play();
          warningDialog(context, "Obecne zużycie jest bardzo duże. Upewnij się czy wprowadziłeś poprawny pomiar!!!");
        });
      }
    });
  }
}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Noti.initialize(_flutterLocalNotificationsPlugin);
    _usageRate = widget.usageRate;
    entryPressureLabel = widget.entryPressure.toInt();
    lastCheck = widget.checkTimes.isEmpty ? null : widget.checkTimes.last;
    checkController = FixedExtentScrollController();
    exitMinuteController = FixedExtentScrollController();
    exitSecondsController = FixedExtentScrollController();
    lastCheckController = FixedExtentScrollController();
    secondLastCheckController = FixedExtentScrollController();
    halfSec = Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      if (!mounted) return;
      setState((){
            _checkPressureAndNotify();
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
      _returnPressure =(widget.exitTime * 1 ~/ 2 + widget.exitPressure).toDouble();
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
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_pin),
                                      widget.localization.isEmpty
                                          ? Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: ()async {
                                                        if(!_isInForeground)
                                                        {
                                                        Noti.showBigTextNotification(title: "Przypomnienie", body: "wprowadź ciśnienie", fln: _flutterLocalNotificationsPlugin);
                                                        }
                                                        var selectedItem = await selectFromList(context, ['piwnica', 'parter', 'pierwsze piętro', 'drugie piętro', 'poddasze', 'garaż', 'inne']);
                                                        setState(() {
                                                          widget.localization = selectedItem ?? "";
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                        minimumSize: WidgetStatePropertyAll(Size(
                                                          MediaQuery.of(context).size.width * 0.58,
                                                          45,
                                                        ),),
                                                        shape: WidgetStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                          ),
                                                        ),
                                                      ),
                                                      
                                                      child: const Center(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              "Wprowadź lokalizację",
                                                            ),
                                                            Icon(Icons.keyboard_arrow_down),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                            )
                                          : Text(
                                              widget.localization,
                                              style: squadTextStyle,
                                            ),
                                    ],
                                ),),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.fire_extinguisher),
                                      widget.firstPerson==null
                                          ? Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: ()async {
                                                        var selectedItem = await selectWorkerFromList(context);
                                                        setState(() {
                                                          widget.firstPerson = selectedItem;
                                                          Provider.of<SquadModel>(context, listen: false).update();
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                        minimumSize: WidgetStatePropertyAll(Size(
                                                          MediaQuery.of(context).size.width * 0.58,
                                                          45,
                                                        ),),
                                                        shape: WidgetStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                          ),
                                                        ),
                                                      ),
                                                      
                                                      child: const Center(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              "Wprowadź imię",
                                                            ),
                                                            Icon(Icons.keyboard_arrow_down),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                            )
                                          : Text(
                                              widget.firstPerson != null ? '${widget.firstPerson!.name} ${widget.firstPerson!.surname}' : 'Wprowadź imię',
                                              style: squadTextStyle,
                                            ),
                                    ],
                                ),),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.fire_extinguisher),
                                      widget.secondPerson==null
                                          ? Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: ()async {
                                                        var selectedItem = await selectWorkerFromList(context);
                                                        setState(() {
                                                          widget.secondPerson = selectedItem;
                                                          Provider.of<SquadModel>(context, listen: false).update();
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                        minimumSize: WidgetStatePropertyAll(Size(
                                                          MediaQuery.of(context).size.width * 0.58,
                                                          45,
                                                        ),),
                                                        shape: WidgetStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                          ),
                                                        ),
                                                      ),
                                                      
                                                      child: const Center(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              "Wprowadź imię",
                                                            ),
                                                            Icon(Icons.keyboard_arrow_down),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                            )
                                          : Text(
                                              widget.secondPerson != null ? '${widget.secondPerson!.name} ${widget.secondPerson!.surname}' : 'Wprowadź imię',
                                              style: squadTextStyle,
                                            ),
                                    ],
                                ),),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      widget.thirdPerson!=null
                                        ? Expanded(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.fire_extinguisher),
                                                Text(
                                                    '${widget.firstPerson!=null?widget.firstPerson!.name:""} ${widget.firstPerson!.surname}',
                                                    style: squadTextStyle,
                                                )
                                            ],
                                          ),)
                                        : Container()
                                    ],
                                ),),
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
                                            lastCheck == null ? Text("0:00", style: varTextStyle,) : Text(
                                                "${DateTime.now().difference(lastCheck!).inMinutes}:${DateTime.now().difference(lastCheck!).inSeconds % 60 < 10 ? "0${DateTime.now().difference(lastCheck!).inSeconds % 60}" : "${DateTime.now().difference(lastCheck!).inSeconds % 60}"}",
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
                                                "${_returnPressure.toInt()}",
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
                                                "${(widget.exitTime * widget.usageRate).toInt() + widget.exitPressure}",
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
                                  child: Text(entryPressureLabel.toString(), style: varTextStyle),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Text(widget.exitPressure.toString(), style: varTextStyle),
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
                                    top: cat.getOxygenRemaining(widget.index) >= widget.exitPressure ?
                                     14 + ((constraints.maxHeight - 69)/(widget.checks.first - widget.exitPressure) * (widget.checks.first - cat.getOxygenRemaining(widget.index)))
                                      : 14 + ((constraints.maxHeight - 69)/(widget.checks.first - widget.exitPressure) * (widget.checks.first - widget.exitPressure)),
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
                                              cat.getOxygenRemaining(widget.index) >= 0 ?
                                              cat.getOxygenRemaining(widget.index).toInt().toString():
                                              "0",
                                              style: varTextStyle,
                                            ))),
                                  );
                                },
                              ),
                              Positioned(
                                  top: 24.5 + ((constraints.maxHeight - 69)/(widget.checks.first - widget.exitPressure) * (widget.checks.first - (_returnPressure<widget.checks.first?_returnPressure:widget.checks.first))),
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
                                  top: 24.5 + ((constraints.maxHeight - 69)/(widget.checks.first - widget.exitPressure) * (widget.checks.first - (((widget.exitTime * widget.usageRate).toInt() + widget.exitPressure)<widget.checks.first
                                  ?((widget.exitTime * widget.usageRate).toInt() + widget.exitPressure)
                                  :widget.checks.first))),
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
                            if(!widget.working){
                              setState(() {
                                widget.working = true;
                                DateTime timestamp = DateTime.now();
                                widget.checkTimes.add(timestamp);
                                Provider.of<SquadModel>(context, listen: false).setWorkTimestamp(widget.index, timestamp);
                                lastCheck = timestamp;
                              });
                            }else if(widget.exitTime == 0){
                              setState(() {
                                widget.exitTime = DateTime.now().difference(widget.checkTimes.first).inSeconds;
                                GlobalService.currentAction.update();
                              });
                            }else{
                              setState(() {
                                widget.working = false;
                                Provider.of<SquadModel>(context, listen: false).endSquadWork(widget.index);
                              });
                            }
                          },
                          style: bottomButtonStyle,
                          child: Center(
                            child: Text(
                              !widget.working ?
                                "START PRACY" :
                                widget.exitTime == 0 ?
                                  "PUNKT PRACY" :
                                  "WYCOFAJ",
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
                            if(!widget.working){
                              await warningDialog(context, "Nie można wprowadzać nowych pomiarów przed rozpoczęciem pracy");
                              return;
                            }
                            final parse = await checkListDialog(context, 
                                (oxygenValue! ~/ 10 - 1) * 10, 0,
                                "Wprowadź nowy pomiar");
                            if (parse == null) return;
                            final valid = parse.toDouble();
                            setState(() {
                              //if (valid < oxygenValue) { //ten if nie ma sensu bo zmieniłem menu wyboru tlenu - teraz nie da się wprowadzić większego pomiaru :D
                                //widget.entryPressure = valid;//to jest jakiś dzikie - przypisywanie ostatniego pomiaru do entryPressure. Zostawiam komentaż bo obstawiam że takie podejście miało swoje źródło
                                DateTime timestamp = DateTime.now();
                                if (widget.checks.isNotEmpty) { 
                                  widget.usageRate = (widget.checks.last -
                                          valid) /
                                      (timestamp
                                          .difference(widget.checkTimes.last)
                                          .inSeconds);
                                }
                                
                                widget.checkTimes.add(timestamp);
                                widget.checks.add(valid);
                                Provider.of<SquadModel>(context, listen: false)
                                  .addCheck(
                                      valid,
                                      widget.usageRate,
                                      timestamp,
                                      widget.index
                                  );
                                lastCheck = timestamp;
                              //}
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
                                  "${widget.checks.last.toInt()}",
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
                              setState(() {
                                if (widget.checks.length == 1) {
                                  Provider.of<SquadModel>(context, listen: false).changeStarting(widget.checks.first, widget.index);
                                  entryPressureLabel = edits.first.toInt();
                                  widget.checks.first = edits.first;
                                } 
                                else {
                                  if(widget.checks.length==2)
                                  {
                                      entryPressureLabel = edits.first.toInt();
                                  }
                                  widget.checks[widget.checks.length - 2] = edits.first;
                                  widget.checks[widget.checks.length - 1] = edits.last;
                                  recalculateTime();
                                  //widget.entryPressure = widget.checks.last;
                                  DateTime timestamp = DateTime.now();
                                  widget.usageRate = (widget.checks[widget.checks.length - 2] - widget.checks[widget.checks.length - 1]) / (timestamp.difference(widget.checkTimes.last).inSeconds);
                                  GlobalService.currentAction.update();
                                }
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
                            var newExitTime = await timeDialog(context,  "Wprowadź czas wyjścia");
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
      Provider.of<SquadModel>(context, listen: false).addCheck(
          widget.checks.last,
          newUsageRate,
          widget.checkTimes.last,
          widget.index);
    });
  }


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
                          perspective: 0.005,
                          overAndUnderCenterOpacity: 0.6,
                          squeeze: 1,
                          magnification: 1.1,
                          diameterRatio: 1.5,
                          physics: const FixedExtentScrollPhysics(),
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: (330 - 150) ~/ 10,
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
              lastCheckController.jumpToItem((widget.checks[widget.checks.length-2] - widget.checks.last-10) ~/ 10));
          WidgetsBinding.instance.addPostFrameCallback((context) =>
              secondLastCheckController.jumpToItem(((widget.checks.length<3?330:widget.checks[widget.checks.length-3].toInt()) - widget.checks[widget.checks.length - 2]) ~/ 10));
          return Dialog(
            child: SizedBox(
              height: 500,
              width: 600,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              "Popraw przedostatni pomiar (${widget.checks[widget.checks.length-2].toInt()})",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              "Popraw ostatni pomiar (${widget.checks.last.toInt()})",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center, 
                            ),
                          ),
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
                                perspective: 0.005,
                                overAndUnderCenterOpacity: 0.6,
                                squeeze: 1,
                                magnification: 1.1,
                                diameterRatio: 1.5,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: ((widget.checks.length<3?330:(widget.checks[widget.checks.length-3]))-widget.checks.last) ~/ 10,
                                  builder: (context, index) =>
                                      Text("${(widget.checks.length<3?330:widget.checks[widget.checks.length-3].toInt()) - 10 * index}",
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
                                perspective: 0.005,
                                overAndUnderCenterOpacity: 0.6,
                                squeeze: 1,
                                magnification: 1.1,
                                diameterRatio: 1.5,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: widget.checks[widget.checks.length-2] ~/ 10,
                                  builder: (context, index) =>
                                      Text("${(widget.checks[widget.checks.length-2]-10).toInt() - 10 * index}",
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
                              if(((widget.checks.length<3?330:widget.checks[widget.checks.length-3].toInt()) - 10 *secondLastCheckController.selectedItem)  >
                                (widget.checks[widget.checks.length-2]-10 - 10 * lastCheckController.selectedItem)){
                                  
                                  Navigator.of(context).pop([
                                    ((widget.checks.length<3?330:widget.checks[widget.checks.length-3].toInt()) - 10 *secondLastCheckController.selectedItem)
                                        .toDouble(),
                                    (widget.checks[widget.checks.length-2]-10 - 10 * lastCheckController.selectedItem)
                                        .toDouble()
                                  ]);
                              }
                              else{
                                warningDialog(context, "Wartość przedostatniego pomiaru musi być większość niż ostatniego pomiaru!");
                              }
                            },
                            child: const Text("Wprowadź")))
                  ],
                ),
              ),
            ),
          );
        }
      });


void  _checkPressureAndNotify() async{
  
  if( lastCheck != null ){//zamiast 10 powinno być widget.interval                        //zamiast 10 powinno być ok 40s
    if ( (DateTime.now().difference(lastCheck!).inSeconds > widget.interval  )& ((lastCheckAllert==null)? true: DateTime.now().difference(lastCheckAllert!).inSeconds > 40))
    {  
      lastCheckAllert = DateTime.now();
      if(!_isInForeground)
      {
        Noti.showBigTextNotification(title: "Przypomnienie", 
        body: "Wprowadź nowy pomiar ciśnienia dla roty ${widget.text}" , 
        fln: _flutterLocalNotificationsPlugin);
      }
      _audioPlayer.setAsset('media_files/not.mp3');
      await _audioPlayer.play();
      if(isCheckAllertInactive){
        isCheckAllertInactive = false;    
        isCheckAllertInactive = await warningDialog(context, "Wprowadź nowy pomiar ciśnienia dla roty ${widget.text}")??false;
      }
      
    }
  }
  if (widget.checks.isNotEmpty)
  {
    if((((widget.exitTime * widget.usageRate).toInt() + widget.exitPressure)>widget.checks.last )& ((lastExitAllert==null)? true: DateTime.now().difference(lastExitAllert!).inSeconds > 40))
    {
      lastExitAllert = DateTime.now();
      if(!_isInForeground)
      {
        Noti.showBigTextNotification(title: "Przypomnienie", 
        body: "Ilość powietrza w butli jest poniżej bezpiecznego progu. Rozpocznij powrót z strefy działań roty ${widget.text}" , 
        fln: _flutterLocalNotificationsPlugin);
      }
      _audioPlayer.setAsset('media_files/not.mp3');
      await _audioPlayer.play();
      if(isExitAllertInactive){
        isExitAllertInactive = false;   
        isExitAllertInactive = await warningDialog(context, "Ilość powietrza w butli jest poniżej bezpiecznego progu. Rozpocznij powrót z strefy działań roty ${widget.text}")??false;
      }
      
    }
  }
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
