import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oxy_guard/action/squad_choice.dart';
import 'package:oxy_guard/action_list.dart';
import 'package:oxy_guard/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oxy_guard/context_windows.dart';

import 'global_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
  GlobalService.checkGPSPermission();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: GlobalService.navigatorKey,
      title: 'OxyGuard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FixedExtentScrollController secondsController;
  late FixedExtentScrollController minuteController;
int _extremePressure = 0;
int _startingPressure = 0;
int _timePeriod = 0;

  @override
  void initState() {
    super.initState();
    _loadExtremePresssure();
    _loadStartingPresssure();
    _loadTimePeriod();
    secondsController = FixedExtentScrollController();
    minuteController = FixedExtentScrollController();
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
      _extremePressure=value;
      prefs.setInt('extremePressure', value);
    });
  }
  Future<void> _setTimePeriod(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _timePeriod=value;
      prefs.setInt('timePeriod', value );
    });
  }
    Future<void> _setStartingPresssure(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _startingPressure=value;
      prefs.setInt('startingPressure', value);
    });
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height*0.18,
        title: Image.asset('media_files/logo.png', fit: BoxFit.scaleDown, width: 250,),
        centerTitle: true,
      ),
      drawer: Drawer(
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
                            color: Theme.of(context).colorScheme.onSurface, // corrected color property
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
                            builder: (context) => Placeholder(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2-50), // Dodaj padding od góry
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Center(
                                        child: Text(
                                          "powrót",
                                          style: TextStyle(
                                            fontSize: 20,
                                            height: 5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text("Wybór zmiany")
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {                 
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Placeholder(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2-50), // Dodaj padding od góry
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Center(
                                        child: Text(
                                          "powrót",
                                          style: TextStyle(
                                            fontSize: 20,
                                            height: 5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text("Wybór kadry")
                      ),
                    ),
                    ElevatedButton(
                      onPressed: ()async {      
                        var value = await timeDialog(context, secondsController, minuteController, "wprowadz nowy pomiar");
                        _setTimePeriod(value ?? 0);
                      },
                      child: Center(
                        child: Text("Okres pomiarów (${_timePeriod~/60}min, ${_timePeriod%60}s)")
                      ),
                    ),
                    ElevatedButton(
                      onPressed: ()async {      
                        var value = await checkListDialog(context, secondsController, 330, "wprowadz nowy pomiar");
                        _setStartingPresssure(value ?? 0);
                      },
                      child: Center(
                        child: Text("Ciśnienie początkowe ($_startingPressure)")
                      ),
                    ),
                    ElevatedButton(
                      onPressed: ()async {      
                        var value = await checkListDialog(context, secondsController, _startingPressure-10>0?_startingPressure - 10 : 0, "wprowadz nowy pomiar");
                        _setExtremePresssure(value ?? 0);
                      },
                      child: Center(
                        child: Text("Ciśnienie graniczne ($_extremePressure)")
                      ),
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
                            builder: (context) => Placeholder(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2-50), // Dodaj padding od góry
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Center(
                                        child: Text(
                                          "powrót",
                                          style: TextStyle(
                                            fontSize: 20,
                                            height: 5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text("Archiwum")
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {               
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Placeholder(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2-50), // Dodaj padding od góry
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Center(
                                        child: Text(
                                          "powrót",
                                          style: TextStyle(
                                            fontSize: 20,
                                            height: 5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text("Wyloguj")
                      ),
                    ),
                  ],
        ),
        backgroundColor: Theme.of(context).primaryColorLight,
        width: MediaQuery.of(context).size.width*0.9,
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Placeholder(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2-50), // Dodaj padding od góry
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Center(
                                child: Text(
                                  "powrót",
                                  style: TextStyle(
                                    fontSize: 20,
                                    height: 5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                maximumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.7, double.infinity)),
              ),
              child: const Center(child: Text(
                "Szybki start",
                style: TextStyle(
                  fontSize: 27,
                  height: 4,
                ),
                ))
              ),
              SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ActionList()),
                );
              },
              style: ButtonStyle(
                maximumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.7, double.infinity)),
              ),
              child: const Center(child: Text(
                "Dołącz do akcji",
                style: TextStyle(
                  fontSize: 20,
                ),
              ))
              ),
              SizedBox(height: 20),
              ElevatedButton(
              onPressed: () {
                GlobalService.databaseSevice.addAction(GlobalService.currentAction);
                GlobalService.currentAction.setActionLocation();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SquadChoice()),
                );
              },
              style: ButtonStyle(
                maximumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.7, double.infinity)),
              ),
              child: const Center(child: Text(
                "Stwórz akcję",
                style: TextStyle(
                  fontSize: 20,
                ),
              ))
              ),
          ],
        ),
      ),
    );
  }

  


}


  
