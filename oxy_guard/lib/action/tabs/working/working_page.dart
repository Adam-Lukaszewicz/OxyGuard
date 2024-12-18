import 'package:flutter/material.dart';
import 'package:oxy_guard/services/gps_service.dart';
import 'package:oxy_guard/models/squad_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var screenHeight =
        MediaQuery.of(GetIt.I.get<GpsService>().navigatorKey.currentContext!).size.height -
            MediaQuery.of(GetIt.I.get<GpsService>().navigatorKey.currentContext!)
                .viewPadding
                .vertical;

    if (Provider.of<SquadModel>(context, listen: false)
        .workingSquads
        .values
        .toList()
        .isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Brak przygotowanych rot do pracy. W celu skonfigurowania roty przejdź do zakładki 'oczekujące' lub kliknij poniższy przycisk w celu stworzenia domyślneje roty.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  if (context.mounted) {
                    Provider.of<SquadModel>(context, listen: false)
                        .startSquadWork(
                      (prefs.getInt('startingPressure')) ?? 330,
                      (prefs.getInt('extremePressure')) ?? 60,
                      (prefs.getInt('timePeriod')) ?? 300,
                      "",
                      null,
                      null,
                      null,
                      false,
                    );
                  }
                },
                child: const Text("Rozpocznij pracę roty"),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.1,
          child: TabBar(
            tabs: Provider.of<SquadModel>(context, listen: false)
                .tabs
                .values
                .toList(),
            controller: _tabController,
            indicatorColor: Colors.black,
            unselectedLabelColor: Theme.of(context).primaryColorDark,
            labelColor: Colors.white,
            labelPadding: const EdgeInsets.all(0),
            indicator: BoxDecoration(color: Theme.of(context).primaryColorDark),
            dividerHeight: 2.0,
            dividerColor: Colors.grey,
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
