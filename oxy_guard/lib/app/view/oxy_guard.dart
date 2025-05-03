import 'package:OxyGuard/app/bloc/app_bloc.dart';
import 'package:OxyGuard/navigation/router.dart';
import 'package:OxyGuard/navigation/routes_names.dart';
import 'package:OxyGuard/splash/view/splash.dart';
import 'package:OxyGuard/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OxyGuard extends StatelessWidget {
  const OxyGuard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        lazy: false, create: (_) => AppBloc()..add(const AppUserSubscriptionRequested()), child: const OxyGuardView());
  }
}

class OxyGuardView extends StatelessWidget {
  const OxyGuardView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OxyGuard',
      theme: Themes.light,
      navigatorKey: router.navigatorKey,
      onGenerateRoute: (settings) => router.generate(settings),
      home: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          switch (state.status) {
            case AppStatus.authenticated:
              router.pushAndRemove(RoutesNames.home);
            case AppStatus.unauthenticated:
              router.pushAndRemove(RoutesNames.login);
          }
        },
        child: const SplashPage(),
      ),
    );
  }
}
