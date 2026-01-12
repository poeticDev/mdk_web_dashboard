import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:web_dashboard/common/network/dio_client.dart';
import 'package:web_dashboard/domains/auth/data/datasources/auth_remote_data_source.dart';
import 'package:web_dashboard/domains/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:web_dashboard/domains/auth/data/repositories/auth_repository_impl.dart';
import 'package:web_dashboard/domains/auth/domain/repositories/auth_repository.dart';
import 'package:web_dashboard/core/classroom_detail/data/datasources/classroom_detail_remote_data_source.dart';
import 'package:web_dashboard/core/classroom_detail/data/datasources/classroom_now_remote_data_source.dart';
import 'package:web_dashboard/core/classroom_detail/data/mappers/classroom_detail_mapper.dart';
import 'package:web_dashboard/core/classroom_detail/data/repositories/classroom_detail_repository_impl.dart';
import 'package:web_dashboard/core/classroom_detail/domain/repositories/classroom_detail_repository.dart';
import 'package:web_dashboard/core/directory/data/datasources/department_directory_remote_data_source.dart';
import 'package:web_dashboard/core/directory/data/datasources/user_directory_remote_data_source.dart';
import 'package:web_dashboard/core/directory/data/mappers/department_directory_mapper.dart';
import 'package:web_dashboard/core/directory/data/mappers/pagination_meta_mapper.dart';
import 'package:web_dashboard/core/directory/data/mappers/user_directory_mapper.dart';
import 'package:web_dashboard/core/directory/data/repositories/department_directory_repository_impl.dart';
import 'package:web_dashboard/core/directory/data/repositories/user_directory_repository_impl.dart';
import 'package:web_dashboard/core/directory/domain/repositories/department_directory_repository.dart';
import 'package:web_dashboard/core/directory/domain/repositories/user_directory_repository.dart';
import 'package:web_dashboard/domains/schedule/data/datasources/lecture_origin_remote_data_source.dart';
import 'package:web_dashboard/domains/schedule/data/datasources/lecture_origin_remote_data_source.dart'
    as timetable_remote;
import 'package:web_dashboard/domains/schedule/data/datasources/lecture_occurrence_remote_data_source.dart';
import 'package:web_dashboard/domains/schedule/data/datasources/lecture_occurrence_remote_data_source.dart'
    as occurrence_remote;
import 'package:web_dashboard/domains/schedule/data/mappers/lecture_mapper.dart';
import 'package:web_dashboard/domains/schedule/data/mappers/lecture_occurrence_mapper.dart';
import 'package:web_dashboard/domains/schedule/data/repositories/lecture_occurrence_repository_impl.dart';
import 'package:web_dashboard/domains/schedule/data/repositories/lecture_origin_repository_impl.dart';
import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_occurrence_repository.dart';
import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_origin_repository.dart';

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
  if (!di.isRegistered<ClassroomDetailMapper>()) {
    di.registerLazySingleton<ClassroomDetailMapper>(
      () => const ClassroomDetailMapper(),
    );
  }
  if (!di.isRegistered<ClassroomDetailRemoteDataSource>()) {
    di.registerLazySingleton<ClassroomDetailRemoteDataSource>(
      () => ClassroomDetailRemoteDataSourceImpl(dio: di()),
    );
  }
  if (!di.isRegistered<ClassroomDetailRepository>()) {
    di.registerLazySingleton<ClassroomDetailRepository>(
      () => ClassroomDetailRepositoryImpl(
        remoteDataSource: di(),
        mapper: di(),
      ),
    );
  }
  if (!di.isRegistered<ClassroomNowRemoteDataSource>()) {
    di.registerLazySingleton<ClassroomNowRemoteDataSource>(
      () => ClassroomNowRemoteDataSourceImpl(dio: di()),
    );
  }
  if (!di.isRegistered<PaginationMetaMapper>()) {
    di.registerLazySingleton<PaginationMetaMapper>(
      () => const PaginationMetaMapper(),
    );
  }
  if (!di.isRegistered<DepartmentDirectoryMapper>()) {
    di.registerLazySingleton<DepartmentDirectoryMapper>(
      () => const DepartmentDirectoryMapper(),
    );
  }
  if (!di.isRegistered<UserDirectoryMapper>()) {
    di.registerLazySingleton<UserDirectoryMapper>(
      () => const UserDirectoryMapper(),
    );
  }
  if (!di.isRegistered<DepartmentDirectoryRemoteDataSource>()) {
    di.registerLazySingleton<DepartmentDirectoryRemoteDataSource>(
      () => DepartmentDirectoryRemoteDataSourceImpl(dio: di()),
    );
  }
  if (!di.isRegistered<UserDirectoryRemoteDataSource>()) {
    di.registerLazySingleton<UserDirectoryRemoteDataSource>(
      () => UserDirectoryRemoteDataSourceImpl(dio: di()),
    );
  }
  if (!di.isRegistered<DepartmentDirectoryRepository>()) {
    di.registerLazySingleton<DepartmentDirectoryRepository>(
      () => DepartmentDirectoryRepositoryImpl(
        remoteDataSource: di(),
        mapper: di(),
        metaMapper: di(),
      ),
    );
  }
  if (!di.isRegistered<UserDirectoryRepository>()) {
    di.registerLazySingleton<UserDirectoryRepository>(
      () => UserDirectoryRepositoryImpl(
        remoteDataSource: di(),
        mapper: di(),
        metaMapper: di(),
      ),
    );
  }
}
