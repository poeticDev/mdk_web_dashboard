import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdk_app_theme/mdk_app_theme.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';
import 'package:web_dashboard/core/timetable/presentation/utils/lecture_color_resolver.dart';

void main() {
  final resolver = LectureColorResolver(AppColors.light(ThemeBrand.defaultBrand));

  LectureEntity buildLecture({
    LectureType type = LectureType.lecture,
    LectureStatus status = LectureStatus.scheduled,
    String? colorHex,
  }) {
    return LectureEntity(
      id: '1',
      title: '샘플',
      type: type,
      lectureStatus: status,
      classroomId: 'room-1',
      classroomName: '공학관 101',
      start: DateTime.utc(2025, 1, 1, 9),
      end: DateTime.utc(2025, 1, 1, 10),
      colorHex: colorHex,
      version: 1,
      createdAt: DateTime.utc(2024, 12, 31, 23, 59),
      updatedAt: DateTime.utc(2025, 1, 1),
    );
  }

  test('resolves lecture color by type', () {
    final color = resolver.resolveColor(buildLecture(type: LectureType.event));
    expect(color, isNotNull);
  });

  test('canceled lectures lower saturation', () {
    final active = resolver.resolveColor(buildLecture());
    final canceled =
        resolver.resolveColor(buildLecture(status: LectureStatus.canceled));
    expect(canceled.a, equals(1.0));
    expect(canceled.computeLuminance(), greaterThan(active.computeLuminance()));
  });

  test('uses custom colorHex when provided', () {
    final color = resolver.resolveColor(buildLecture(colorHex: '#123456'));
    expect(color.toARGB32(), equals(const Color(0xFF123456).toARGB32()));
  });
}
