import 'package:flutter/material.dart';

/// 전역에서 재사용할 스낵바 타입.
enum AppSnackBarType { info, success, warning, error }

/// 공통 스타일의 스낵바 헬퍼.
class AppSnackBar {
  const AppSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final Color background = _resolveBackground(colors, type);
    final Color foreground = colors.onPrimary;
    final SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: duration,
      backgroundColor: background,
      content: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
      action: action,
    );
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Color _resolveBackground(
    ColorScheme colors,
    AppSnackBarType type,
  ) {
    switch (type) {
      case AppSnackBarType.success:
        return colors.primary;
      case AppSnackBarType.warning:
        return colors.tertiary;
      case AppSnackBarType.error:
        return colors.error;
      case AppSnackBarType.info:
        return colors.secondary;
    }
  }
}
