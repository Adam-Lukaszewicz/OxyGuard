import 'package:OxyGuard/screens/login/cubit/login_cubit.dart';
import 'package:OxyGuard/screens/login/view/login_body.dart';
import 'package:OxyGuard/screens/splash/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => LoginCubit()..init(),
        child: BlocBuilder<LoginCubit, LoginState>(builder: (BuildContext context, LoginState state) {
          if (state is LoginLoadedState) {
            return const LoginBody();
          }
          return const SplashPage();
        }));
  }
}
