import 'package:OxyGuard/extras/atests/cubit/atests_cubit.dart';
import 'package:OxyGuard/extras/atests/cubit/atests_state.dart';
import 'package:OxyGuard/extras/atests/view/atests_body.dart';
import 'package:OxyGuard/splash/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AtestsPage extends StatelessWidget {
  const AtestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AtestsCubit()..init(),
      child: BlocBuilder<AtestsCubit, AtestsState>(builder: (BuildContext context, AtestsState state) {
        if (state is AtestsLoadedState) {
          return AtestsBody(
            state: state,
          );
        }
        return const SplashPage();
      }),
    );
  }
}
