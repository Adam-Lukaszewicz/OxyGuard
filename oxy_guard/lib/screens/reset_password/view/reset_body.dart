import 'package:OxyGuard/navigation/router.dart';
import 'package:OxyGuard/screens/reset_password/cubit/reset_cubit.dart';
import 'package:OxyGuard/screens/reset_password/cubit/reset_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetBody extends StatefulWidget {
  const ResetBody({required this.state, super.key});

  final ResetLoadedState state;

  @override
  State<ResetBody> createState() => _ResetBodyState();
}

class _ResetBodyState extends State<ResetBody> {
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
              SizedBox(
                height: 60,
                child: ElevatedButton(
                    onPressed: () async {
                      final ResetCubit cubit = context.read<ResetCubit>();
                      final bool success = await cubit.sendResetEmail(email: emailController.text);
                      if (success) {
                        router.pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: const Color(0xff1874d4)),
                    child: Center(
                        child: Text(
                      "Zresetuj hasło",
                      style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onPrimary),
                    ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
