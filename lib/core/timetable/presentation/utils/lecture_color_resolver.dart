import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mdk_app_theme/mdk_app_theme.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_status.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';

/// LectureType과 상태에 따른 색상을 계산한다.
class LectureColorResolver {
  const LectureColorResolver(this._colors);

  final AppColors _colors;

  Color resolveColor(LectureEntity lecture) {
    final LectureType type = lecture.type;
    Color baseColor;
    switch (type) {
      case LectureType.lecture:
        baseColor = _colors.primary;
        break;
      case LectureType.event:
        baseColor = _colors.success;
        break;
      case LectureType.exam:
        baseColor = _colors.error;
        break;
    }
    final double lightnessVariance =
        _computeVariance(lecture.title.hashCode, type.index);
    final HSLColor hsl = HSLColor.fromColor(baseColor);
    Color resolved = hsl
        .withLightness((hsl.lightness + lightnessVariance).clamp(0.2, 0.8))
        .toColor();
    if (lecture.status == LectureStatus.canceled) {
      resolved = HSLColor.fromColor(resolved)
          .withSaturation(0.2)
          .withLightness(math.min(0.9, hsl.lightness + 0.2))
          .toColor();
    }
    return resolved;
  }

  double _computeVariance(int hash, int seed) {
    final int mixed = hash ^ seed;
    final double normalized = (mixed % 20) / 100;
    return normalized - 0.1;
  }
}
