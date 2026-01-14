import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:web_dashboard/common/network/dio_client.dart';
import 'package:web_dashboard/domains/auth/data/datasources/auth_remote_data_source.dart';
import 'package:web_dashboard/domains/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:web_dashboard/domains/auth/data/repositories/auth_repository_impl.dart';
import 'package:web_dashboard/domains/auth/domain/repositories/auth_repository.dart';
import 'package:web_dashboard/domains/foundation/data/datasources/classroom_detail_remote_data_source.dart';
import 'package:web_dashboard/domains/foundation/data/datasources/foundation_classrooms_remote_data_source.dart';
import 'package:web_dashboard/domains/schedule/data/datasources/classroom_now_remote_data_source.dart';
import 'package:web_dashboard/domains/foundation/data/mappers/classroom_detail_mapper.dart';
import 'package:web_dashboard/domains/foundation/data/mappers/foundation_classrooms_mapper.dart';
import 'package:web_dashboard/domains/devices/domain/repositories/classroom_device_repository.dart';
import 'package:web_dashboard/domains/foundation/data/repositories/classroom_detail_repository_impl.dart';
import 'package:web_dashboard/domains/foundation/data/repositories/foundation_classrooms_read_repository_impl.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/classroom_repository.dart';
import 'package:web_dashboard/domains/foundation/data/datasources/department_directory_remote_data_source.dart';
import 'package:web_dashboard/domains/auth/data/datasources/user_directory_remote_data_source.dart';
import 'package:web_dashboard/domains/foundation/data/mappers/department_directory_mapper.dart';
import 'package:web_dashboard/common/search/pagination_meta_mapper.dart';
import 'package:web_dashboard/domains/auth/data/mappers/user_directory_mapper.dart';
import 'package:web_dashboard/domains/foundation/data/repositories/department_directory_read_repository_impl.dart';
import 'package:web_dashboard/domains/auth/data/repositories/user_directory_read_repository_impl.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/department_directory_read_repository.dart';
import 'package:web_dashboard/domains/foundation/domain/repositories/foundation_classrooms_read_repository.dart';
import 'package:web_dashboard/domains/auth/domain/repositories/user_directory_read_repository.dart';
import 'package:web_dashboard/domains/realtime/data/datasources/occurrence_now_sse_remote_data_source.dart';
import 'package:web_dashboard/domains/realtime/data/datasources/room_state_sse_remote_data_source.dart';
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
import 'package:web_dashboard/common/network/sse_client.dart';

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
  if (!di.isRegistered<SseClient>()) {
    di.registerFactory<SseClient>(() => createSseClient());
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
  if (!di.isRegistered<FoundationClassroomsMapper>()) {
    di.registerLazySingleton<FoundationClassroomsMapper>(
      () => const FoundationClassroomsMapper(),
    );
  }
  if (!di.isRegistered<ClassroomDetailRemoteDataSource>()) {
    di.registerLazySingleton<ClassroomDetailRemoteDataSource>(
      () => ClassroomDetailRemoteDataSourceImpl(dio: di()),
    );
  }
  if (!di.isRegistered<FoundationClassroomsRemoteDataSource>()) {
    di.registerLazySingleton<FoundationClassroomsRemoteDataSource>(
      () => FoundationClassroomsRemoteDataSourceImpl(dio: di()),
    );
  }
  if (!di.isRegistered<ClassroomDetailRepositoryImpl>()) {
    di.registerLazySingleton<ClassroomDetailRepositoryImpl>(
      () => ClassroomDetailRepositoryImpl(
        remoteDataSource: di(),
        mapper: di(),
      ),
    );
  }
  if (!di.isRegistered<FoundationClassroomsReadRepository>()) {
    di.registerLazySingleton<FoundationClassroomsReadRepository>(
      () => FoundationClassroomsReadRepositoryImpl(
        remoteDataSource: di(),
        mapper: di(),
      ),
    );
  }
  if (!di.isRegistered<ClassroomRepository>()) {
    di.registerLazySingleton<ClassroomRepository>(
      () => di<ClassroomDetailRepositoryImpl>(),
    );
  }
  if (!di.isRegistered<ClassroomDeviceRepository>()) {
    di.registerLazySingleton<ClassroomDeviceRepository>(
      () => di<ClassroomDetailRepositoryImpl>(),
    );
  }
  if (!di.isRegistered<ClassroomNowRemoteDataSource>()) {
    di.registerLazySingleton<ClassroomNowRemoteDataSource>(
      () => ClassroomNowRemoteDataSourceImpl(dio: di()),
    );
  }
  if (!di.isRegistered<RoomStateSseRemoteDataSource>()) {
    di.registerLazySingleton<RoomStateSseRemoteDataSource>(
      () => RoomStateSseRemoteDataSourceImpl(
        dio: di(),
        sseClient: di(),
      ),
    );
  }
  if (!di.isRegistered<OccurrenceNowSseRemoteDataSource>()) {
    di.registerLazySingleton<OccurrenceNowSseRemoteDataSource>(
      () => OccurrenceNowSseRemoteDataSourceImpl(
        dio: di(),
        sseClient: di(),
      ),
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
  if (!di.isRegistered<DepartmentDirectoryReadRepository>()) {
    di.registerLazySingleton<DepartmentDirectoryReadRepository>(
      () => DepartmentDirectoryReadRepositoryImpl(
        remoteDataSource: di(),
        mapper: di(),
        metaMapper: di(),
      ),
    );
  }
  if (!di.isRegistered<UserDirectoryReadRepository>()) {
    di.registerLazySingleton<UserDirectoryReadRepository>(
      () => UserDirectoryReadRepositoryImpl(
        remoteDataSource: di(),
        mapper: di(),
        metaMapper: di(),
      ),
    );
  }
}
