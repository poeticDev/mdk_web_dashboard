import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:web_dashboard/common/network/dio_client.dart';
import 'package:web_dashboard/core/auth/data/datasources/auth_remote_data_source.dart';
import 'package:web_dashboard/core/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:web_dashboard/core/auth/data/repositories/auth_repository_impl.dart';
import 'package:web_dashboard/core/auth/domain/repositories/auth_repository.dart';

final GetIt di = GetIt.instance;

Future<void> initDependencies() async {
  if (!di.isRegistered<Dio>()) {
    di.registerLazySingleton<Dio>(() => const DioClientFactory().create());
  }
  if (!di.isRegistered<AuthRemoteDataSource>()) {
    di.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(di()),
    );
  }
  if (!di.isRegistered<AuthRepository>()) {
    di.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(di()));
  }
}
