import 'package:OxyGuard/screens/action_list/cubit/action_list_cubit.dart';
import 'package:OxyGuard/screens/action_list/cubit/action_list_state.dart';
import 'package:OxyGuard/screens/action_list/view/action_list_body.dart';
import 'package:OxyGuard/screens/splash/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionListPage extends StatelessWidget {
  const ActionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActionListCubit()..init(),
      child: BlocBuilder<ActionListCubit, ActionListState>(builder: (BuildContext context, ActionListState state) {
        if (state is ActionListLoadedState) {
          return ActionListBody(state: state);
        }
        return const SplashPage();
      }),
    );
  }
}
