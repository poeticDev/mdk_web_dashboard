import 'dart:ui' show FontVariation;

import 'package:flutter/material.dart';

/// 플랫폼별 TextTheme 설정을 담당
/// - 웹/모바일 모두 asset 기반 variable font 사용
class AppTypography {
  static const String defaultFontFamily = 'Pretendard Variable';
  static const List<FontVariation> boldFontVariations = <FontVariation>[
    FontVariation('wght', 700),
  ];
  static const List<FontVariation> semiBoldFontVariations = <FontVariation>[
    FontVariation('wght', 600),
  ];
  static const List<FontVariation> mediumFontVariations = <FontVariation>[
    FontVariation('wght', 500),
  ];
  static const List<FontVariation> regularFontVariations = <FontVariation>[
    FontVariation('wght', 400),
  ];

  final TextTheme textTheme;

  const AppTypography._(this.textTheme);

  /// 웹 환경: 헤드라인 가독성을 위한 소폭 스케일 업
  factory AppTypography.web({String fontFamily = defaultFontFamily}) {
    final TextTheme base = ThemeData.light().textTheme;
    return AppTypography._(
      _buildTextTheme(base, fontFamily: fontFamily, headlineScale: 1.04),
    );
  }

  /// 모바일/데스크톱 앱용 (asset 폰트 기반)
  factory AppTypography.mobile({String fontFamily = defaultFontFamily}) {
    final TextTheme base = ThemeData.light().textTheme;
    return AppTypography._(_buildTextTheme(base, fontFamily: fontFamily));
  }

  static TextTheme _buildTextTheme(
    TextTheme base, {
    required String fontFamily,
    double headlineScale = 1.0,
  }) {
    TextStyle apply(
      TextStyle? style,
      List<FontVariation> variations, {
      double scale = 1.0,
    }) {
      final TextStyle resolved = style ?? const TextStyle();
      final double? fontSize = resolved.fontSize == null
          ? null
          : resolved.fontSize! * scale;
      return resolved.copyWith(
        fontFamily: fontFamily,
        fontVariations: variations,
        fontSize: fontSize,
      );
    }

    return base.copyWith(
      displayLarge: apply(
        base.displayLarge,
        boldFontVariations,
        scale: headlineScale,
      ),
      displayMedium: apply(
        base.displayMedium,
        boldFontVariations,
        scale: headlineScale,
      ),
      displaySmall: apply(base.displaySmall, boldFontVariations),
      headlineLarge: apply(
        base.headlineLarge,
        boldFontVariations,
        scale: headlineScale,
      ),
      headlineMedium: apply(base.headlineMedium, semiBoldFontVariations),
      headlineSmall: apply(base.headlineSmall, semiBoldFontVariations),
      titleLarge: apply(base.titleLarge, boldFontVariations),
      titleMedium: apply(base.titleMedium, semiBoldFontVariations),
      titleSmall: apply(base.titleSmall, mediumFontVariations),
      bodyLarge: apply(base.bodyLarge, mediumFontVariations),
      bodyMedium: apply(base.bodyMedium, mediumFontVariations),
      bodySmall: apply(base.bodySmall, regularFontVariations),
      labelLarge: apply(base.labelLarge, mediumFontVariations),
      labelMedium: apply(base.labelMedium, regularFontVariations),
      labelSmall: apply(base.labelSmall, regularFontVariations),
    );
  }
}
