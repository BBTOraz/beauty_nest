
import 'package:get_it/get_it.dart';
import 'services/auth_service.dart';
import 'repositories/user_repository.dart';

final GetIt locator = GetIt.instance;

void setupServiceLocator() {
  locator.registerLazySingleton<AuthService>(() => FirebaseAuthService());
  locator.registerLazySingleton<UserRepository>(
          () => FirebaseUserRepository(locator<AuthService>()));
}
