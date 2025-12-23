import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/core/timetable/application/usecases/delete_lecture_usecase.dart';
import 'package:web_dashboard/core/timetable/application/usecases/get_lecture_occurrences_usecase.dart';
import 'package:web_dashboard/core/timetable/application/usecases/get_lectures_usecase.dart';
import 'package:web_dashboard/core/timetable/application/usecases/save_lecture_usecase.dart';
import 'package:web_dashboard/core/timetable/data/datasources/lecture_occurrence_remote_data_source.dart';
import 'package:web_dashboard/core/timetable/data/datasources/lecture_remote_data_source.dart';
import 'package:web_dashboard/core/timetable/data/mappers/lecture_mapper.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_occurrence_repository.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_repository.dart';
import 'package:web_dashboard/di/service_locator.dart';

/// Lecture(master) DTO ↔ Entity 변환기.
final Provider<LectureMapper> lectureMapperProvider = Provider<LectureMapper>(
  (Ref ref) => di<LectureMapper>(),
);

/// Lecture(master) REST 호출 데이터 소스.
final Provider<LectureRemoteDataSource> lectureRemoteDataSourceProvider =
    Provider<LectureRemoteDataSource>(
  (Ref ref) => di<LectureRemoteDataSource>(),
);

/// Lecture occurrence REST 호출 데이터 소스.
final Provider<LectureOccurrenceRemoteDataSource>
    lectureOccurrenceRemoteDataSourceProvider =
    Provider<LectureOccurrenceRemoteDataSource>(
  (Ref ref) => di<LectureOccurrenceRemoteDataSource>(),
);

/// Lecture(master) 저장소.
final Provider<LectureRepository> lectureRepositoryProvider =
    Provider<LectureRepository>(
  (Ref ref) => di<LectureRepository>(),
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
