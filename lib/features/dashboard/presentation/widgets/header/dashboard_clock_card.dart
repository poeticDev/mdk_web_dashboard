/// ROLE
/// - 대시보드 현재 시각 카드를 제공한다
///
/// RESPONSIBILITY
/// - KST 기준 시간 표시를 렌더링한다
///
/// DEPENDS ON
/// - intl
/// - theme_utilities
/// - dashboard_header_layout
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mdk_app_theme/theme_utilities.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/header/dashboard_header_layout.dart';

class DashboardClockCard extends StatelessWidget {
  const DashboardClockCard({required this.minWidth, super.key});

  final double minWidth;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final AppColors colors = isDark
        ? AppColors.dark(ThemeBrand.defaultBrand)
        : AppColors.light(ThemeBrand.defaultBrand);

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(headerCardRadius),
        ),
        child: Container(
          padding: const EdgeInsets.all(headerCardPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(headerCardRadius),
            color: colors.surface,
          ),
          child: StreamBuilder<DateTime>(
            stream: Stream<DateTime>.periodic(
              clockTick,
              (_) => _nowInKst(),
            ),
            initialData: _nowInKst(),
            builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
              final DateTime now = snapshot.data ?? _nowInKst();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '현재 시각',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatKoreanDate(now),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.primaryVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatClock(now),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

DateTime _nowInKst() => DateTime.now().toUtc().add(kstOffset);

String _formatKoreanDate(DateTime dateTime) {
  final DateFormat format = DateFormat('yyyy년 M월 d일 (E)', 'ko_KR');
  return format.format(dateTime);
}

String _formatClock(DateTime dateTime) {
  final DateFormat format = DateFormat('HH:mm:ss', 'ko_KR');
  return format.format(dateTime);
}
