import 'package:OxyGuard/app/view/oxy_guard.dart';
import 'package:OxyGuard/app_bloc_observer.dart';
import 'package:OxyGuard/firebase_options.dart';
import 'package:OxyGuard/repositories/authentication_repository.dart';
import 'package:OxyGuard/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  final authenticationRepository = AuthenticationRepository();
  final userRepository = UserRepository();
  await authenticationRepository.user.first;
  
  runApp(OxyGuard(authenticationRepository: authenticationRepository, userRepository: userRepository,));
}
