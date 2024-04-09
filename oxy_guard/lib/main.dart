import 'package:flutter/material.dart';
import 'package:oxy_guard/actionList.dart';
import 'package:oxy_guard/managePage.dart';
import 'package:oxy_guard/setup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SetupPage()),
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


  
