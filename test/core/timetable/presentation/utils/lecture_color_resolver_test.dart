import 'package:flutter_test/flutter_test.dart';
import 'package:mdk_app_theme/mdk_app_theme.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';
import 'package:web_dashboard/core/timetable/presentation/utils/lecture_color_resolver.dart';

void main() {
  final resolver = LectureColorResolver(AppColors.light(ThemeBrand.defaultBrand));

  LectureEntity _build({
    LectureType type = LectureType.lecture,
    LectureStatus status = LectureStatus.scheduled,
  }) {
    return LectureEntity(
      id: '1',
      title: '샘플',
      type: type,
      status: status,
      classroomId: 'room-1',
      classroomName: '공학관 101',
      start: DateTime.utc(2025, 1, 1, 9),
      end: DateTime.utc(2025, 1, 1, 10),
    );
  }

  test('resolves lecture color by type', () {
    final color = resolver.resolveColor(_build(type: LectureType.event));
    expect(color, isNotNull);
  });

  test('canceled lectures lower saturation', () {
    final active = resolver.resolveColor(_build());
    final canceled =
        resolver.resolveColor(_build(status: LectureStatus.canceled));
    expect(canceled.opacity, equals(1.0));
    expect(canceled.computeLuminance(), greaterThan(active.computeLuminance()));
  });
}
