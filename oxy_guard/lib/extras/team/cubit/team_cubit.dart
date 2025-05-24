import 'dart:async';

import 'package:OxyGuard/extras/team/cubit/team_state.dart';
import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/repositories/personnel/personnel_repository.dart';
import 'package:OxyGuard/repositories/user_repository.dart';
import 'package:OxyGuard/repositories/worker/worker_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service_locator.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit() : super(TeamInitial());

  final PersonnelRepository _personnelRepository = sl();
  final WorkerRepository _workerRepository = sl();
  final UserRepository _userRepository = sl();

  StreamSubscription<dynamic>? _subscription;

  void init() {
    _subscription =
        _personnelRepository.getPersonnelByUserId(_userRepository.user.id).listen((Personnel personnel) async {
      List<Worker> workers = await _workerRepository.getWorkersByPersonnelId(personnel.id!).first;

      workers.sort((Worker a, Worker b) {
        int firstNameComparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
        if (firstNameComparison == 0) {
          return a.surname.toLowerCase().compareTo(b.surname.toLowerCase());
        }
        return firstNameComparison;
      });

      emit(TeamLoadedState(personnel: personnel, workers: workers));
    });
  }

  Future<void> addWorker(Personnel personnel, String firstName, String lastName) async {
    final Worker worker = Worker(personnelId: personnel.id!, name: firstName, surname: lastName);
    _workerRepository.saveWorker(worker);
    personnel.workers.add(worker.id!);
    _personnelRepository.savePersonnel(personnel);
  }

  Future<void> deleteWorker(Personnel personnel, Worker worker) async {
    personnel.workers.removeWhere((String id) => id == worker.id!);
    _personnelRepository.savePersonnel(personnel);
    _workerRepository.deleteWorker(worker.id!);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
