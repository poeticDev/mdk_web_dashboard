import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web_dashboard/core/classroom_detail/application/classroom_detail_providers.dart';
import 'package:web_dashboard/core/classroom_detail/domain/entities/classroom_detail_entity.dart';
import 'package:web_dashboard/ui/classroom_detail/widgets/header/header_shared_tiles.dart';

/// 요약 provider를 구독해 강의실 타이틀과 카메라 진입 버튼을 노출한다.
class ClassroomHeaderTitle extends ConsumerWidget {
  const ClassroomHeaderTitle({
    required this.classroomId,
    required this.isWideLayout,
    this.onCameraPressed,
    super.key,
  });

  final String classroomId;
  final bool isWideLayout;
  final VoidCallback? onCameraPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ClassroomDetailEntity> detail = ref.watch(
      classroomDetailInfoProvider(classroomId),
    );
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ResponsiveRowColumn(
      layout: isWideLayout
          ? ResponsiveRowColumnType.ROW
          : ResponsiveRowColumnType.COLUMN,
      rowSpacing: 16,
      columnSpacing: 16,
      rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <ResponsiveRowColumnItem>[
        ResponsiveRowColumnItem(
          child: detail.when(
            data: (ClassroomDetailEntity data) => SizedBox(
              width: isWideLayout ? 300 : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.name,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (data.department != null)
                    Text(
                      data.department!.name,
                      style: textTheme.titleMedium?.copyWith(
                        color: textTheme.headlineSmall?.color?.withValues(
                          alpha: 0.9,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            loading: () => const HeaderLoadingTile(height: 52, width: 180),
            error: (_, __) =>
                const HeaderErrorTile(message: '강의실명을 불러오지 못했습니다.'),
          ),
        ),
        ResponsiveRowColumnItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: <Widget>[
              _OccupancyBadge(classroomId: classroomId),
              ElevatedButton(
                onPressed: onCameraPressed,
                child: Text('실시간 카메라 보기', style: textTheme.bodyMedium),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OccupancyBadge extends ConsumerWidget {
  const _OccupancyBadge({required this.classroomId});

  final String classroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ClassroomDetailEntity> detail = ref.watch(
      classroomDetailInfoProvider(classroomId),
    );
    final ThemeData theme = Theme.of(context);
    return detail.when(
      data: (ClassroomDetailEntity entity) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: theme.colorScheme.primaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: <Widget>[
              Text('재실상태', style: theme.textTheme.labelLarge),
              Text(
                '${entity.capacity ?? 0}명',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const HeaderLoadingTile(height: 64, width: 160),
      error: (_, __) => const HeaderErrorTile(message: '재실 정보를 확인할 수 없습니다.'),
    );
  }
}
