import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/context_windows.dart';
import 'package:oxy_guard/services/global_service.dart';
import 'package:oxy_guard/login/sub/register_page.dart';
import 'package:oxy_guard/login/sub/reset_password.dart';

import '../home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordShowing = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: const Color(0xfffcfcfc),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'media_files/logo_no_fire.png',
                width: MediaQuery.of(context).size.width * 0.8,
                ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.13,),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Wprowadź e-mail',
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      //await FirebaseAuth.instance.setPersistence( Persistence.LOCAL);
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                      if (credential.user == null) {
                        throw Exception("Błąd logowania");
                      }
                      if (!credential.user!.emailVerified) {
                        throw Exception(
                            "Adres e-mail musi być zweryfikowany, aby się zalogować");
                      }
                      GlobalService.databaseSevice.assignTeam(GlobalService.currentPersonnel);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    } on FirebaseAuthException catch (e) {
                      switch (e.code) {
                        case 'invalid-credential':
                          warningDialog(context,
                              "Nieprawidłowe hasło lub login e-mail. Spróbuj ponownie.");
                          break;
                        case 'user-disabled':
                          warningDialog(context,
                              "Konto zostało zablokowane. Skontaktuj się z obsługą.");
                          break;
                        case 'too-many-requests':
                          warningDialog(
                              context, "Zbyt wiele nieudanych prób.");
                          break;
                        case 'invalid-email':
                          warningDialog(
                              context, "Błędny format adresu email.");
                          break;
                        case 'network-request-failed':
                          warningDialog(
                              context, "Brak połączenia sieciowego.");
                          break;
                        case 'channel-error':
                          warningDialog(context, "Wprowadź dane logowania.");
                          break;
                        default:
                          warningDialog(context,
                              "Wystąpił nieznany błąd: ${e.code} ${e.message} Spróbuj ponownie później.");
                      }
                    } catch (e) {
                      warningDialog(context, e.toString());
                    }
                  },
                  style: ButtonStyle(
                      fixedSize: WidgetStateProperty.all(Size(
                          MediaQuery.of(context).size.width * 0.9,
                          MediaQuery.of(context).size.height * 0.07)),
                      elevation: WidgetStateProperty.all(5),
                      shape: WidgetStateProperty.all(
                        const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(width: 0.1))
                      ),
                      backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColorDark)
                    ),
                  child: Center(
                      child: Text(
                    "Zaloguj się",
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onPrimary
                    ),
                  ))),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      style: ButtonStyle(
                      fixedSize: WidgetStateProperty.all(Size(
                          MediaQuery.of(context).size.width * 0.42,
                          MediaQuery.of(context).size.height * 0.07)),
                      shape: WidgetStateProperty.all(
                        const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(width: 0.1))
                      ),
                      elevation: const WidgetStatePropertyAll(5),
                      backgroundColor: const WidgetStatePropertyAll(Colors.white),
                    ),
                      child: Center(
                          child: Text(
                        "Zarejestruj się",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryColorDark
                        ),
                      ))),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ResetPasswordPage()),
                        );
                      },
                      style: ButtonStyle(
                      fixedSize: WidgetStateProperty.all(Size(
                          MediaQuery.of(context).size.width * 0.42,
                          MediaQuery.of(context).size.height * 0.07)),
                      shape: WidgetStateProperty.all(
                        const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)), side: BorderSide(width: 0.1))
                      ),
                      elevation: const WidgetStatePropertyAll(5),
                      backgroundColor: const WidgetStatePropertyAll(Colors.white),
                    ),
                      child: Center(
                          child: Text(
                        "Odzyskaj hasło",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColorDark
                        ),
                      ))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
