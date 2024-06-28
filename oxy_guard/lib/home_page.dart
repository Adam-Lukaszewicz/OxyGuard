import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/action/squad_choice.dart';
import 'package:oxy_guard/action_list.dart';
import 'package:oxy_guard/archive_page.dart';
import 'package:oxy_guard/context_windows.dart';
import 'package:oxy_guard/global_service.dart';
import 'package:oxy_guard/login_page.dart';
import 'package:oxy_guard/models/action_model.dart';
import 'package:oxy_guard/models/personnel/worker.dart';
import 'package:oxy_guard/models/squad_model.dart';
import 'package:oxy_guard/personnel/personnel_page.dart';
import 'package:oxy_guard/shift_squad_choice.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.18,
          title: Image.asset(
            'media_files/logo.png',
            fit: BoxFit.scaleDown,
            width: 250,
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          backgroundColor: Theme.of(context).primaryColorLight,
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView(
            children: [
              DrawerHeader(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'media_files/logo.png',
                        fit: BoxFit.scaleDown,
                        width: 120,
                      ),
                      Text(
                        "Ustawienia",
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface, // corrected color property
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShiftSquadChoicePage()
                    ));
                },
                child: const Center(child: Text("Wybór zmiany")),
              ),
              ElevatedButton(
                onPressed: () async {
                  var value = await timeDialog(context, 
                       "wprowadz nowy pomiar");
                  _setTimePeriod(value ?? 0);
                },
                child: Center(
                    child: Text(
                        "Okres pomiarów (${_timePeriod ~/ 60}min, ${_timePeriod % 60}s)")),
              ),
              ElevatedButton(
                onPressed: () async {
                  var value = await checkListDialog(
                      context,  330,  160, "wprowadz nowy pomiar");
                  _setStartingPresssure(value ?? 0);
                },
                child: Center(
                    child: Text("Ciśnienie początkowe ($_startingPressure)")),
              ),
              ElevatedButton(
                onPressed: () async {
                  var value = await checkListDialog(
                      context,  150, 0,"wprowadz nowy pomiar");
                  _setExtremePresssure(value ?? 0);
                },
                child: Center(
                    child: Text("Ciśnienie graniczne ($_extremePressure)")),
              ),
              //Center(child: Text('Licznik: $_counter')),
              //Center(child: Text('czas: $_time')),
              ElevatedButton(
                onPressed: () async {
                  //var value = await timeDialog(context, secondsController, minuteController, "wprowadz nowy pomiar");
                  //_setTime(value!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArchivePage()
                    ),
                  );
                },
                child: const Center(child: Text("Archiwum")),
              ),
              ElevatedButton(
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Center(child: Text("Wyloguj")),
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    ActionModel preparedAction = ActionModel();
                    SquadModel preparedSquad = SquadModel();
                    preparedAction.addSquad(preparedSquad);
                    await SharedPreferences.getInstance().then((prefs){
                      int entryPressure = prefs.getInt("startingPressure") ?? 300;
                      int exitPressure = prefs.getInt("extremePressure") ?? 60;
                      int interval = prefs.getInt("timePeriod") ?? 600;
                      preparedSquad.startSquadWork(entryPressure, exitPressure, interval, "", null, null, null, true);
                      preparedSquad.startSquadWork(entryPressure, exitPressure, interval, "", null, null, null, true);
                      preparedSquad.startSquadWork(entryPressure, exitPressure, interval, "", null, null, null, true);
                      GlobalService.currentAction = preparedAction;
                      GlobalService.currentAction
                        .setActionLocation()
                        .then((none) {
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SquadChoice(quickStart: true,)),
                          );
                    });
                    });
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  style: ButtonStyle(
                    maximumSize: MaterialStateProperty.all(Size(
                        MediaQuery.of(context).size.width * 0.7,
                        double.infinity)),
                  ),
                  child: const Center(
                      child: Text(
                    "Szybki start",
                    style: TextStyle(
                      fontSize: 27,
                      height: 4,
                    ),
                  ))),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ActionList()),
                    );
                  },
                  style: ButtonStyle(
                    maximumSize: MaterialStateProperty.all(Size(
                        MediaQuery.of(context).size.width * 0.7,
                        double.infinity)),
                  ),
                  child: const Center(
                      child: Text(
                    "Dołącz do akcji",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ))),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    GlobalService.currentAction = ActionModel();
                    GlobalService.currentAction
                        .setActionLocation()
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
                    maximumSize: MaterialStateProperty.all(Size(
                        MediaQuery.of(context).size.width * 0.7,
                        double.infinity)),
                  ),
                  child: const Center(
                      child: Text(
                    "Stwórz akcję",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ))),
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
}
