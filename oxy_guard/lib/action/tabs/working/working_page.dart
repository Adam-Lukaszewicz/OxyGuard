import 'package:flutter/material.dart';
import 'package:oxy_guard/global_service.dart';
import 'package:oxy_guard/models/squad_model.dart';
import 'package:provider/provider.dart';

class WorkingPage extends StatefulWidget {
  WorkingPage({required Key key}) : super(key: key);
  var size = 0;
  @override
  State<WorkingPage> createState() => _WorkingPageState();
}

class _WorkingPageState extends State<WorkingPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController _tabController;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    widget.size =
        Provider.of<SquadModel>(context, listen: false).workingSquads.length;
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
        length: Provider.of<SquadModel>(context, listen: false)
            .workingSquads
            .length);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight =
        MediaQuery.of(GlobalService.navigatorKey.currentContext!)
                .size
                .height -
            MediaQuery.of(GlobalService.navigatorKey.currentContext!)
                .viewPadding
                .vertical;
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.15,
          child: TabBar(
            tabs: Provider.of<SquadModel>(context, listen: false)
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
              children: Provider.of<SquadModel>(context, listen: false)
                  .workingSquads
                  .values
                  .toList()),
        ),
      ],
    );
  }
}