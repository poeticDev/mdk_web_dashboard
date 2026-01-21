// 강의실 요약 카드 UI를 구성한다.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/common/widgets/custom_card.dart';
import 'package:web_dashboard/features/classroom_detail/application/classroom_now_controller.dart';
import 'package:web_dashboard/features/classroom_detail/application/state/classroom_now_state.dart';
import 'package:web_dashboard/features/classroom_detail/presentation/widgets/header/header_shared_tiles.dart';

/// 현재 진행 중인 강의 상태를 보여주는 카드.
class RoomSummaryCard extends ConsumerWidget {
  const RoomSummaryCard({required this.classroomId, super.key});

  final String classroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ClassroomNowState now = ref.watch(
      classroomNowControllerProvider(classroomId),
    );
    final TextTheme textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    if (now.isLoading) {
      return const HeaderLoadingTile(height: 120);
    }
    if (now.hasError) {
      return const HeaderErrorTile(message: '실시간 정보를 불러올 수 없습니다.');
    }
    return CustomCard(
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
                  color: now.isInSession
                      ? colorTheme.primaryContainer.withValues(alpha: 0.7)
                      : colorTheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Text(
                  now.isInSession ? '수업 중' : '현재 수업 없음',
                  style: textTheme.bodyMedium?.copyWith(
                    color: now.isInSession
                        ? colorTheme.onPrimaryContainer
                        : colorTheme.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (now.startTime != null && now.endTime != null)
                Row(
                  spacing: 4.0,
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: colorTheme.onSurface,
                    ),
                    Text(
                      '${TimeOfDay.fromDateTime(now.startTime!).format(context)} ~ ${TimeOfDay.fromDateTime(now.endTime!).format(context)}',
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
              Text(
                now.currentCourseName ?? '현재 진행 중인 강의가 없습니다.',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (now.instructorName != null)
                Text(now.instructorName!, style: textTheme.bodyLarge),
            ],
          ),
        ],
      ),
    );
  }
}
