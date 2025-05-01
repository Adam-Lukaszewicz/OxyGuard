import 'package:OxyGuard/app/view/oxy_guard.dart';
import 'package:OxyGuard/legacy/login/sub/register_page.dart';
import 'package:OxyGuard/legacy/login/sub/reset_password.dart';
import 'package:OxyGuard/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/view/home_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool passwordShowing = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            Image.asset(
              'media_files/logo_no_fire.png',
              width: MediaQuery.of(context).size.width * 0.8,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.13,
            ),
            TextField(
              onChanged: (email) =>
                  context.read<LoginCubit>().emailChanged(email),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Wprowadź e-mail',
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            TextField(
              onChanged: (password) =>
                  context.read<LoginCubit>().passwordChanged(password),
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Wprowadź hasło',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passwordShowing = !passwordShowing;
                        });
                      },
                      icon: passwordShowing
                          ? const Icon(Icons.remove_red_eye_outlined)
                          : const Icon(Icons.remove_red_eye))),
              obscureText: !passwordShowing,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                  onPressed: () async {
                    context.read<LoginCubit>().loginWithCredentials();
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xff1874d4)),
                  child: const Center(
                      child: Text(
                    "Zaloguj się",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ))),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.42,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Center(
                          child: Text(
                        "Zarejestruj się",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ))),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.42,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ResetPasswordPage()),
                        );
                      },
                      child: const Center(
                          child: Text(
                        "Odzyskaj hasło",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
