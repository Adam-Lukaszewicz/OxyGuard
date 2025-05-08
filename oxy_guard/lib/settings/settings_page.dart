import 'package:OxyGuard/settings/cubit/settings_cubit.dart';
import 'package:OxyGuard/settings/cubit/settings_state.dart';
import 'package:OxyGuard/splash/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit()..init(),
      child: BlocBuilder<SettingsCubit, SettingsState>(builder: (BuildContext context, SettingsState state) {
        if (state is SettingsLoadedState) {
          return const SettingsPage();
        }
        return const SplashPage();
      }),
    );
  }
}
