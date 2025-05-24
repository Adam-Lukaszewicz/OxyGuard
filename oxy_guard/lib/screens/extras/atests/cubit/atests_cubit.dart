import 'dart:async';

import 'package:OxyGuard/screens/extras/atests/cubit/atests_state.dart';
import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/repositories/atest/atest_repository.dart';
import 'package:OxyGuard/repositories/user_repository.dart';
import 'package:OxyGuard/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AtestsCubit extends Cubit<AtestsState> {
  AtestsCubit() : super(AtestsInitial());

  final AtestRepository _atestRepository = sl();
  final UserRepository _userRepository = sl();

  StreamSubscription<dynamic>? _subscription;

  void init() async {
    _subscription = _atestRepository.getAtestsByUserId(_userRepository.user.id).listen((List<Extinguisher> atests) {
      atests.sort((Extinguisher a, Extinguisher b) {
        return b.expirationDate.compareTo(a.expirationDate);
      });

      emit(AtestsLoadedState(atestsList: atests));
    });
  }

  Future<void> createAtest(String serialNumber, DateTime expirationDate) async {
    Extinguisher atest =
        Extinguisher(uid: _userRepository.user.id, serialNumber: serialNumber, expirationDate: expirationDate);
    _atestRepository.saveAtest(atest);
  }

  Future<void> updateAtestDate(Extinguisher atest, DateTime newDate) async {
    atest.expirationDate = newDate;
    _atestRepository.saveAtest(atest);
  }

  Future<void> deleteAtest(Extinguisher atest) async {
    _atestRepository.deleteAtest(atest.id!);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
