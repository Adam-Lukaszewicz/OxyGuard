import 'package:OxyGuard/legacy/services/gps_service.dart';
import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/screens/squad/cubit/squad_cubit.dart';
import 'package:OxyGuard/screens/team/view/team_body.dart';
import 'package:OxyGuard/screens/team/widgets/team_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_it/watch_it.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key, required this.teams});

  final List<Team> teams;

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController _tabController;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: widget.teams.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //TODO: get rid of this nonsense
    var screenHeight = MediaQuery.of(GetIt.I.get<GpsService>().navigatorKey.currentContext!).size.height -
        MediaQuery.of(GetIt.I.get<GpsService>().navigatorKey.currentContext!).viewPadding.vertical;

    final SquadCubit cubit = context.read<SquadCubit>();

    if (widget.teams.isEmpty) {
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
                  //TODO: start default team when no teams are working
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
            tabs: <Widget>[for(final Team team in widget.teams) TeamTab(team: team,)],
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
              children: <Widget>[for(final Team team in widget.teams) TeamBody(team: team,)],
        ),
        )
      ],
    );
  }
}
