import 'package:OxyGuard/legacy/action/squad_choice.dart';
import 'package:OxyGuard/context_windows.dart';
import 'package:OxyGuard/extra/view/extras_page.dart';
import 'package:OxyGuard/legacy/home/sub/action_list.dart';
import 'package:OxyGuard/legacy/models/action_model.dart';
import 'package:OxyGuard/legacy/models/squad_model.dart';
import 'package:OxyGuard/legacy/services/database_service.dart';
import 'package:OxyGuard/legacy/services/internet_serivce.dart';
import 'package:OxyGuard/legacy/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:real_volume/real_volume.dart';
import 'package:watch_it/watch_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //checkOfflineActions();
    //checkAndRequestPermission();
    //checkVolumeStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: ElevatedButton(
                        onPressed: () async {
                          /*ActionModel preparedAction = ActionModel();
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
                            dbService.currentAction = preparedAction;
                            if (context.mounted) {
                              dbService.currentAction
                                  .setActionLocation(context)
                                  .then((none) {
                                setState(() {
                                  _isLoading = false;
                                });
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SquadChoice(
                                              quickStart: true,
                                            )),
                                  );
                                }
                              });
                            }
                          });
                          setState(() {
                            _isLoading = true;
                          });
                          */
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xff1874d4)),
                        child: const Center(
                            child: Text(
                          "Szybki start",
                          style: TextStyle(
                            fontSize: 27,
                          ),
                        ))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ActionList()),
                          );
                        },
                        child: const Center(
                            child: Text(
                          "Dołącz do akcji",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                        onPressed: () {
                          /*
                          dbService.currentAction = ActionModel();
                          dbService.currentAction
                              .setActionLocation(context)
                              .then((none) {
                            setState(() {
                              _isLoading = false;
                            });
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SquadChoice()),
                              );
                            }
                          });
                          setState(() {
                            _isLoading = true;
                          });
                          */
                        },
                        child: const Center(
                            child: Text(
                          "Stwórz akcję",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.325,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ExtrasPage()));
                              },
                              child: const Center(
                                  child: Text(
                                "Dodatkowe",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ))),
                        ),
                      ]),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.325,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingsPage()));
                            },
                            child: const Center(
                                child: Text(
                              "Ustawienia",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ))),
                      ),
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

  /*void checkOfflineActions() async {
    var dbService = GetIt.I.get<DatabaseService>();
    if (await dbService.checkOfflineData()) {
      bool? result;
      if (mounted) {
        result = await showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Wykryto lokalne dane"),
                content: const Text(
                    "Czy chcesz zapisać je w bazie danych? W przeciwnym wypadku zostaną usunięte"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Tak")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("Nie")),
                ],
              );
            });
      }
      if (result != null) {
        if (result) {
          dbService.uploadOfflineData();
        } else {
          dbService.deleteOfflineData();
        }
      }
    }
  }*/

  void checkVolumeStatus() async {
    double volume = await VolumeController().getVolume();
    if (volume < 0.4) {
      if (mounted) {
        warningDialog(context,
            "Poziom głośności multimediów jest poniżej 40%.\nWażne powiadomienia mogą być niesłyszalne!");
      }
    }
    double notificationVolume =
        (await RealVolume.getCurrentVol(StreamType.NOTIFICATION)) ?? 0.0;
    if (notificationVolume < 0.4) {
      if (mounted) {
        warningDialog(context,
            "Poziom głośności powiadomień jest poniżej 40%.\nWażne powiadomienia mogą być niesłyszalne!");
      }
    }
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      if (mounted) {
        warningDialog(context,
            "Brak uprawnień do lokalizacji.\nFunkcjonalnoś aplikacji jest ograniczona!");
      }
    }
    status = await Permission.notification.status;
    if (status.isDenied) {
      if (mounted) {
        warningDialog(context,
            "Brak uprawnień do wyświetlania powiadomień.\nFunkcjonalnoś aplikacji jest ograniczona!");
      }
    }
  }
}
