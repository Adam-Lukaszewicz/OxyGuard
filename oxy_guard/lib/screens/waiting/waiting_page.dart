import 'package:OxyGuard/screens/waiting/view/waiting_body.dart';
import 'package:OxyGuard/screens/waiting/widgets/waiting_tab.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../repositories/location_repository.dart';

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
    var screenHeight = MediaQuery.of(GetIt.I.get<LocationRepository>().navigatorKey.currentContext!).size.height - MediaQuery.of(GetIt.I.get<LocationRepository>().navigatorKey.currentContext!).viewPadding.vertical;
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.1,
          child: TabBar(
            tabs: const [WaitingTab(index: 1), WaitingTab(index: 2),WaitingTab(index: 3),],
            controller: _tabController,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              color: Theme.of(context).primaryColorDark
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Theme.of(context).primaryColorDark,
            labelPadding: const EdgeInsets.all(0),
            dividerHeight: 2.0,
            dividerColor: Colors.grey,
          ),
        ),
        SizedBox(
          height: screenHeight * 0.75,
          child: TabBarView(
              controller: _tabController,
              children: const [WaitingBody(), WaitingBody(), WaitingBody(),]),
        ),
      ],
    );
  }
}
