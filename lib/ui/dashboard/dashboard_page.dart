import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/common/responsive/responsive_layout.dart';
import 'package:web_dashboard/common/widgets/app_theme_toggle.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef _) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('관제 대시보드'),
        actions: const <Widget>[AppThemeToggle()],
      ),
      body: Padding(
        // 공통 responsive 패딩을 사용해 화면별 여백 일관성을 유지한다.
        padding: context.responsivePagePadding(),
        child: const Center(child: Text('대시보드 콘텐츠를 여기에 구성하세요.')),
      ),
    );
  }
}
