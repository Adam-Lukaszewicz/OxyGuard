import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/action/squad_choice.dart';
import 'package:oxy_guard/action_list.dart';
import 'package:oxy_guard/firebase_options.dart';

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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text("OxyGuard")),
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
}


  
