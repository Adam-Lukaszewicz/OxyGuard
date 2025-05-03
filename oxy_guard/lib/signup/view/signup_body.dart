import 'package:OxyGuard/navigation/router.dart';
import 'package:OxyGuard/signup/cubit/signup_cubit.dart';
import 'package:OxyGuard/signup/cubit/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupBody extends StatefulWidget {
  const SignupBody({required this.state, super.key});

  final SignupLoadedState state;

  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  bool passwordShowing = false;
  bool verifyShowing = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController verifyController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    verifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffcfcfc),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'media_files/logo_no_fire.png',
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.13,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Wprowadź e-mail',
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: passwordController,
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
              const SizedBox(height: 50),
              TextField(
                controller: verifyController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Wprowadź hasło ponownie',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            verifyShowing = !verifyShowing;
                          });
                        },
                        icon: verifyShowing
                            ? const Icon(Icons.remove_red_eye_outlined)
                            : const Icon(Icons.remove_red_eye))),
                obscureText: !verifyShowing,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () async {
                    final SignupCubit cubit = context.read<SignupCubit>();
                    bool success = await cubit.signUp(email: emailController.text, password: passwordController.text);
                    if (success) {
                      router.pop();
                    }
                  },
                  child: Center(
                      child: Text(
                    "Zarejestruj się",
                    style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onPrimary),
                  ))),
            ],
          ),
        ),
      ),
    );
  }
}
