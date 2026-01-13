import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_dashboard/features/classroom_detail/application/classroom_detail_providers.dart';
import 'package:web_dashboard/domains/schedule/data/datasources/classroom_now_remote_data_source.dart';
import 'package:web_dashboard/domains/schedule/application/timetable_providers.dart';
import 'package:web_dashboard/domains/schedule/data/dtos/lecture_occurrence_dto.dart';
import 'package:web_dashboard/domains/schedule/data/mappers/lecture_occurrence_mapper.dart';

void main() {
  group('classroomNowViewModelProvider', () {
    test('returns isInSession=false when no occurrence', () async {
      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          classroomNowRemoteDataSourceProvider.overrideWithValue(
            _FakeNowDataSource(
              const ClassroomNowResponseDto(isIdle: true, occurrence: null),
            ),
          ),
          lectureOccurrenceMapperProvider.overrideWithValue(
            const LectureOccurrenceMapper(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final ClassroomNowViewModel result = await container.read(
        classroomNowViewModelProvider('room-1').future,
      );

      expect(result.isInSession, isFalse);
    });

    test('maps occurrence data to view model', () async {
      final ClassroomNowViewModel viewModel = await ProviderContainer(
        overrides: <Override>[
          classroomNowRemoteDataSourceProvider.overrideWithValue(
            _FakeNowDataSource(
              ClassroomNowResponseDto(
                isIdle: false,
                occurrence: LectureOccurrenceDto(
                  id: 'occ-1',
                  lectureId: 'lec-1',
                  classroomId: 'room-1',
                  classroomName: '공학관 room-1',
                  title: 'AI 개론',
                  type: 'lecture',
                  status: 'scheduled',
                  isOverride: false,
                  sourceVersion: 1,
                  startAt: DateTime.utc(2025, 1, 1, 9),
                  endAt: DateTime.utc(2025, 1, 1, 10),
                ),
              ),
            ),
          ),
          lectureOccurrenceMapperProvider.overrideWithValue(
            const LectureOccurrenceMapper(),
          ),
        ],
      ).read(classroomNowViewModelProvider('room-1').future);

      expect(viewModel.isInSession, isTrue);
      expect(viewModel.currentCourseName, 'AI 개론');
    });
  });
}

class _FakeNowDataSource implements ClassroomNowRemoteDataSource {
  const _FakeNowDataSource(this.response);

  final ClassroomNowResponseDto? response;

  @override
  Future<ClassroomNowResponseDto?> fetchCurrent({
    required String classroomId,
  }) async {
    return response;
  }
}
