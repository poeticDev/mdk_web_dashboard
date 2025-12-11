import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mdk_app_theme/mdk_app_theme.dart';
import 'package:web_dashboard/common/theme/theme_controller_provider.dart';

/// Wraps [ThemeToggle] with the Riverpod-driven ThemeController from
/// `mdk_app_theme`, keeping the widget tree source files clean.
class AppThemeToggle extends ConsumerWidget {
  const AppThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeController controller = ref.watch(themeControllerProvider);
    return ThemeToggle(
      isDarkMode: controller.isDarkMode(context),
      onToggle: controller.toggle,
    );
  }
}
