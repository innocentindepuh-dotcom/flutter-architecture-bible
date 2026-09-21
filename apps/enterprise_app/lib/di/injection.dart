// apps/enterprise_app/lib/di/injection.dart

import "package:core_network/core_network.dart";
import "package:feature_auth/feature_auth.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:get_it/get_it.dart";

final GetIt locator = GetIt.instance;

Future<void> configureDependencies({required String baseUrl}) async {
  locator.registerLazySingleton<ApiClientConfig>(
    () => ApiClientConfig(baseUrl: baseUrl),
  );

  locator.registerLazySingleton<ApiClient>(
    () => ApiClient(config: locator<ApiClientConfig>()),
  );

  locator.registerLazySingleton<NetworkInfo>(
    () => const NetworkInfoImpl(),
  );

  locator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: locator<ApiClient>()),
  );

  locator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(storage: locator<FlutterSecureStorage>()),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: locator<AuthRemoteDataSource>(),
      localDataSource: locator<AuthLocalDataSource>(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );

  locator.registerLazySingleton<LoginWithEmailUseCase>(
    () => LoginWithEmailUseCase(authRepository: locator<AuthRepository>()),
  );

  locator.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginWithEmailUseCase: locator<LoginWithEmailUseCase>(),
      authRepository: locator<AuthRepository>(),
    ),
  );
}

