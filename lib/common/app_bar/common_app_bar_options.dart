import 'package:flutter/material.dart';

/// CommonAppBar 동작을 제어하는 설정값.
class CommonAppBarOptions {
  const CommonAppBarOptions({
    this.showBackButton,
    this.showThemeToggle,
    this.showUserBanner,
    this.titleOverride,
    this.trailing,
  });

  final bool? showBackButton;
  final bool? showThemeToggle;
  final bool? showUserBanner;
  final String? titleOverride;
  final List<Widget>? trailing;

  CommonAppBarOptions copyWith({
    bool? showBackButton,
    bool? showThemeToggle,
    bool? showUserBanner,
    String? titleOverride,
    List<Widget>? trailing,
  }) {
    return CommonAppBarOptions(
      showBackButton: showBackButton ?? this.showBackButton,
      showThemeToggle: showThemeToggle ?? this.showThemeToggle,
      showUserBanner: showUserBanner ?? this.showUserBanner,
      titleOverride: titleOverride ?? this.titleOverride,
      trailing: trailing ?? this.trailing,
    );
  }
}
