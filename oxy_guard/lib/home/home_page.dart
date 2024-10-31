import 'package:flutter/material.dart';
import 'package:oxy_guard/action/squad_choice.dart';
import 'package:oxy_guard/home/sub/action_list.dart';
import 'package:oxy_guard/context_windows.dart';
import 'package:oxy_guard/services/global_service.dart';
import 'package:oxy_guard/models/action_model.dart';
import 'package:oxy_guard/models/squad_model.dart';
import 'package:oxy_guard/extras/extras_page.dart';
import 'package:oxy_guard/settings/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:real_volume/real_volume.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _extremePressure = 0;
  int _startingPressure = 0;
  int _timePeriod = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkAndRequestPermission();
    checkVolumeStatus();
    _loadExtremePresssure();
    _loadStartingPresssure();
    _loadTimePeriod();
  }

  Future<void> _loadExtremePresssure() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _extremePressure = (prefs.getInt('extremePressure') ?? 0);
    });
  }

  Future<void> _loadTimePeriod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _timePeriod = (prefs.getInt('timePeriod') ?? 0);
    });
  }

  Future<void> _loadStartingPresssure() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _startingPressure = (prefs.getInt('startingPressure') ?? 0);
    });
  }

  Future<void> _setExtremePresssure(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _extremePressure = value;
      prefs.setInt('extremePressure', value);
    });
  }

  Future<void> _setTimePeriod(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _timePeriod = value;
      prefs.setInt('timePeriod', value);
    });
  }

  Future<void> _setStartingPresssure(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _startingPressure = value;
      prefs.setInt('startingPressure', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar:
            AppBar(centerTitle: true, backgroundColor: Theme.of(context).colorScheme.surface),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Image.asset(
                'media_files/logo_no_fire.png',
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        ActionModel preparedAction = ActionModel();
                        SquadModel preparedSquad = SquadModel();
                        preparedAction.addSquad(preparedSquad);
                        await SharedPreferences.getInstance().then((prefs) {
                          int entryPressure =
                              prefs.getInt("startingPressure") ?? 300;
                          int exitPressure =
                              prefs.getInt("extremePressure") ?? 60;
                          int interval = prefs.getInt("timePeriod") ?? 600;
                          preparedSquad.startSquadWork(
                              entryPressure,
                              exitPressure,
                              interval,
                              "",
                              null,
                              null,
                              null,
                              true);
                          preparedSquad.startSquadWork(
                              entryPressure,
                              exitPressure,
                              interval,
                              "",
                              null,
                              null,
                              null,
                              true);
                          preparedSquad.startSquadWork(
                              entryPressure,
                              exitPressure,
                              interval,
                              "",
                              null,
                              null,
                              null,
                              true);
                          GlobalService.currentAction = preparedAction;
                          GlobalService.currentAction
                              .setActionLocation(context)
                              .then((none) {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SquadChoice(
                                        quickStart: true,
                                      )),
                            );
                          });
                        });
                        setState(() {
                          _isLoading = true;
                        });
                      },
                      style: ButtonStyle(
                          fixedSize: WidgetStateProperty.all(Size(
                              MediaQuery.of(context).size.width * 0.7,
                              MediaQuery.of(context).size.height * 0.1)),
                          elevation: WidgetStateProperty.all(5),
                          shape: WidgetStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  side: BorderSide(width: 0.1))),
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).primaryColorDark)),
                      child: Center(
                          child: Text(
                        "Szybki start",
                        style: TextStyle(
                            fontSize: 27,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ))),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ActionList()),
                        );
                      },
                      style: ButtonStyle(
                        fixedSize: WidgetStateProperty.all(Size(
                            MediaQuery.of(context).size.width * 0.7,
                            MediaQuery.of(context).size.height * 0.07)),
                        shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                side: BorderSide(width: 0.1))),
                        elevation: const WidgetStatePropertyAll(5),
                        backgroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                      ),
                      child: Center(
                          child: Text(
                        "Dołącz do akcji",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColorDark),
                      ))),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  ElevatedButton(
                      onPressed: () {
                        GlobalService.currentAction = ActionModel();
                        GlobalService.currentAction
                            .setActionLocation(context)
                            .then((none) {
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SquadChoice()),
                          );
                        });
                        setState(() {
                          _isLoading = true;
                        });
                      },
                      style: ButtonStyle(
                          fixedSize: WidgetStateProperty.all(Size(
                              MediaQuery.of(context).size.width * 0.7,
                              MediaQuery.of(context).size.height * 0.07)),
                          shape: WidgetStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  side: BorderSide(width: 0.1))),
                          backgroundColor:
                              const WidgetStatePropertyAll(Colors.white),
                          elevation: const WidgetStatePropertyAll(5)),
                      child: Center(
                          child: Text(
                        "Stwórz akcję",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColorDark),
                      ))),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ExtrasPage()));
                          },
                          style: ButtonStyle(
                              fixedSize: WidgetStateProperty.all(Size(
                                  MediaQuery.of(context).size.width * 0.325,
                                  MediaQuery.of(context).size.height * 0.07)),
                              shape: WidgetStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      side: BorderSide(width: 0.1))),
                              backgroundColor:
                                  const WidgetStatePropertyAll(Colors.white),
                              elevation: const WidgetStatePropertyAll(5)),
                          child: Center(
                              child: Text(
                            "Dodatkowe",
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).primaryColorDark),
                          ))),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage()));
                          },                         
                          style: ButtonStyle(
                              fixedSize: WidgetStateProperty.all(Size(
                                  MediaQuery.of(context).size.width * 0.325,
                                  MediaQuery.of(context).size.height * 0.07)),
                              shape: WidgetStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      side: BorderSide(width: 0.1))),
                              backgroundColor:
                                  const WidgetStatePropertyAll(Colors.white),
                              elevation: const WidgetStatePropertyAll(5)),
                          child: Center(
                              child: Text(
                            "Ustawienia",
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).primaryColorDark),
                          ))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      if (_isLoading)
        const Opacity(
          opacity: 0.8,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
      if (_isLoading)
        const Center(
          child: CircularProgressIndicator(),
        ),
    ]);
  }

  void checkAndRequestPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      await Permission.locationWhenInUse.request();
    }
    status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  void checkVolumeStatus() async {
    double volume = await VolumeController().getVolume();
    if (volume < 0.4) {
      warningDialog(context,
          "Poziom głośności multimediów jest poniżej 40%.\nWażne powiadomienia mogą być niesłyszalne!");
    }
    double notificationVolume =
        (await RealVolume.getCurrentVol(StreamType.NOTIFICATION)) ?? 0.0;
    if (notificationVolume < 0.4) {
      warningDialog(context,
          "Poziom głośności powiadomień jest poniżej 40%.\nWażne powiadomienia mogą być niesłyszalne!");
    }
    double ringVolume =
        (await RealVolume.getCurrentVol(StreamType.RING)) ?? 0.0;
    if (ringVolume < 0.4) {
      warningDialog(context,
          "Poziom głośności dzwonka jest poniżej 40%.\nWażne powiadomienia mogą być niesłyszalne!");
    }
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      warningDialog(context,
          "Brak uprawnień do lokalizacji.\nFunkcjonalnoś aplikacji jest ograniczona!");
    }
    status = await Permission.notification.status;
    if (status.isDenied) {
      warningDialog(context,
          "Brak uprawnień do wyświetlania powiadomień.\nFunkcjonalnoś aplikacji jest ograniczona!");
    }
  }
}
