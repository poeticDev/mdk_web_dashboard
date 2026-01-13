/// ROLE
/// - provider 모음을 제공한다
///
/// RESPONSIBILITY
/// - 의존성을 주입한다
///
/// DEPENDS ON
/// - flutter_riverpod
/// - delete_lecture_usecase
/// - delete_lecture_occurrence_usecase
/// - get_lecture_occurrences_usecase
/// - get_lectures_usecase
/// - create_lecture_occurrence_usecase
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/domains/schedule/application/usecases/delete_lecture_usecase.dart';
import 'package:web_dashboard/domains/schedule/application/usecases/delete_lecture_occurrence_usecase.dart';
import 'package:web_dashboard/domains/schedule/application/usecases/get_lecture_occurrences_usecase.dart';
import 'package:web_dashboard/domains/schedule/application/usecases/get_lectures_usecase.dart';
import 'package:web_dashboard/domains/schedule/application/usecases/create_lecture_occurrence_usecase.dart';
import 'package:web_dashboard/domains/schedule/application/usecases/update_lecture_occurrence_usecase.dart';
import 'package:web_dashboard/domains/schedule/application/usecases/save_lecture_usecase.dart';
import 'package:web_dashboard/domains/schedule/data/datasources/lecture_occurrence_remote_data_source.dart';
import 'package:web_dashboard/domains/schedule/data/datasources/lecture_origin_remote_data_source.dart';
import 'package:web_dashboard/domains/schedule/data/mappers/lecture_mapper.dart';
import 'package:web_dashboard/domains/schedule/data/mappers/lecture_occurrence_mapper.dart';
import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_occurrence_repository.dart';
import 'package:web_dashboard/domains/schedule/domain/repositories/lecture_origin_repository.dart';
import 'package:web_dashboard/di/service_locator.dart';

/// Lecture(master) DTO ↔ Entity 변환기.
final Provider<LectureMapper> lectureMapperProvider = Provider<LectureMapper>(
  (Ref ref) => di<LectureMapper>(),
);

/// Lecture occurrence DTO ↔ Entity 변환기.
final Provider<LectureOccurrenceMapper> lectureOccurrenceMapperProvider =
    Provider<LectureOccurrenceMapper>(
  (Ref ref) => di<LectureOccurrenceMapper>(),
);

/// Lecture(master) REST 호출 데이터 소스.
final Provider<LectureOriginRemoteDataSource> lectureRemoteDataSourceProvider =
    Provider<LectureOriginRemoteDataSource>(
  (Ref ref) => di<LectureOriginRemoteDataSource>(),
);

/// Lecture occurrence REST 호출 데이터 소스.
final Provider<LectureOccurrenceRemoteDataSource>
    lectureOccurrenceRemoteDataSourceProvider =
    Provider<LectureOccurrenceRemoteDataSource>(
  (Ref ref) => di<LectureOccurrenceRemoteDataSource>(),
);

/// Lecture(master) 저장소.
final Provider<LectureOriginRepository> lectureRepositoryProvider =
    Provider<LectureOriginRepository>(
  (Ref ref) => di<LectureOriginRepository>(),
);

/// Lecture occurrence 저장소.
final Provider<LectureOccurrenceRepository> lectureOccurrenceRepositoryProvider =
    Provider<LectureOccurrenceRepository>(
  (Ref ref) => di<LectureOccurrenceRepository>(),
);

/// Lecture 목록 조회 유즈케이스.
final Provider<GetLecturesUseCase> getLecturesUseCaseProvider =
    Provider<GetLecturesUseCase>(
  (Ref ref) => GetLecturesUseCase(ref.watch(lectureRepositoryProvider)),
);

/// Occurrence 범위 조회 유즈케이스.
final Provider<GetLectureOccurrencesUseCase>
    getLectureOccurrencesUseCaseProvider =
    Provider<GetLectureOccurrencesUseCase>(
  (Ref ref) => GetLectureOccurrencesUseCase(
    ref.watch(lectureOccurrenceRepositoryProvider),
  ),
);

/// Occurrence 생성 유즈케이스.
final Provider<CreateLectureOccurrenceUseCase>
    createLectureOccurrenceUseCaseProvider =
    Provider<CreateLectureOccurrenceUseCase>(
  (Ref ref) => CreateLectureOccurrenceUseCase(
    ref.watch(lectureOccurrenceRepositoryProvider),
  ),
);

/// Occurrence 수정 유즈케이스.
final Provider<UpdateLectureOccurrenceUseCase>
    updateLectureOccurrenceUseCaseProvider =
    Provider<UpdateLectureOccurrenceUseCase>(
  (Ref ref) => UpdateLectureOccurrenceUseCase(
    ref.watch(lectureOccurrenceRepositoryProvider),
  ),
);

/// Occurrence 삭제 유즈케이스.
final Provider<DeleteLectureOccurrenceUseCase>
    deleteLectureOccurrenceUseCaseProvider =
    Provider<DeleteLectureOccurrenceUseCase>(
  (Ref ref) => DeleteLectureOccurrenceUseCase(
    ref.watch(lectureOccurrenceRepositoryProvider),
  ),
);

/// Lecture 생성/수정 유즈케이스.
final Provider<SaveLectureUseCase> saveLectureUseCaseProvider =
    Provider<SaveLectureUseCase>(
  (Ref ref) => SaveLectureUseCase(ref.watch(lectureRepositoryProvider)),
);

/// Lecture 삭제 유즈케이스.
final Provider<DeleteLectureUseCase> deleteLectureUseCaseProvider =
    Provider<DeleteLectureUseCase>(
  (Ref ref) => DeleteLectureUseCase(ref.watch(lectureRepositoryProvider)),
);
