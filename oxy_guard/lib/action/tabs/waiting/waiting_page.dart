import 'package:flutter/material.dart';
import 'package:oxy_guard/action/tabs/waiting/setup_page.dart';
import 'package:oxy_guard/action/tabs/waiting/waiting_tab.dart';

import '../../../global_service.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({super.key});

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin{
    @override
  bool get wantKeepAlive => true;

  var genericButtonStyle = const ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.grey),
      foregroundColor: MaterialStatePropertyAll(Colors.black),
      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 1.0)),
      textStyle: MaterialStatePropertyAll(TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      )));

  late TabController _tabController;

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
    var screenHeight = MediaQuery.of(GlobalService.navigatorKey.currentContext!).size.height - MediaQuery.of(GlobalService.navigatorKey.currentContext!).viewPadding.vertical;
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.15,
          child: TabBar(
            tabs: [WaitingTab(text: "R1", index: 0), WaitingTab(text: "R2", index: 0),WaitingTab(text: "R3", index: 0),],
            controller: _tabController,
            indicatorColor: Colors.black,
            indicatorPadding: const EdgeInsets.only(bottom: 10),
            indicatorSize: TabBarIndicatorSize.label,
            indicator: const UnderlineTabIndicator(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 5),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.75,
          child: TabBarView(
              controller: _tabController,
              children: const [SetupPage(), SetupPage(), SetupPage(),]),
        ),
      ],
    );
  }
}
