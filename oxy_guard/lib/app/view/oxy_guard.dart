import 'package:OxyGuard/app/bloc/app_bloc.dart';
import 'package:OxyGuard/home/view/home_page.dart';
import 'package:OxyGuard/login/view/login_page.dart';
import 'package:OxyGuard/repositories/authentication_repository.dart';
import 'package:OxyGuard/repositories/user_repository.dart';
import 'package:OxyGuard/splash/view/splash.dart';
import 'package:OxyGuard/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OxyGuard extends StatelessWidget {
  const OxyGuard(
      {required AuthenticationRepository authenticationRepository,
      required UserRepository userRepository,
      super.key})
      : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository;

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
            create: (context) => AuthenticationRepository()),
        RepositoryProvider<UserRepository>(
            create: (context) => UserRepository())
      ],
      child: BlocProvider(
          lazy: false,
          create: (_) => AppBloc(
              authenticationRepository: _authenticationRepository,
              userRepository: _userRepository)
            ..add(const AppUserSubscriptionRequested()),
          child: const OxyGuardView()),
    );
  }
}

class OxyGuardView extends StatelessWidget {
  const OxyGuardView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OxyGuard',
      theme: Themes.light,
      home: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          switch (state.status) {
            case AppStatus.authenticated:
              Navigator.pushAndRemoveUntil(
                context,
                HomePage.route(),
                (route) => route.isFirst,
              );
            case AppStatus.unauthenticated:
              Navigator.pushAndRemoveUntil(
                context,
                LoginPage.route(),
                (route) => route.isFirst,
              );
          }
        },
        child: const SplashPage(),
      ),
    );
  }
}
