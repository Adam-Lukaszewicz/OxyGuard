import 'package:flutter/material.dart';
import 'package:oxy_guard/action/tabs/waiting/setup_page.dart';
import 'package:oxy_guard/action/tabs/waiting/waiting_tab.dart';

import '../../../services/global_service.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({super.key});

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin{
    @override
  bool get wantKeepAlive => true;

  var genericButtonStyle = const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.grey),
      foregroundColor: WidgetStatePropertyAll(Colors.black),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 1.0)),
      textStyle: WidgetStatePropertyAll(TextStyle(
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
    super.build(context);
    var screenHeight = MediaQuery.of(GlobalService.navigatorKey.currentContext!).size.height - MediaQuery.of(GlobalService.navigatorKey.currentContext!).viewPadding.vertical;
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.1,
          child: TabBar(
            tabs: [WaitingTab(text: "R1", index: 0), WaitingTab(text: "R2", index: 0),WaitingTab(text: "R3", index: 0),],
            controller: _tabController,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              color: Theme.of(context).primaryColorDark
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Theme.of(context).primaryColorDark,
            labelPadding: EdgeInsets.all(0),
            dividerHeight: 2.0,
            dividerColor: Colors.grey,
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
