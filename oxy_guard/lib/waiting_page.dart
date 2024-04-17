import 'package:flutter/material.dart';
import 'package:oxy_guard/setup_page.dart';
import 'package:oxy_guard/waiting_tab.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({super.key});

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> with SingleTickerProviderStateMixin{

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
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.13,
          child: TabBar(
            tabs: [WaitingSquad(text: "R1", index: 0), WaitingSquad(text: "R2", index: 0),WaitingSquad(text: "R3", index: 0),],
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
              children: [SetupPage(), SetupPage(), SetupPage(),]),
        ),
      ],
    );
  }
}
