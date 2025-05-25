import 'dart:async';

import 'package:OxyGuard/screens/squad/cubit/squad_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SquadCubit extends Cubit<SquadState> {
  SquadCubit() : super(SquadInitial());

  StreamSubscription<dynamic>? _subscription;

  void init(String? squadId){}

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
