import 'package:OxyGuard/screens/signup/cubit/signup_cubit.dart';
import 'package:OxyGuard/screens/signup/cubit/signup_state.dart';
import 'package:OxyGuard/screens/signup/view/signup_body.dart';
import 'package:OxyGuard/screens/splash/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingupPage extends StatelessWidget {
  const SingupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit()..init(),
      child: BlocBuilder<SignupCubit, SignupState>(builder: (BuildContext context, SignupState state) {
        if (state is SignupLoadedState) {
          return SignupBody(state: state);
        }
        return const SplashPage();
      }),
    );
  }
}
