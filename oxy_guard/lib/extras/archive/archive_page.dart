import 'package:OxyGuard/extras/archive/cubit/archive_cubit.dart';
import 'package:OxyGuard/extras/archive/cubit/archive_state.dart';
import 'package:OxyGuard/extras/archive/view/archive_body.dart';
import 'package:OxyGuard/splash/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArchiveCubit()..init(),
      child: BlocBuilder<ArchiveCubit, ArchiveState>(builder: (BuildContext context, ArchiveState state) {
        if (state is ArchiveLoadedState) {
          return ArchiveBody(state: state);
        }
        return const SplashPage();
      }),
    );
  }
}
