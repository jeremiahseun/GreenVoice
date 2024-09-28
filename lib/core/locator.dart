import 'package:get_it/get_it.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/src/services/firebase/firebase.dart';
import 'package:greenvoice/src/services/isar_storage.dart';
import 'package:greenvoice/src/services/location_service.dart';
import 'package:greenvoice/src/services/storage_service.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton<GoRouter>(GreenVoiceRoutes().greenVoiceRouter);
  locator
      .registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  locator.registerLazySingleton<FirebaseFirestoreService>(
      () => FirebaseFirestoreService());
  locator.registerLazySingleton<FirebaseStorageService>(
      () => FirebaseStorageService());
  locator.registerLazySingleton<LocationService>(() => LocationService());
  locator.registerLazySingleton<StorageService>(() => StorageService());
  locator.registerLazySingleton<IsarStorageService>(() => IsarStorageService());
}
