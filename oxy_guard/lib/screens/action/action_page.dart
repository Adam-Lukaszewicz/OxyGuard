import 'package:OxyGuard/screens/action/cubit/action_cubit.dart';
import 'package:OxyGuard/screens/action/cubit/action_state.dart';
import 'package:OxyGuard/screens/action/view/action_body.dart';
import 'package:OxyGuard/screens/splash/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionPage extends StatelessWidget {
  const ActionPage({this.actionId, super.key});

  final String? actionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActionCubit()..init(actionId),
      child: BlocBuilder<ActionCubit, ActionState>(builder: (BuildContext context, ActionState state) {
        if (state is ActionLoadedState) {
          return ActionBody(
            state: state,
          );
        }
        return const SplashPage();
      }),
    );
  }
}
