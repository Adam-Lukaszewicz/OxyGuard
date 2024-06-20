import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/context_windows.dart';
import 'package:oxy_guard/global_service.dart';
import 'package:oxy_guard/main.dart';
import 'package:oxy_guard/register_page.dart';
import 'package:oxy_guard/reset_password.dart';

import 'home_page.dart';

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
  void initState(){
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
  if (user != null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  } 
});
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.18,
        title: Image.asset(
          'media_files/logo.png',
          fit: BoxFit.scaleDown,
          width: 250,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
              ElevatedButton(
                onPressed: () async {
                  try {
                    //await FirebaseAuth.instance.setPersistence( Persistence.LOCAL);
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                    if(credential.user == null){
                      throw Exception("Błąd logowania");
                    }
                    if(!credential.user!.emailVerified){
                      throw Exception("Adres e-mail musi być zweryfikowany, aby się zalogować");
                    }
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePage()),
                  );
                  } on FirebaseAuthException catch (e) {
                    print(e.code);
                    print(e.message);
                    switch (e.code) {
                    case 'invalid-credential':
                      warningDialog(context, "Nieprawidłowe hasło lub login e-mail. Spróbuj ponownie.");
                      break;
                    case 'user-disabled':
                      warningDialog(context, "Konto zostało zablokowane. Skontaktuj się z obsługą.");
                      break;
                    case 'too-many-requests':
                      warningDialog(context, "Zbyt wiele nieudanych prób.");
                      break;
                    case 'invalid-email':
                      warningDialog(context, "Błędny format adresu email.");
                      break;
                    case 'network-request-failed':
                      warningDialog(context, "Brak połączenia sieciowego.");
                      break;
                    case 'channel-error':
                      warningDialog(context, "Wprowadź dane logowania.");
                      break;
                    default:
                      warningDialog(context, "Wystąpił nieznany błąd: ${e.code} ${e.message} Spróbuj ponownie później.");
                  } 
                  } catch (e){
                    warningDialog(context, e.toString());
                  }
                },
                style: ButtonStyle(
                  maximumSize: MaterialStateProperty.all(Size(
                      MediaQuery.of(context).size.width * 0.89,
                      double.infinity)),
                ),
                child: const Center(
                    child: Text(
                  "Zaloguj się",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ))),
                const SizedBox(height: 20),
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
                        maximumSize: MaterialStateProperty.all(Size(
                            MediaQuery.of(context).size.width * 0.4,
                            double.infinity)),
                      ),
                      child: const Center(
                          child: Text(
                        "Zarejestruj się",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ))),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ResetPasswordPage()),
                        );
                      },
                      style: ButtonStyle(
                        maximumSize: MaterialStateProperty.all(Size(
                            MediaQuery.of(context).size.width * 0.43,
                            double.infinity)),
                      ),
                      child: const Center(
                          child: Text(
                        "Odzyskaj hasło",
                        style: TextStyle(
                          fontSize: 20,
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
