import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oxy_guard/firebase_options.dart';
import 'package:oxy_guard/home/home_page.dart';
import 'package:oxy_guard/login/login_page.dart';

import 'services/global_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const OxyGuard());
  GlobalService.checkGPSPermission();
}

class OxyGuard extends StatelessWidget {
  const OxyGuard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: GlobalService.navigatorKey,
      title: 'OxyGuard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400, brightness: Brightness.light, contrastLevel: 0.5),
        scaffoldBackgroundColor: const Color(0xfffcfcfc),
        useMaterial3: true,
      ),
      home: _getLandingPage()
    );
  }

  Widget _getLandingPage() {
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData) {
        GlobalService.databaseSevice.assignTeam(GlobalService.currentPersonnel);
        return const HomePage();
      } else {
        return const LoginPage();
      }
    },
  );
}
}