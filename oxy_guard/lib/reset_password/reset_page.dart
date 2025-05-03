import 'package:OxyGuard/reset_password/cubit/reset_cubit.dart';
import 'package:OxyGuard/reset_password/cubit/reset_state.dart';
import 'package:OxyGuard/reset_password/view/reset_body.dart';
import 'package:OxyGuard/splash/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPage extends StatelessWidget {
  const ResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetCubit()..init(),
      child: BlocBuilder<ResetCubit, ResetState>(builder: (BuildContext context, ResetState state) {
        if (state is ResetLoadedState) {
          return ResetBody(state: state);
        }
        return const SplashPage();
      }),
    );
  }
}
