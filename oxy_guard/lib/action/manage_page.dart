import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/action/tabs/working/squad_page.dart';
import 'package:oxy_guard/action/tabs/working/squad_tab.dart';
import 'package:oxy_guard/action/tabs/waiting/waiting_page.dart';
import 'package:oxy_guard/main.dart';
import 'package:provider/provider.dart';

import '../models/action_model.dart';

class ManagePage extends StatefulWidget {
  dynamic chosenAction;
  ManagePage({super.key, dynamic? chosenAction}) : chosenAction = chosenAction;
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
    var screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.vertical;
    return ChangeNotifierProvider(
      create: (context) {
        ActionModel newActionModel;
        if (widget.chosenAction == null) {
          newActionModel = ActionModel();
          newActionModel.setActionLocation();
          NavigationService.databaseSevice.addAction(newActionModel);
        } else {
          newActionModel = widget.chosenAction;
          newActionModel.listenToChanges();
          widget.chosenAction = null;
        }
        return newActionModel;
      },
      builder: (context, child) {
        return MaterialApp(
          home: DefaultTabController(
            length: categories.length,
            child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(screenHeight * 0.1),
                  child: SafeArea(
                    child: AppBar(
                      //toolbarHeight: MediaQuery.of(context).size.height * 0.05,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      title: const Text("Odcinek bojowy X"),
                      centerTitle: true,
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(screenHeight * 0.05),
                        child: const TabBar(
                          tabs: categories,
                        ),
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
                  ),
                ),
                body: TabBarView(
                  children: [
                    WaitingPage(),
                    Category(
                      key: ValueKey(
                          Provider.of<ActionModel>(context, listen: true)
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

class _CategoryState extends State<Category>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController _tabController;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    widget.size =
        Provider.of<ActionModel>(context, listen: false).workingSquads.length;
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
        length: Provider.of<ActionModel>(context, listen: false)
            .workingSquads
            .length);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight =
        MediaQuery.of(NavigationService.navigatorKey.currentContext!)
                .size
                .height -
            MediaQuery.of(NavigationService.navigatorKey.currentContext!)
                .viewPadding
                .vertical;
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.15,
          child: TabBar(
            tabs: Provider.of<ActionModel>(context, listen: false)
                .tabs
                .values
                .toList(),
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
          height: screenHeight * 0.75,
          child: TabBarView(
              controller: _tabController,
              children: Provider.of<ActionModel>(context, listen: false)
                  .workingSquads
                  .values
                  .toList()),
        ),
      ],
    );
  }
}
