import 'package:flutter/material.dart';

/// 사용가능한 테마 브랜드
enum ThemeBrand { defaultBrand }

/// 앱 전체에서 사용할 semantic color들을 정의
class AppColors {
  final Color primary;
  final Color primaryVariant;

  final Color surface;
  final Color surfaceElevated;

  final Color textPrimary;
  final Color textSecondary;

  final Color success;
  final Color warning;
  final Color error;

  const AppColors({
    required this.primary,
    required this.primaryVariant,
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.error,
  });

  /// 브랜드 + 라이트/다크 조합으로 분기
  factory AppColors.light(ThemeBrand brand) {
    switch (brand) {
      case ThemeBrand.defaultBrand:
        return const AppColors(
          primary: Color(0xFF626AE8),
          primaryVariant: Color(0xff334479),
          surface: Color(0xFFEFEFEF),
          surfaceElevated: Color(0xFFFAFAFA),
          textPrimary: Color(0xFF2C2C2C),
          textSecondary: Color(0xFF485157),
          success: Color(0xFF70B38C),
          warning: Color(0xFFFFC785),
          error: Color(0xFFE26D72),
        );
    }
  }

  factory AppColors.dark(ThemeBrand brand) {
    switch (brand) {
      case ThemeBrand.defaultBrand:
        return const AppColors(
          primary: Color(0xFF626AE8),
          primaryVariant: Color(0xff334479),
          surface: Color(0xFF1B2028),
          surfaceElevated: Color(0xFF242A34),
          textPrimary: Color(0xFFE8EAED),
          textSecondary: Color(0xFFB0B8C2),
          success: Color(0xFF4FA083),
          warning: Color(0xFFFFC785),
          error: Color(0xFFE08A66),
        );
    }
  }
}
