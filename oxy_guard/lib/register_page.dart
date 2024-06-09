import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/context_windows.dart';
import 'package:oxy_guard/login_page.dart';
import 'package:oxy_guard/main.dart';

import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                    if(passwordController.text == verifyController.text){
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        await credential.user?.sendEmailVerification();
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                      } on FirebaseAuthException catch (e) {
                        print(e.code);
                        print(e.message);
                    }
                    }else{
                      warningDialog(context, "Hasła muszą być takie same");
                    }
                  },
                  style: ButtonStyle(
                    maximumSize: MaterialStateProperty.all(Size(
                        MediaQuery.of(context).size.width * 0.5,
                        double.infinity)),
                  ),
                  child: const Center(
                      child: Text(
                    "Zarejestruj się",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ))),
            ],
          ),
        ),
      ),
    );
  }
}
