import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'tokens/app_colors.dart';
import 'tokens/app_typography.dart';

/// AppColors + AppTypography를 활용해 ThemeData 생성
class AppTheme {
  const AppTheme._();

  /// 라이트 테마
  static ThemeData light({
    ThemeBrand brand = ThemeBrand.defaultBrand,
    bool? isWebOverride,
  }) {
    final isWeb = isWebOverride ?? kIsWeb;
    final colors = AppColors.light(brand);
    final typography = isWeb ? AppTypography.web() : AppTypography.mobile();

    final scheme = _buildColorScheme(colors, isDark: false);

    return ThemeData(
      useMaterial3: true, // 필요 없으면 false로
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.surface,
      textTheme: typography.textTheme.apply(
        bodyColor: colors.textPrimary,
        displayColor: colors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surfaceElevated,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceElevated,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: DialogThemeData(backgroundColor: colors.surfaceElevated),
      // TODO: 버튼, 탭바, FAB 등등 공통 컴포넌트 스타일 추가
    );
  }

  /// 다크 테마
  static ThemeData dark({
    ThemeBrand brand = ThemeBrand.defaultBrand,
    bool? isWebOverride,
  }) {
    final isWeb = isWebOverride ?? kIsWeb;
    final colors = AppColors.dark(brand);
    final typography = isWeb ? AppTypography.web() : AppTypography.mobile();

    final scheme = _buildColorScheme(colors, isDark: true);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.surface,
      textTheme: typography.textTheme.apply(
        bodyColor: colors.textPrimary,
        displayColor: colors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surfaceElevated,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceElevated,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: DialogThemeData(backgroundColor: colors.surfaceElevated),
      // TODO: 다크 전용 컴포넌트 튜닝
    );
  }

  /// AppColors → ColorScheme 변환 레이어
  static ColorScheme _buildColorScheme(AppColors c, {required bool isDark}) {
    final brightness = isDark ? Brightness.dark : Brightness.light;

    return ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.surface,
      secondary: c.primaryVariant,
      onSecondary: c.surface,
      surface: c.surfaceElevated,
      onSurface: c.textPrimary,
      error: c.error,
      onError: c.surface,
    );
  }
}
