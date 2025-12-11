import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme_controller.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(themeControllerProvider);
    final bool isDark = controller.isDarkMode(context);
    final String tooltip = isDark ? '라이트 모드로 전환' : '다크 모드로 전환';
    final IconData icon = isDark ? Icons.dark_mode : Icons.light_mode;
    final Color iconColor = isDark ? Colors.yellow : Colors.orangeAccent;

    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon, color: iconColor),
      onPressed: () => controller.toggle(context),
    );
  }
}
