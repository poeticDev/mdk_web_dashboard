import 'package:flutter/material.dart';

/// 기존 산재해 있던 색상 상수 모음.
/// AppColors/AppTheme로 대체 예정이므로 새 코드에서는 사용하지 말 것.
@Deprecated('Use AppColors/AppTheme tokens instead.')
class DeprecatedThemeColors {
  const DeprecatedThemeColors._();

  @Deprecated('Replace with AppTheme background gradient tokens when ready.')
  static const Color loginGradientStart = Color(0xFF0F2027);

  @Deprecated('Replace with AppTheme background gradient tokens when ready.')
  static const Color loginGradientEnd = Color(0xFF2C5364);
}
