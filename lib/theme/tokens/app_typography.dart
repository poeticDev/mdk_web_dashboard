import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 플랫폼별 TextTheme 설정을 담당
/// - 웹: GoogleFonts (웹폰트)
/// - 모바일: asset 폰트 (예: Pretendard)
class AppTypography {
  final TextTheme textTheme;

  const AppTypography._(this.textTheme);

  /// 웹 환경용 (GoogleFonts 기반)
  factory AppTypography.web() {
    final base = ThemeData.light().textTheme;
    final font = GoogleFonts.nanumGothic;
  
    return AppTypography._(
      base.copyWith(
        displayLarge: font(textStyle: base.displayLarge),
        displayMedium: font(textStyle: base.displayMedium),
        displaySmall: font(textStyle: base.displaySmall),
        headlineLarge: font(textStyle: base.headlineLarge),
        headlineMedium: font(textStyle: base.headlineMedium),
        headlineSmall: font(textStyle: base.headlineSmall),
        titleLarge: font(textStyle: base.titleLarge),
        titleMedium: font(textStyle: base.titleMedium),
        titleSmall: font(textStyle: base.titleSmall),
        bodyLarge: font(textStyle: base.bodyLarge),
        bodyMedium: font(textStyle: base.bodyMedium),
        bodySmall: font(textStyle: base.bodySmall),
        labelLarge: font(textStyle: base.labelLarge),
        labelMedium: font(textStyle: base.labelMedium),
        labelSmall: font(textStyle: base.labelSmall),
      ),
    );
  }

  /// 모바일/데스크톱 앱용 (asset 폰트 기반)
  factory AppTypography.mobile({String fontFamily = 'Pretendard Variable'}) {
    final base = ThemeData.light().textTheme;

    TextStyle apply(TextStyle? style) {
      return (style ?? const TextStyle()).copyWith(fontFamily: fontFamily);
    }

    return AppTypography._(
      base.copyWith(
        displayLarge: apply(base.displayLarge),
        displayMedium: apply(base.displayMedium),
        displaySmall: apply(base.displaySmall),
        headlineLarge: apply(base.headlineLarge),
        headlineMedium: apply(base.headlineMedium),
        headlineSmall: apply(base.headlineSmall),
        titleLarge: apply(base.titleLarge),
        titleMedium: apply(base.titleMedium),
        titleSmall: apply(base.titleSmall),
        bodyLarge: apply(base.bodyLarge),
        bodyMedium: apply(base.bodyMedium),
        bodySmall: apply(base.bodySmall),
        labelLarge: apply(base.labelLarge),
        labelMedium: apply(base.labelMedium),
        labelSmall: apply(base.labelSmall),
      ),
    );
  }
}
