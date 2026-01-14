/// ROLE
/// - 대시보드 스트리밍 상태 배지를 제공한다
///
/// RESPONSIBILITY
/// - SSE 연결 상태를 시각적으로 표현한다
///
/// DEPENDS ON
/// - theme_utilities
library;

import 'package:flutter/material.dart';
import 'package:mdk_app_theme/theme_utilities.dart';

class DashboardStreamingBadge extends StatelessWidget {
  const DashboardStreamingBadge({required this.isStreaming, super.key});

  final bool isStreaming;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final AppColors colors = isDark
        ? AppColors.dark(ThemeBrand.defaultBrand)
        : AppColors.light(ThemeBrand.defaultBrand);
    final Color badgeColor = isStreaming ? colors.success : colors.warning;
    final String label = isStreaming ? '연결됨' : '연결 끊김';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: isDark ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: badgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            isStreaming ? Icons.wifi : Icons.wifi_off,
            color: badgeColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
