import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oxy_guard/action/squad_choice.dart';
import 'package:oxy_guard/action_list.dart';
import 'package:oxy_guard/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
int _counter = 0;
int _time = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
    _loadTime();
    secondsController = FixedExtentScrollController();
    minuteController = FixedExtentScrollController();
  }

  Future<void> _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('licznik') ?? 0);
    });
  }
  Future<void> _loadTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('time') ?? 0);
    });
  }
  Future<void> _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('licznik') ?? 0) + 1;
      prefs.setInt('licznik', _counter);
    });
  }
  Future<void> _setTime(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _time = value;
      prefs.setInt('time', _time);
    });
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("OxyGuard"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
                    DrawerHeader(
                      child: Center(
                      child: Text(
                        "Ustawienia",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inverseSurface,
                          fontSize: 40,
                        ),
                      ),
                    ),
                    ),
                    ElevatedButton(
                      onPressed: _incrementCounter,
                      child: const Center(
                        child: Text("dodaj")
                      ),
                    ),
                    Center(child: Text('Licznik: $_counter')),
                    ElevatedButton(
                      onPressed: () async{
                      var value = await timeDialog();
                      _setTime(value!);
                      },
                      child: const Center(
                        child: Text("dodaj")
                      ),
                    ),
                    Center(child: Text('czas: $_time')),
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
                  MaterialPageRoute(builder: (context) => const ActionList()),
                );
              },
              child: const Center(child: Text("Dołącz do akcji"))
              ),
              ElevatedButton(
              onPressed: () {
                GlobalService.databaseSevice.addAction(GlobalService.currentAction);
                GlobalService.currentAction.setActionLocation();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SquadChoice()),
                  //Ten skok nie będzie od razu do managmentu, jak na razie robię przykład UI
                );
              },
              child: const Center(child: Text("Stwórz akcję"))
              ),
          ],
        ),
      ),
    );
  }

  Future<int?> timeDialog() => showDialog<int>(
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
                          children: [
                            Text(
                              "Wprowadź czas wyjś",
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
                                controller: minuteController,
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
                                controller: secondsController,
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
                                  15 * secondsController.selectedItem +
                                      60 * minuteController.selectedItem);
                            },
                            child: const Text("Wprowadź")))
                  ],
                ),
              ),
            ),
          ));


}


  
