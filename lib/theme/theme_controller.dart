import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_theme.dart';
import 'tokens/app_colors.dart';

/// AdaptiveTheme와 AppTheme를 활용한 테마 관리 클래스
/// Riverpod 기반 ThemeController
final themeControllerProvider = Provider<ThemeController>((ref) {
  return ThemeController();
});

class ThemeController {
  /// 저장된 ThemeMode를 로드 (main()에서 사용)
  Future<AdaptiveThemeMode?> loadSavedThemeMode() {
    return AdaptiveTheme.getThemeMode();
  }

  /// 현재 적용 중인 ThemeMode (system도 내부 상태에 따라 light/dark로 해석)
  AdaptiveThemeMode effectiveMode(BuildContext context) {
    final adaptive = AdaptiveTheme.of(context);
    final AdaptiveThemeMode mode = adaptive.mode;
    if (mode == AdaptiveThemeMode.system) {
      final Brightness brightness = Theme.of(context).brightness;
      return brightness == Brightness.dark
          ? AdaptiveThemeMode.dark
          : AdaptiveThemeMode.light;
    }
    return mode;
  }

  bool isDarkMode(BuildContext context) {
    return effectiveMode(context) == AdaptiveThemeMode.dark;
  }

  /// light ↔ dark 토글 (system은 처음 토글 시 dark로 보냄)
  Future<void> toggle(BuildContext context) async {
    final adaptive = AdaptiveTheme.of(context);
    final mode = adaptive.mode;

    switch (mode) {
      case AdaptiveThemeMode.light:
        adaptive.setDark();
        break;
      case AdaptiveThemeMode.dark:
        adaptive.setLight();
        break;
      case AdaptiveThemeMode.system:
        // 정책: system → 처음 토글 시 다크로
        adaptive.setDark();
        break;
    }
  }

  /// (확장용) 브랜드를 바꾸고 싶을 때 ThemeData 전체를 교체하는 메서드
  Future<void> setBrand(
    BuildContext context, {
    required ThemeBrand brand,
    bool? isWebOverride,
  }) async {
    final isWeb = isWebOverride;
    final mode = AdaptiveTheme.of(context).mode;
    final lightTheme = AppTheme.light(brand: brand, isWebOverride: isWeb);
    final darkTheme = AppTheme.dark(brand: brand, isWebOverride: isWeb);

    switch (mode) {
      case AdaptiveThemeMode.light:
        AdaptiveTheme.of(context).setTheme(light: lightTheme, dark: darkTheme);
        AdaptiveTheme.of(context).setLight();
        break;
      case AdaptiveThemeMode.dark:
        AdaptiveTheme.of(context).setTheme(light: lightTheme, dark: darkTheme);
        AdaptiveTheme.of(context).setDark();
        break;
      case AdaptiveThemeMode.system:
        // 현재는 defaultBrand만 사용. 확장 대비 setSystem 유지.
        AdaptiveTheme.of(context).setTheme(light: lightTheme, dark: darkTheme);
        AdaptiveTheme.of(context).setSystem();
        break;
    }
  }
}
