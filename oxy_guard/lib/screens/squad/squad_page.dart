import 'package:OxyGuard/screens/splash/view/splash.dart';
import 'package:OxyGuard/screens/squad/cubit/squad_cubit.dart';
import 'package:OxyGuard/screens/squad/cubit/squad_state.dart';
import 'package:OxyGuard/screens/squad/view/squad_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SquadPage extends StatelessWidget {
  const SquadPage({super.key, this.squadId});

  final String? squadId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SquadCubit()..init(squadId),
      child: BlocBuilder<SquadCubit, SquadState>(builder: (BuildContext context, SquadState state) {
        if (state is SquadLoadedState) {
          return SquadBody(state: state,);
        }
        return const SplashPage();
      }),
    );
  }
}
