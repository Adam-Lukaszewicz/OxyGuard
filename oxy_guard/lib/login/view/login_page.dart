import 'package:OxyGuard/login/cubit/login_cubit.dart';
import 'package:OxyGuard/login/view/login_form.dart';
import 'package:OxyGuard/repositories/authentication_repository.dart';
import 'package:OxyGuard/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginCubit(context.read<AuthenticationRepository>(), context.read<UserRepository>()),
        child: const LoginForm(),
      ),
    );
  }
}