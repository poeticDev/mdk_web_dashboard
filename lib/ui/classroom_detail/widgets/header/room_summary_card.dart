import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/common/widgets/custom_card.dart';
import 'package:web_dashboard/core/classroom_detail/application/classroom_detail_providers.dart';
import 'package:web_dashboard/ui/classroom_detail/widgets/header/header_shared_tiles.dart';

/// 현재 진행 중인 강의 상태를 보여주는 카드.
class RoomSummaryCard extends ConsumerWidget {
  const RoomSummaryCard({required this.classroomId, super.key});

  final String classroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ClassroomNowViewModel> now = ref.watch(
      classroomNowViewModelProvider(classroomId),
    );
    final TextTheme textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    return now.when(
      data: (ClassroomNowViewModel data) => CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: <Widget>[
            Row(
              spacing: 8.0,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: data.isInSession
                        ? colorTheme.primaryContainer.withValues(alpha: 0.7)
                        : colorTheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    data.isInSession ? '수업 중' : '현재 수업 없음',
                    style: textTheme.bodyMedium?.copyWith(
                      color: data.isInSession
                          ? colorTheme.onPrimaryContainer
                          : colorTheme.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (data.startTime != null && data.endTime != null)
                  Row(
                    spacing: 4.0,
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: colorTheme.onSurface,
                      ),
                      Text(
                        '${TimeOfDay.fromDateTime(data.startTime!).format(context)} ~ ${TimeOfDay.fromDateTime(data.endTime!).format(context)}',
                      ),
                    ],
                  ),
              ],
            ),

            Row(
              spacing: 8.0,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // if (data.isInSession)
                  Text(
                    data.currentCourseName ?? '현재 진행 중인 강의가 없습니다.',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (data.instructorName != null)
                  Text(data.instructorName!, style: textTheme.bodyLarge),
              ],
            ),
          ],
        ),
      ),
      loading: () => const HeaderLoadingTile(height: 120),
      error: (_, __) => const HeaderErrorTile(message: '실시간 정보를 불러올 수 없습니다.'),
    );
  }
}
