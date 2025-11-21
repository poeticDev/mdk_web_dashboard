import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'tokens/app_colors.dart';
import 'tokens/app_typography.dart';

const BorderRadius _baseBorderRadius = BorderRadius.all(Radius.circular(12));
const RoundedRectangleBorder _cardShape = RoundedRectangleBorder(
  borderRadius: _baseBorderRadius,
);
const RoundedRectangleBorder _buttonShape = RoundedRectangleBorder(
  borderRadius: _baseBorderRadius,
);
const BorderRadius _fabBorderRadius = BorderRadius.all(Radius.circular(16));
const RoundedRectangleBorder _fabShape = RoundedRectangleBorder(
  borderRadius: _fabBorderRadius,
);
const double _buttonHeight = 48;
const Size _buttonMinSize = Size(64, _buttonHeight);
const EdgeInsets _buttonPadding = EdgeInsets.symmetric(
  horizontal: 20,
  vertical: 12,
);
const EdgeInsets _inputPadding = EdgeInsets.symmetric(
  horizontal: 16,
  vertical: 14,
);
const EdgeInsets _chipPadding = EdgeInsets.symmetric(
  horizontal: 12,
  vertical: 6,
);
const double _inputBorderWidth = 1.4;
const double _tabIndicatorWeight = 2;
const double _dividerThickness = 1;
const double _snackBarElevation = 2;
const EdgeInsets _snackBarInset = EdgeInsets.symmetric(
  horizontal: 16,
  vertical: 12,
);
const EdgeInsets _tooltipPadding = EdgeInsets.symmetric(
  horizontal: 10,
  vertical: 6,
);

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
    final textTheme = typography.textTheme.apply(
      bodyColor: colors.textPrimary,
      displayColor: colors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true, // 필요 없으면 false로
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surfaceElevated,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceElevated,
        elevation: 2,
        shape: _cardShape,
      ),
      dialogTheme: DialogThemeData(backgroundColor: colors.surfaceElevated),
      elevatedButtonTheme: _elevatedButtonTheme(colors, scheme),
      textButtonTheme: _textButtonTheme(colors, scheme),
      outlinedButtonTheme: _outlinedButtonTheme(colors, scheme),
      inputDecorationTheme: _inputDecorationTheme(colors, scheme, textTheme),
      tabBarTheme: _tabBarTheme(colors, scheme, textTheme),
      chipTheme: _chipTheme(colors, scheme, textTheme),
      floatingActionButtonTheme: _fabTheme(scheme),
      dividerTheme: _dividerTheme(colors),
      snackBarTheme: _snackBarTheme(colors, scheme, textTheme),
      tooltipTheme: _tooltipTheme(colors, textTheme),
      navigationRailTheme: _navigationRailTheme(colors, scheme, textTheme),
      navigationBarTheme: _navigationBarTheme(colors, scheme, textTheme),
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
    final textTheme = typography.textTheme.apply(
      bodyColor: colors.textPrimary,
      displayColor: colors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surfaceElevated,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceElevated,
        elevation: 2,
        shape: _cardShape,
      ),
      dialogTheme: DialogThemeData(backgroundColor: colors.surfaceElevated),
      elevatedButtonTheme: _elevatedButtonTheme(colors, scheme),
      textButtonTheme: _textButtonTheme(colors, scheme),
      outlinedButtonTheme: _outlinedButtonTheme(colors, scheme),
      inputDecorationTheme: _inputDecorationTheme(colors, scheme, textTheme),
      tabBarTheme: _tabBarTheme(colors, scheme, textTheme),
      chipTheme: _chipTheme(colors, scheme, textTheme),
      floatingActionButtonTheme: _fabTheme(scheme),
      dividerTheme: _dividerTheme(colors),
      snackBarTheme: _snackBarTheme(colors, scheme, textTheme),
      tooltipTheme: _tooltipTheme(colors, textTheme),
      navigationRailTheme: _navigationRailTheme(colors, scheme, textTheme),
      navigationBarTheme: _navigationBarTheme(colors, scheme, textTheme),
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

  static ElevatedButtonThemeData _elevatedButtonTheme(
    AppColors colors,
    ColorScheme scheme,
  ) {
    final Color disabledBg = scheme.primary.withValues(alpha: 0.35);
    final Color disabledFg = colors.surface.withValues(alpha: 0.7);
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll<Size>(_buttonMinSize),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          _buttonPadding,
        ),
        shape: const WidgetStatePropertyAll<OutlinedBorder>(_buttonShape),
        elevation: const WidgetStatePropertyAll<double>(0),
        foregroundColor: _colorState(scheme.onPrimary, disabledFg),
        backgroundColor: _colorState(scheme.primary, disabledBg),
        overlayColor: _colorState(
          scheme.onPrimary.withValues(alpha: 0.08),
          colors.surface.withValues(alpha: 0),
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(
    AppColors colors,
    ColorScheme scheme,
  ) {
    final Color disabledFg = colors.textSecondary.withValues(alpha: 0.5);
    return TextButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll<Size>(_buttonMinSize),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          _buttonPadding,
        ),
        shape: const WidgetStatePropertyAll<OutlinedBorder>(_buttonShape),
        foregroundColor: _colorState(scheme.primary, disabledFg),
        overlayColor: _colorState(
          scheme.primary.withValues(alpha: 0.1),
          colors.surface.withValues(alpha: 0),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(
    AppColors colors,
    ColorScheme scheme,
  ) {
    final BorderSide enabledSide = BorderSide(
      color: scheme.primary,
      width: 1.4,
    );
    final BorderSide disabledSide = BorderSide(
      color: colors.textSecondary.withValues(alpha: 0.4),
      width: 1.4,
    );
    final Color disabledFg = colors.textSecondary.withValues(alpha: 0.6);
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll<Size>(_buttonMinSize),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          _buttonPadding,
        ),
        shape: const WidgetStatePropertyAll<OutlinedBorder>(_buttonShape),
        side: _borderState(enabledSide, disabledSide),
        foregroundColor: _colorState(scheme.primary, disabledFg),
        overlayColor: _colorState(
          scheme.primary.withValues(alpha: 0.08),
          colors.surface.withValues(alpha: 0),
        ),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(
    AppColors colors,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final TextStyle baseLabel = (textTheme.bodyMedium ?? const TextStyle())
        .copyWith(color: colors.textSecondary);
    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceElevated,
      contentPadding: _inputPadding,
      border: _inputBorder(colors.textSecondary.withValues(alpha: 0.4)),
      enabledBorder: _inputBorder(colors.textSecondary.withValues(alpha: 0.5)),
      focusedBorder: _inputBorder(scheme.primary),
      errorBorder: _inputBorder(colors.error),
      focusedErrorBorder: _inputBorder(colors.error),
      labelStyle: baseLabel,
      floatingLabelStyle: baseLabel.copyWith(color: scheme.primary),
      helperStyle: baseLabel,
      errorStyle: baseLabel.copyWith(color: colors.error),
    );
  }

  static TabBarThemeData _tabBarTheme(
    AppColors colors,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final TextStyle label = (textTheme.titleMedium ?? const TextStyle())
        .copyWith(color: colors.textPrimary);
    final TextStyle unselected = label.copyWith(color: colors.textSecondary);
    return TabBarThemeData(
      labelColor: colors.textPrimary,
      unselectedLabelColor: colors.textSecondary,
      labelStyle: label,
      unselectedLabelStyle: unselected,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: scheme.primary,
          width: _tabIndicatorWeight,
        ),
      ),
    );
  }

  static ChipThemeData _chipTheme(
    AppColors colors,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final TextStyle label = (textTheme.labelLarge ?? const TextStyle())
        .copyWith(color: colors.textPrimary);
    return ChipThemeData(
      backgroundColor: colors.surfaceElevated,
      selectedColor: scheme.primary.withValues(alpha: 0.15),
      disabledColor: colors.surface,
      secondarySelectedColor: scheme.primary,
      labelStyle: label,
      secondaryLabelStyle: label.copyWith(color: scheme.onPrimary),
      padding: _chipPadding,
      shape: const StadiumBorder(),
    );
  }

  static FloatingActionButtonThemeData _fabTheme(ColorScheme scheme) {
    return FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      shape: _fabShape,
    );
  }

  static DividerThemeData _dividerTheme(AppColors colors) {
    return DividerThemeData(
      color: colors.textSecondary.withValues(alpha: 0.2),
      thickness: _dividerThickness,
      space: _dividerThickness,
    );
  }

  static SnackBarThemeData _snackBarTheme(
    AppColors colors,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final TextStyle contentStyle = (textTheme.bodyMedium ?? const TextStyle())
        .copyWith(color: colors.textPrimary);
    return SnackBarThemeData(
      backgroundColor: colors.surfaceElevated,
      behavior: SnackBarBehavior.floating,
      elevation: _snackBarElevation,
      shape: _cardShape,
      contentTextStyle: contentStyle,
      actionTextColor: scheme.primary,
      showCloseIcon: true,
      closeIconColor: colors.textSecondary,
      insetPadding: _snackBarInset,
    );
  }

  static TooltipThemeData _tooltipTheme(AppColors colors, TextTheme textTheme) {
    final TextStyle style = (textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: colors.textPrimary,
    );
    return TooltipThemeData(
      padding: _tooltipPadding,
      textStyle: style,
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: _baseBorderRadius,
        border: Border.all(color: colors.textSecondary.withValues(alpha: 0.2)),
      ),
      waitDuration: const Duration(milliseconds: 200),
      preferBelow: true,
    );
  }

  static NavigationRailThemeData _navigationRailTheme(
    AppColors colors,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final TextStyle label = (textTheme.labelLarge ?? const TextStyle())
        .copyWith(color: colors.textPrimary);
    return NavigationRailThemeData(
      backgroundColor: colors.surface,
      indicatorColor: scheme.primary.withValues(alpha: 0.15),
      selectedIconTheme: IconThemeData(color: scheme.primary),
      unselectedIconTheme: IconThemeData(color: colors.textSecondary),
      selectedLabelTextStyle: label.copyWith(color: scheme.primary),
      unselectedLabelTextStyle: label.copyWith(color: colors.textSecondary),
    );
  }

  static NavigationBarThemeData _navigationBarTheme(
    AppColors colors,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final TextStyle label = (textTheme.labelMedium ?? const TextStyle())
        .copyWith(color: colors.textPrimary);
    return NavigationBarThemeData(
      backgroundColor: colors.surface,
      elevation: 0,
      indicatorColor: scheme.primary.withValues(alpha: 0.15),
      surfaceTintColor: colors.surface,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
        (states) => states.contains(WidgetState.selected)
            ? label.copyWith(color: scheme.primary)
            : label.copyWith(color: colors.textSecondary),
      ),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? scheme.primary
              : colors.textSecondary,
        ),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: _baseBorderRadius,
      borderSide: BorderSide(color: color, width: _inputBorderWidth),
    );
  }

  static WidgetStateProperty<Color?> _colorState(
    Color enabled,
    Color disabled,
  ) {
    return WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled) ? disabled : enabled,
    );
  }

  static WidgetStateProperty<BorderSide?> _borderState(
    BorderSide enabled,
    BorderSide disabled,
  ) {
    return WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled) ? disabled : enabled,
    );
  }
}
