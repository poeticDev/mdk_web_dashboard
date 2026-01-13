/// ROLE
/// - 대시보드 강의실 카드 UI를 제공한다
///
/// RESPONSIBILITY
/// - 강의실 상태와 현재 강의를 표시한다
///
/// DEPENDS ON
/// - theme_utilities
/// - dashboard_viewmodels
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mdk_app_theme/theme_utilities.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_classroom_card_view_model.dart';
import 'package:web_dashboard/features/dashboard/viewmodels/dashboard_usage_status.dart';

const double _cardRadius = 20;
const double _cardPadding = 16;
const double _iconBadgeSize = 28;
const double _statusBadgeRadius = 12;
const double _statusBadgePaddingH = 12;
const double _statusBadgePaddingV = 6;
const double _titleSpacing = 6;
const double _sectionSpacing = 12;
const double _lectureSpacing = 4;

class DashboardClassroomCard extends StatelessWidget {
  const DashboardClassroomCard({
    required this.viewModel,
    required this.onTap,
    super.key,
  });

  final DashboardClassroomCardViewModel viewModel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final AppColors colors = isDark
        ? AppColors.dark(ThemeBrand.defaultBrand)
        : AppColors.light(ThemeBrand.defaultBrand);
    final DashboardStatusPalette palette = _resolvePalette(viewModel, colors);

    return InkWell(
      borderRadius: BorderRadius.circular(_cardRadius),
      onTap: onTap,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
        child: Container(
          padding: const EdgeInsets.all(_cardPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_cardRadius),
            color: palette.background,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _CardTopRow(
                palette: palette,
                isOccupied: viewModel.roomState?.isOccupied,
                isEquipmentOn: viewModel.roomState?.isEquipmentOn,
                statusLabel: _resolveStatusLabel(viewModel.usageStatus),
              ),
              const SizedBox(height: _sectionSpacing),
              Text(
                viewModel.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: palette.titleColor,
                ),
              ),
              const SizedBox(height: _titleSpacing),
              Text(
                viewModel.departmentName ?? '미지정',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: _sectionSpacing),
              _LectureInfo(viewModel: viewModel),
              const Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: palette.badgeColor,
                    side: BorderSide(color: palette.badgeColor),
                  ),
                  child: const Text('자세히 보기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardTopRow extends StatelessWidget {
  const _CardTopRow({
    required this.palette,
    required this.isOccupied,
    required this.isEquipmentOn,
    required this.statusLabel,
  });

  final DashboardStatusPalette palette;
  final bool? isOccupied;
  final bool? isEquipmentOn;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            _StatusIcon(
              icon: Icons.person,
              isActive: isOccupied,
              activeColor: palette.occupancyColor,
            ),
            const SizedBox(width: 8),
            _StatusIcon(
              icon: Icons.power_settings_new,
              isActive: isEquipmentOn,
              activeColor: palette.equipmentColor,
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: _statusBadgePaddingH,
            vertical: _statusBadgePaddingV,
          ),
          decoration: BoxDecoration(
            color: palette.badgeColor.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(_statusBadgeRadius),
          ),
          child: Text(
            statusLabel,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: palette.badgeColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({
    required this.icon,
    required this.isActive,
    required this.activeColor,
  });

  final IconData icon;
  final bool? isActive;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color fallback = isDark
        ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
        : theme.colorScheme.onSurface.withValues(alpha: 0.3);
    final Color iconColor = isActive == true ? activeColor : fallback;
    final Color background = iconColor.withValues(
      alpha: isActive == true ? 0.18 : 0.1,
    );

    return Container(
      width: _iconBadgeSize,
      height: _iconBadgeSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: background,
      ),
      child: Icon(icon, size: 16, color: iconColor),
    );
  }
}

class _LectureInfo extends StatelessWidget {
  const _LectureInfo({required this.viewModel});

  final DashboardClassroomCardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DashboardCurrentLectureViewModel? lecture = viewModel.currentLecture;
    if (lecture == null) {
      return Text(
        '일정 없음',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      );
    }
    final String title = lecture.isCanceled ? '(휴강) ${lecture.title}' : lecture.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: _lectureSpacing),
        Text(
          lecture.instructorName,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: _lectureSpacing),
        Text(
          _formatRange(lecture.startAt, lecture.endAt),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

DashboardStatusPalette _resolvePalette(
  DashboardClassroomCardViewModel viewModel,
  AppColors colors,
) {
  switch (viewModel.usageStatus) {
    case DashboardUsageStatus.inUse:
      return DashboardStatusPalette(
        badgeColor: colors.success,
        occupancyColor: colors.success,
        equipmentColor: colors.primary,
        background: colors.surface,
        titleColor: colors.textPrimary,
      );
    case DashboardUsageStatus.idle:
      return DashboardStatusPalette(
        badgeColor: colors.textSecondary,
        occupancyColor: colors.textSecondary,
        equipmentColor: colors.primaryVariant,
        background: colors.surfaceElevated,
        titleColor: colors.textPrimary,
      );
    case DashboardUsageStatus.unlinked:
      return DashboardStatusPalette(
        badgeColor: colors.warning,
        occupancyColor: colors.warning,
        equipmentColor: colors.warning,
        background: colors.surface,
        titleColor: colors.textPrimary,
      );
  }
}

String _resolveStatusLabel(DashboardUsageStatus status) {
  switch (status) {
    case DashboardUsageStatus.inUse:
      return '사용 중';
    case DashboardUsageStatus.idle:
      return '미사용';
    case DashboardUsageStatus.unlinked:
      return '미연동';
  }
}

String _formatRange(DateTime start, DateTime end) {
  final DateFormat format = DateFormat('HH:mm');
  return '${format.format(start)} ~ ${format.format(end)}';
}

class DashboardStatusPalette {
  const DashboardStatusPalette({
    required this.badgeColor,
    required this.occupancyColor,
    required this.equipmentColor,
    required this.background,
    required this.titleColor,
  });

  final Color badgeColor;
  final Color occupancyColor;
  final Color equipmentColor;
  final Color background;
  final Color titleColor;
}
