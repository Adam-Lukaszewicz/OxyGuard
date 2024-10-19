import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/context_windows.dart';
import 'package:oxy_guard/login_page.dart';

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
        backgroundColor: const Color(0xfffcfcfc),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
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
                    "Zresetuj hasło",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onPrimary
                    ),
                  ))),
            ],
          ),
        ),
      ),
    );
  }
}
