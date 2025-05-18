import 'package:OxyGuard/navigation/router.dart';
import 'package:OxyGuard/repositories/archive/api/impl/firestore_archive_api.dart';
import 'package:OxyGuard/repositories/archive/archive_repository.dart';
import 'package:OxyGuard/repositories/atest/api/impl/firestore_atest_api.dart';
import 'package:OxyGuard/repositories/atest/atest_repository.dart';
import 'package:OxyGuard/repositories/finished_squad/api/impl/firestore_finished_squad_api.dart';
import 'package:OxyGuard/repositories/finished_squad/finished_squad_repository.dart';
import 'package:OxyGuard/repositories/finished_team/api/impl/firestore_finished_team_api.dart';
import 'package:OxyGuard/repositories/finished_team/finished_team_repository.dart';
import 'package:OxyGuard/repositories/personnel/api/impl/firestore_personnel_api.dart';
import 'package:OxyGuard/repositories/personnel/personnel_repository.dart';
import 'package:OxyGuard/repositories/squad/api/impl/firestore_squad_api.dart';
import 'package:OxyGuard/repositories/squad/squad_repository.dart';
import 'package:OxyGuard/repositories/team/api/impl/firestore_team_api.dart';
import 'package:OxyGuard/repositories/team/team_repository.dart';
import 'package:OxyGuard/repositories/worker/api/impl/firestore_worker_api.dart';
import 'package:OxyGuard/repositories/worker/worker_repository.dart';
import 'package:watch_it/watch_it.dart';

import 'repositories/actions/actions_repository.dart';
import 'repositories/actions/api/impl/firestore_actions_api.dart';
import 'repositories/authentication_repository.dart';
import 'repositories/user_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDI() async {
  sl.registerSingleton(Router());

  sl.registerLazySingleton(() => AuthenticationRepository());
  sl.registerLazySingleton(() => UserRepository());
  sl.registerLazySingleton(() => ActionsRepository(actionsApi: FirestoreActionsApi()));
  sl.registerLazySingleton(() => ArchiveRepository(archiveApi: FirestoreArchiveApi()));
  sl.registerLazySingleton(() => AtestRepository(atestApi: FirestoreAtestApi()));
  sl.registerLazySingleton(() => FinishedSquadRepository(finishedSquadApi: FirestoreFinishedSquadApi()));
  sl.registerLazySingleton(() => FinishedTeamRepository(finishedTeamApi: FirestoreFinishedTeamApi()));
  sl.registerLazySingleton(() => PersonnelRepository(personnelApi: FirestorePersonnelApi()));
  sl.registerLazySingleton(() => SquadRepository(squadApi: FirestoreSquadApi()));
  sl.registerLazySingleton(() => TeamRepository(teamApi: FirestoreTeamApi()));
  sl.registerLazySingleton(() => WorkerRepository(workerApi: FirestoreWorkerApi()));
}
