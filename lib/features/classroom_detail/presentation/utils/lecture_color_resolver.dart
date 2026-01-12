import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mdk_app_theme/mdk_app_theme.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_occurrence_entity.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_status.dart';
import 'package:web_dashboard/domains/schedule/domain/entities/lecture_type.dart';

/// LectureType과 상태에 따른 색상을 계산한다.
class LectureColorResolver {
  const LectureColorResolver(this._colors);

  final AppColors _colors;

  Color resolveColor(LectureEntity lecture) {
    final Color? customColor = _parseHexColor(lecture.colorHex);
    if (customColor != null) {
      return _applyCancellationTint(customColor, lecture.status);
    }

    final LectureType type = lecture.type;
    final Color baseColor = _baseColorByType(type);
    final double lightnessVariance =
        _computeVariance(lecture.title.hashCode, type.index);
    final HSLColor hsl = HSLColor.fromColor(baseColor);
    final Color varied = hsl
        .withLightness((hsl.lightness + lightnessVariance).clamp(0.2, 0.8))
        .toColor();
    return _applyCancellationTint(varied, lecture.status);
  }

  Color resolveColorForOccurrence(LectureOccurrenceEntity occurrence) {
    final Color? customColor = _parseHexColor(occurrence.colorHex);
    if (customColor != null) {
      return _applyCancellationTint(customColor, occurrence.status);
    }
    final LectureType type = occurrence.type;
    final Color baseColor = _baseColorByType(type);
    final double lightnessVariance =
        _computeVariance(occurrence.lectureId.hashCode, type.index);
    final HSLColor hsl = HSLColor.fromColor(baseColor);
    final Color varied = hsl
        .withLightness((hsl.lightness + lightnessVariance).clamp(0.2, 0.8))
        .toColor();
    return _applyCancellationTint(varied, occurrence.status);
  }

  Color _baseColorByType(LectureType type) {
    switch (type) {
      case LectureType.lecture:
        return _colors.primary;
      case LectureType.event:
        return _colors.success;
      case LectureType.exam:
        return _colors.error;
    }
  }

  Color? _parseHexColor(String? hex) {
    if (hex == null || hex.isEmpty) {
      return null;
    }
    final String normalized = hex.replaceAll('#', '').toUpperCase();
    if (normalized.length != 6 && normalized.length != 8) {
      return null;
    }
    final String value = normalized.length == 6 ? 'FF$normalized' : normalized;
    final int? colorValue = int.tryParse(value, radix: 16);
    if (colorValue == null) {
      return null;
    }
    return Color(colorValue);
  }

  Color _applyCancellationTint(Color source, LectureStatus status) {
    if (status != LectureStatus.canceled) {
      return source;
    }
    final HSLColor hsl = HSLColor.fromColor(source);
    return hsl
        .withSaturation(0.2)
        .withLightness(math.min(0.9, hsl.lightness + 0.2))
        .toColor();
  }

  double _computeVariance(int hash, int seed) {
    final int mixed = hash ^ seed;
    final double normalized = (mixed % 20) / 100;
    return normalized - 0.1;
  }
}
