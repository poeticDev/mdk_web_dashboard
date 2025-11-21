import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme_controller.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(themeControllerProvider);
    final isDark = controller.isDarkMode(context);

    return IconButton(
      tooltip: isDark ? '라이트 모드로 전환' : '다크 모드로 전환',
      icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
      onPressed: () => controller.toggle(context),
    );
  }
}
