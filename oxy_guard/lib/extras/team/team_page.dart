import 'package:OxyGuard/extras/team/cubit/team_cubit.dart';
import 'package:OxyGuard/extras/team/cubit/team_state.dart';
import 'package:OxyGuard/extras/team/view/team_body.dart';
import 'package:OxyGuard/splash/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamCubit()..init(),
      child: BlocBuilder<TeamCubit, TeamState>(builder: (BuildContext context, TeamState state) {
        if (state is TeamLoadedState) {
          return TeamBody(state: state);
        }
        return const SplashPage();
      }),
    );
  }
}
