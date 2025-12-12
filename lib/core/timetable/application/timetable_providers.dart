import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/core/timetable/application/usecases/delete_lecture_usecase.dart';
import 'package:web_dashboard/core/timetable/application/usecases/get_lectures_usecase.dart';
import 'package:web_dashboard/core/timetable/application/usecases/save_lecture_usecase.dart';
import 'package:web_dashboard/core/timetable/data/datasources/lecture_remote_data_source.dart';
import 'package:web_dashboard/core/timetable/data/mappers/lecture_mapper.dart';
import 'package:web_dashboard/core/timetable/data/repositories/lecture_repository_impl.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_repository.dart';
import 'package:web_dashboard/di/service_locator.dart';

final Provider<LectureMapper> lectureMapperProvider = Provider<LectureMapper>(
  (Ref ref) => di<LectureMapper>(),
);

final Provider<LectureRemoteDataSource> lectureRemoteDataSourceProvider =
    Provider<LectureRemoteDataSource>(
  (Ref ref) => di<LectureRemoteDataSource>(),
);

final Provider<LectureRepository> lectureRepositoryProvider =
    Provider<LectureRepository>(
  (Ref ref) => di<LectureRepository>(),
);

final Provider<GetLecturesUseCase> getLecturesUseCaseProvider =
    Provider<GetLecturesUseCase>(
  (Ref ref) => GetLecturesUseCase(ref.watch(lectureRepositoryProvider)),
);

final Provider<SaveLectureUseCase> saveLectureUseCaseProvider =
    Provider<SaveLectureUseCase>(
  (Ref ref) => SaveLectureUseCase(ref.watch(lectureRepositoryProvider)),
);

final Provider<DeleteLectureUseCase> deleteLectureUseCaseProvider =
    Provider<DeleteLectureUseCase>(
  (Ref ref) => DeleteLectureUseCase(ref.watch(lectureRepositoryProvider)),
);
