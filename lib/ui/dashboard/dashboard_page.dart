import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:web_dashboard/common/responsive/responsive_layout.dart';
import 'package:web_dashboard/theme/theme_controller.dart';
import 'package:web_dashboard/theme/widgets/theme_toggle.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = ref.watch(themeControllerProvider);

    _getThemeMode(context);
    return Scaffold(
      appBar: AppBar(title: const Text('관제 대시보드'), actions: [ThemeToggle()]),
      body: Padding(
        // 공통 responsive 패딩을 사용해 화면별 여백 일관성을 유지한다.
        padding: context.responsivePagePadding(),
        child: const Center(child: Text('대시보드 콘텐츠를 여기에 구성하세요.')),
      ),
    );
  }

  Future<void> _getThemeMode(BuildContext contex) async {
    final currentTheme = await AdaptiveTheme.getThemeMode();
    print(currentTheme.toString());
  }
}
