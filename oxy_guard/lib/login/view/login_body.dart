import 'package:OxyGuard/login/cubit/login_cubit.dart';
import 'package:OxyGuard/navigation/router.dart';
import 'package:OxyGuard/navigation/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
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
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 5.0),
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
              onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Wprowadź e-mail',
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            TextField(
              onChanged: (password) => context.read<LoginCubit>().passwordChanged(password),
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
                  style:
                      ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: const Color(0xff1874d4)),
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
                        router.push(RoutesNames.signup);
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
                        router.push(RoutesNames.restorePassword);
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
