import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/squadPage.dart';
import 'package:provider/provider.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage>
    with SingleTickerProviderStateMixin {
  static const List<Tab> categories = <Tab>[
    Tab(text: "Oczekujące"),
    Tab(text: "Pracujące"),
    Tab(text: "Zakończone"),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoryModel(),
      child: MaterialApp(
        home: DefaultTabController(
          length: categories.length,
          child: Scaffold(
              appBar: AppBar(
                toolbarHeight: MediaQuery.of(context).size.height * 0.05,
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
                actions: [
                  const Text("KRG 1"), //TODO: Ekran konfiguracyjny
                  IconButton(onPressed: (){}, icon: const Icon(IconData(0xf3e1, fontFamily: CupertinoIcons.iconFont, fontPackage: CupertinoIcons.iconFontPackage)),
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))
                  ))
                ],
              ),
              body: const TabBarView(
                children: [
                  Category(),
                  Category(),
                  Category(),
                ],
              )),
        ),
      ),
    );
  }
}

class Category extends StatefulWidget {
  const Category({super.key});
  @override
  State<Category> createState() => _CategoryState();
}

class CategoryModel extends ChangeNotifier{
  var oxygenValue = 300.0;
  var remainingTime = 900;

  void update(double newOxygen, double usageRate){
    oxygenValue = newOxygen;
    remainingTime = (oxygenValue - 60)~/usageRate;
    notifyListeners();
  }

  void advanceTime(){
    remainingTime--;
    if (remainingTime < 0) remainingTime = 0;
    notifyListeners();
  }
  //TODO: Funkcja, która rusza oxygen value z czasem, jeśli tego potrzebujemy
}

class _CategoryState extends State<Category>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;
  var timeR1 = 150;
  var timeR2 = 600;
  var timeRIT = 900;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.15,
          child: TabBar(
            tabs: <Tab>[
              Tab(
                height: screenHeight * 0.1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    //color: Colors.grey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text('${timeR1 ~/ 60}:${timeR1 % 60 < 10 ? "0${timeR1 % 60}" : "${timeR1 % 60}"}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 30,
                                )),
                          ),
                        ),
                        const Positioned(
                          top: 34,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              "R1",
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Tab(
                height: screenHeight * 0.1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    //color: Colors.grey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Consumer<CategoryModel>(
                              builder: (context, cat, child){
                              return Text('${cat.remainingTime ~/ 60}:${cat.remainingTime % 60 < 10 ? "0${cat.remainingTime % 60}" : "${cat.remainingTime % 60}"}',
                                  style: TextStyle(
                                    color: HSVColor.lerp(HSVColor.fromColor(Colors.green), HSVColor.fromColor(Colors.red), 1 - (cat.oxygenValue-60)/270)!.toColor(),
                                    fontSize: 30,
                                  ));}
                            ),
                          ),
                        ),
                        const Positioned(
                          top: 34,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              "R2",
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Tab(
                height: screenHeight * 0.1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    //color: Colors.grey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text('${timeRIT ~/ 60}:${timeRIT % 60 < 10 ? "0${timeRIT % 60}" : "${timeRIT % 60}"}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 30,
                                )),
                          ),
                        ),
                        const Positioned(
                          top: 34,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              "RIT",
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            controller: _tabController,
            indicatorColor: Colors.black,
            indicatorPadding: const EdgeInsets.only(bottom: 10),
            indicatorSize: TabBarIndicatorSize.label,
            indicator: const UnderlineTabIndicator(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Colors.black, width: 5),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.70,
          child: TabBarView(controller: _tabController, children: [
            const Text("R1o"),
            SquadPage(),
            const Text("R3o"),
          ]),
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