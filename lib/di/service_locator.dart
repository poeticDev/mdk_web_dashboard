import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:web_dashboard/common/network/dio_client.dart';
import 'package:web_dashboard/core/auth/data/datasources/auth_remote_data_source.dart';
import 'package:web_dashboard/core/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:web_dashboard/core/auth/data/repositories/auth_repository_impl.dart';
import 'package:web_dashboard/core/auth/domain/repositories/auth_repository.dart';
import 'package:web_dashboard/core/timetable/data/datasources/lecture_origin_remote_data_source.dart';
import 'package:web_dashboard/core/timetable/data/datasources/lecture_origin_remote_data_source.dart'
    as timetable_remote;
import 'package:web_dashboard/core/timetable/data/datasources/lecture_occurrence_remote_data_source.dart';
import 'package:web_dashboard/core/timetable/data/datasources/lecture_occurrence_remote_data_source.dart'
    as occurrence_remote;
import 'package:web_dashboard/core/timetable/data/mappers/lecture_mapper.dart';
import 'package:web_dashboard/core/timetable/data/mappers/lecture_occurrence_mapper.dart';
import 'package:web_dashboard/core/timetable/data/repositories/lecture_occurrence_repository_impl.dart';
import 'package:web_dashboard/core/timetable/data/repositories/lecture_origin_repository_impl.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_occurrence_repository.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_origin_repository.dart';

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
  if (!di.isRegistered<LectureMapper>()) {
    di.registerLazySingleton<LectureMapper>(() => const LectureMapper());
  }
  if (!di.isRegistered<LectureOccurrenceMapper>()) {
    di.registerLazySingleton<LectureOccurrenceMapper>(
      () => const LectureOccurrenceMapper(),
    );
  }
  if (!di.isRegistered<LectureOriginRemoteDataSource>()) {
    di.registerLazySingleton<LectureOriginRemoteDataSource>(
      () => timetable_remote.LectureOriginRemoteDataSourceImpl(dio: di()),
    );
  }
  if (!di.isRegistered<LectureOriginRepository>()) {
    di.registerLazySingleton<LectureOriginRepository>(
      () => LectureOriginRepositoryImpl(
        remoteDataSource: di(),
        mapper: di(),
      ),
    );
  }
  if (!di.isRegistered<LectureOccurrenceRemoteDataSource>()) {
    di.registerLazySingleton<LectureOccurrenceRemoteDataSource>(
      () => occurrence_remote.LectureOccurrenceRemoteDataSourceImpl(dio: di()),
    );
  }
  if (!di.isRegistered<LectureOccurrenceRepository>()) {
    di.registerLazySingleton<LectureOccurrenceRepository>(
      () => LectureOccurrenceRepositoryImpl(
        remoteDataSource: di(),
        mapper: di(),
      ),
    );
  }
}
