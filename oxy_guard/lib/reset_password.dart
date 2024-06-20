import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/context_windows.dart';
import 'package:oxy_guard/login_page.dart';
import 'package:oxy_guard/main.dart';


import 'home_page.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  TextEditingController emailController = TextEditingController();


  @override
  void dispose() {
    emailController.dispose();

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
              ElevatedButton(
                  onPressed: () async {
                    
                      try {
                        final credential = await FirebaseAuth.instance
                            .sendPasswordResetEmail(
                          email: emailController.text,
                        );
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                      
                            succesDialog(context, "Na twój adres email został wysłany link resetujący hasło. Otwórz go w celu zmiany hasła.");
                      } on FirebaseAuthException catch (e) {
                        print(e.code);
                        print(e.message);
                        switch (e.code) {
                          case 'invalid-email':
                            warningDialog(context, "Błędny format adresu email.");
                            break;
                          case 'network-request-failed':
                            warningDialog(context, "Brak połączenia sieciowego.");
                            break;
                          case 'channel-error':
                            warningDialog(context, "Wprowadź adres email.");
                            break;
                          default:
                            warningDialog(context, "Wystąpił nieznany błąd: ${e.code} ${e.message} Spróbuj ponownie później.");
                        } 
                    }
                  },
                  style: ButtonStyle(
                    maximumSize: MaterialStateProperty.all(Size(
                        MediaQuery.of(context).size.width * 0.5,
                        double.infinity)),
                  ),
                  child: const Center(
                      child: Text(
                    "Zresetuj hasło",
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
