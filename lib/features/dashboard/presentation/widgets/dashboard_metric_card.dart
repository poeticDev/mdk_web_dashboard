/// ROLE
/// - 대시보드 KPI 카드 UI를 제공한다
///
/// RESPONSIBILITY
/// - 상태별 카운트와 선택 상태를 표시한다
///
/// DEPENDS ON
/// - theme_utilities
library;

import 'package:flutter/material.dart';
import 'package:mdk_app_theme/theme_utilities.dart';

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
    final AppColors colors = isDark
        ? AppColors.dark(ThemeBrand.defaultBrand)
        : AppColors.light(ThemeBrand.defaultBrand);
    final Color background = isSelected
        ? accentColor.withValues(alpha: isDark ? 0.18 : 0.12)
        : colors.surface;
    final Color valueColor = isSelected ? accentColor : colors.textPrimary;
    final Color borderColor = isSelected ? accentColor : colors.surfaceElevated;

    return InkWell(
      borderRadius: BorderRadius.circular(_metricCardRadius),
      onTap: onTap,
      child: Card(
        elevation: _metricCardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_metricCardRadius),
          side: BorderSide(color: borderColor),
        ),
        child: Container(
          padding: const EdgeInsets.all(_metricCardPadding),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(_metricCardRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value.toString(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: valueColor,
                  fontSize: _metricValueFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
