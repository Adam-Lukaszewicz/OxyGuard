import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/action/tabs/finished/finished_page.dart';
import 'package:oxy_guard/action/tabs/waiting/waiting_page.dart';
import 'package:provider/provider.dart';

import '../models/squad_model.dart';
import '../services/global_service.dart';
import 'tabs/working/working_page.dart';

class ManagePage extends StatefulWidget {
  SquadModel? chosenAction;
  bool quickStart;
  ManagePage({super.key, this.chosenAction, this.quickStart = false});
  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage>
    with SingleTickerProviderStateMixin {
  List<Tab> categories = <Tab>[
    const Tab(text: "Oczekujące"),
    const Tab(text: "Pracujące"),
    const Tab(text: "Zakończone"),
  ];

  int executeQuickStart(){
    if(widget.quickStart){
      widget.quickStart = false;
      return 1;
    }else {
      return 0;
    }
  }

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
            initialIndex: executeQuickStart(),
            child: Scaffold(
              backgroundColor: const Color(0xfffcfcfc),
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(screenHeight * 0.1),
                  child: SafeArea(
                    child: AppBar(
                      backgroundColor: const Color(0xfffcfcfc),
                      //toolbarHeight: MediaQuery.of(context).size.height * 0.05,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      title: const Text("Odcinek bojowy X"), //Zamiast X faktycznie nazwa tego odcinka
                      centerTitle: true,
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(screenHeight * 0.05),
                        child: TabBar(
                          labelColor: Theme.of(context).primaryColorDark,
                          indicatorColor: Theme.of(context).primaryColorDark,
                          tabs: categories,
                        ),
                      ),
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
                    const FinishedPage(),
                  ],
                )),
          ),
        );
      },
    );
  }
}
