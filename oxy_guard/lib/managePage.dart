import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oxy_guard/squadPage.dart';
import 'package:oxy_guard/squad_tab.dart';
import 'package:oxy_guard/waiting_page.dart';
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
      builder: (context, child) {
        return MaterialApp(
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
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(IconData(0xf3e1,
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage)),
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10))))))
                  ],
                ),
                body: TabBarView(
                  children: [
                    WaitingPage(),
                    Category(
                      key: ValueKey(
                          Provider.of<CategoryModel>(context, listen: true)
                              .workingSquads
                              .length),
                    ),
                    Category(key: ValueKey(99)),
                  ],
                )),
          ),
        );
      },
    );
  }
}

class Category extends StatefulWidget {
  Category({required Key key}) : super(key: key);
  var size = 0;
  @override
  State<Category> createState() => _CategoryState();
}

class CategoryModel extends ChangeNotifier {
  var oxygenValues = <double>[];
  var remainingTimes = <int>[];
  var waitingSquads = [];
  var workingSquads = <SquadPage>[];
  var tabs = <TabSquad>[];

  void update(double newOxygen, double usageRate, int index) {
    oxygenValues[index] = newOxygen;
    remainingTimes[index] = (oxygenValues[index] - 60) ~/ usageRate;
    notifyListeners();
  }

  void advanceTime(int index) {
    remainingTimes[index]--;
    if (remainingTimes[index] < 0) remainingTimes[index] = 0;
    notifyListeners();
  }

  void startSquadWork(int entryPressure, int exitPressure, int interval) {
    oxygenValues.add(entryPressure.toDouble());
    remainingTimes.add(entryPressure~/2); //TODO: Ustalić, czy i jeśli tak to jaki wpisujemy czas na start (aktualnie pesymistyczne założenie, ale możemy np. NaN czy coś)
    workingSquads.add(SquadPage(interval: interval, index: oxygenValues.length-1, entryPressure: entryPressure.toDouble(), exitPressure: exitPressure, text: "R${workingSquads.length+1}"));
    tabs.add(TabSquad(text: "R${workingSquads.length}", index: oxygenValues.length-1));
    notifyListeners();
  }
  //TODO: Funkcja, która rusza oxygen value z czasem, jeśli tego potrzebujemy
}

class _CategoryState extends State<Category>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController _tabController;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    widget.size =
        Provider.of<CategoryModel>(context, listen: false).workingSquads.length;
    _tabController = TabController(vsync: this, length: widget.size);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void restartTabController() {
    _tabController.dispose();
    _tabController = TabController(
        vsync: this,
        length: Provider.of<CategoryModel>(context, listen: false)
            .workingSquads
            .length);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    print("here");
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.15,
          child: TabBar(
            tabs: Provider.of<CategoryModel>(context, listen: false).tabs,
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
          child: TabBarView(
              controller: _tabController,
              children: Provider.of<CategoryModel>(context, listen: false)
                  .workingSquads),
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