/// ROLE
/// - 대시보드 KPI 카드 UI를 제공한다
///
/// RESPONSIBILITY
/// - 상태별 카운트와 선택 상태를 표시한다
///
/// DEPENDS ON
/// - custom_card
library;

import 'package:flutter/material.dart';
import 'package:web_dashboard/common/widgets/custom_card.dart';

const double _metricCardRadius = 18;
const double _metricCardElevation = 1.5;
const double _metricCardPadding = 16;
const double _metricValueFontSize = 28;

class DashboardMetricCard extends StatelessWidget {
  const DashboardMetricCard({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.accentColor,
    super.key,
    this.onTap,
  });

  final String label;
  final int value;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final ColorScheme colors = theme.colorScheme;
    final Color background = isSelected
        ? Color.lerp(colors.surface, accentColor, 0.18)!
        : colors.surface;
    final Color valueColor = isSelected ? accentColor : colors.onSurface;
    final Color borderColor = isSelected
        ? accentColor
        : colors.surfaceContainerHighest;

    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(_metricCardPadding),
      elevation: _metricCardElevation,
      backgroundColor: background,
      borderColor: borderColor,
      radius: _metricCardRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            textAlign: TextAlign.end,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: valueColor,
              fontSize: _metricValueFontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
