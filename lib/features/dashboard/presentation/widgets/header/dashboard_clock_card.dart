/// ROLE
/// - 대시보드 현재 시각 카드를 제공한다
///
/// RESPONSIBILITY
/// - KST 기준 시간 표시를 렌더링한다
///
/// DEPENDS ON
/// - intl
/// - dashboard_header_layout
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_dashboard/common/widgets/custom_card.dart';
import 'package:web_dashboard/features/dashboard/presentation/widgets/header/dashboard_header_layout.dart';

class DashboardClockCard extends StatelessWidget {
  const DashboardClockCard({required this.minWidth, super.key});

  final double minWidth;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth),
      child: CustomCard(
        padding: const EdgeInsets.all(headerCardPadding),
        elevation: 1,
        backgroundColor: theme.cardColor,
        radius: headerCardRadius,
        child: StreamBuilder<DateTime>(
          stream: Stream<DateTime>.periodic(clockTick, (_) => _nowInKst()),
          initialData: _nowInKst(),
          builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
            final DateTime now = snapshot.data ?? _nowInKst();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: <Widget>[
                Text(
                  '현재 시각',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  _formatKoreanDate(now),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colors.tertiaryFixed,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  _formatClock(now),
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            );
          },
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
