import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/action/tabs/waiting/waiting_page.dart';
import 'package:provider/provider.dart';

import '../models/squad_model.dart';
import '../global_service.dart';
import 'tabs/working/working_page.dart';

class ManagePage extends StatefulWidget {
  SquadModel? chosenAction;
  ManagePage({super.key, this.chosenAction});
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
        SquadModel newActionModel;
        if (widget.chosenAction == null) {
          newActionModel = SquadModel();
          GlobalService.currentAction.addSquad(newActionModel);
        } else {
          newActionModel = widget.chosenAction!;
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
                    const WaitingPage(),
                    WorkingPage(
                      key: ValueKey(
                          Provider.of<SquadModel>(context, listen: true)
                              .workingSquads
                              .length),
                    ),
                    WorkingPage(key: const ValueKey(99)),
                  ],
                )),
          ),
        );
      },
    );
  }
}
