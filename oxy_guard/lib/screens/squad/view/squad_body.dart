import 'package:OxyGuard/legacy/action/tabs/finished/finished_page.dart';
import 'package:OxyGuard/legacy/action/tabs/waiting/waiting_page.dart';
import 'package:OxyGuard/navigation/router.dart';
import 'package:OxyGuard/screens/squad/cubit/squad_state.dart';
import 'package:flutter/material.dart';

import '../../../legacy/action/tabs/working/working_page.dart';

class SquadBody extends StatefulWidget {
  const SquadBody({super.key, required this.state});

  final SquadLoadedState state;

  @override
  State<SquadBody> createState() => _SquadBodyState();
}

class _SquadBodyState extends State<SquadBody> with SingleTickerProviderStateMixin {
  List<Tab> categories = <Tab>[
    const Tab(text: "Oczekujące"),
    const Tab(text: "Pracujące"),
    const Tab(text: "Zakończone"),
  ];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.vertical;
    return MaterialApp(
      home: DefaultTabController(
        length: categories.length,
        child: Scaffold(
            backgroundColor: const Color(0xfffcfcfc),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(screenHeight * 0.1),
              child: SafeArea(
                child: AppBar(
                  backgroundColor: const Color(0xfffcfcfc),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      router.pop();
                    },
                  ),
                  title: const Text("Odcinek bojowy X"),
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
                  key: ValueKey(widget.state.teams.length),
                ),
                const FinishedPage(),
              ],
            )),
      ),
    );
  }
}
