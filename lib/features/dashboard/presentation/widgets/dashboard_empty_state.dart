/// ROLE
/// - 대시보드 빈 상태 UI를 제공한다
///
/// RESPONSIBILITY
/// - 검색 결과 없음/로딩 완료 후 빈 화면을 안내한다
///
/// DEPENDS ON
/// - 없음
library;

import 'package:flutter/material.dart';

const double _emptyIconSize = 48;

class DashboardEmptyState extends StatelessWidget {
  const DashboardEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.search_off,
            size: _emptyIconSize,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            '검색 결과 없음',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '다른 검색어를 입력해 보세요.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
