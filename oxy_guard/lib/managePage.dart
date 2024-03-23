import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oxy_guard/squadPage.dart';

class ManagePage extends StatefulWidget{
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> with SingleTickerProviderStateMixin {
  
  static const List<Tab> categories = <Tab>[
    Tab(text: "Oczekujące"),
    Tab(text: "Pracujące"),
    Tab(text: "Zakończone"),
  ];

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: DefaultTabController(
        length: categories.length,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
              ),
            title: const Text("Odcinek bojowy X"),
            centerTitle: true,
            bottom: const TabBar(
              tabs: categories,
            ),
          ),
          body: TabBarView(
            children: [
              Category(),
              Category(),
              Category(),
            ],
            )
        ),
      ),
    );
  }
}

class Category extends StatefulWidget{
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  static const List<Tab> exRots = <Tab>[
    Tab(text: "R1"),
    Tab(text: "R2"),
    Tab(text: "RIT"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: exRots.length);
  }

 @override
 void dispose() {
   _tabController.dispose();
   super.dispose();
 }
  @override
  Widget build(BuildContext context){
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        TabBar(
          tabs: exRots,
          controller: _tabController,
          ),
        Container(
          height: screenHeight * 0.75,
          child: TabBarView(
            controller: _tabController,
            children: [
              Text("R1o"),
              SquadPage(),
              Text("R3o"),
            ]
          ),
        ),
      ],
    );
  }
}
/*
class Working extends StatefulWidget{
  const Working({super.key});

  @override
  State<Working> createState() => _WorkingState();
}

class _WorkingState extends State<Working> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<Tab> exRots = <Tab>[
    Tab(text: "R1"),
    Tab(text: "R2"),
    Tab(text: "RIT"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: exRots.length);
  }

 @override
 void dispose() {
   _tabController.dispose();
   super.dispose();
 }
  @override
  Widget build(BuildContext context){
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        TabBar(
          tabs: exRots,
          controller: _tabController,
          ),
        Container(
          height: screenHeight * 0.75,
          child: TabBarView(
            controller: _tabController,
            children: [
              Text("R1p"),
              Text("R2p"),
              Text("R3p"),
            ]
          ),
        ),
      ],
    );
  }
}

class Finished extends StatefulWidget{
  const Finished({super.key});

  @override
  State<Finished> createState() => _FinishedState();
}

class _FinishedState extends State<Finished> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<Tab> exRots = <Tab>[
    Tab(text: "R1"),
    Tab(text: "R2"),
    Tab(text: "RIT"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: exRots.length);
  }

 @override
 void dispose() {
   _tabController.dispose();
   super.dispose();
 }
  @override
  Widget build(BuildContext context){
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        TabBar(
          tabs: exRots,
          controller: _tabController,
          ),
        Container(
          height: screenHeight * 0.75,
          child: TabBarView(
            controller: _tabController,
            children: [
              Text("R1z"),
              Text("R2z"),
              Text("R3z"),
            ]
          ),
        ),
      ],
    );
  }
}
Nie mam pojęcia jak będziemy w końcu te ilości rot rozwiązywać, zacznę od wersji która ma największa szansę na skalowalność i od tego idziemy dalej.
Bazowy design zrobie dla aktualnie pracującej, bo pozostałe dwie kategorie można rozwiązać innym UI. Basically, TODO.
*/
