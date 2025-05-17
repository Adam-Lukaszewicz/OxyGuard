import 'package:OxyGuard/navigation/router.dart';
import 'package:OxyGuard/repositories/archive/api/impl/firestore_archive_api.dart';
import 'package:OxyGuard/repositories/archive/archive_repository.dart';
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
}
