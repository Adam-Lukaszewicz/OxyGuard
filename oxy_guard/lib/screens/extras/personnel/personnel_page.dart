import 'package:OxyGuard/screens/extras/personnel/cubit/personnel_cubit.dart';
import 'package:OxyGuard/screens/extras/personnel/cubit/personnal_state.dart';
import 'package:OxyGuard/screens/extras/personnel/view/personnel_body.dart';
import 'package:OxyGuard/screens/splash/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonnelPage extends StatelessWidget {
  const PersonnelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PersonnelCubit()..init(),
      child: BlocBuilder<PersonnelCubit, PersonnelState>(builder: (BuildContext context, PersonnelState state) {
        if (state is PersonnelLoadedState) {
          return PersonnelBody(state: state);
        }
        return const SplashPage();
      }),
    );
  }
}
