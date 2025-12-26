import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/common/widgets/custom_card.dart';
import 'package:web_dashboard/core/classroom_detail/application/classroom_detail_providers.dart';
import 'package:web_dashboard/core/classroom_detail/domain/entities/classroom_detail_entity.dart';
import 'package:web_dashboard/ui/classroom_detail/widgets/header/header_shared_tiles.dart';

/// 건물·수용 인원·강의실 타입 등 핵심 메타데이터를 보여주는 카드.
class RoomSummaryCard extends ConsumerWidget {
  const RoomSummaryCard({required this.classroomId, super.key});

  final String classroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ClassroomDetailEntity> detail = ref.watch(
      classroomDetailInfoProvider(classroomId),
    );
    final TextTheme textTheme = Theme.of(context).textTheme;
    return detail.when(
      data: (ClassroomDetailEntity entity) => CustomCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: <Widget>[
            Text(entity.name, style: textTheme.titleLarge),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: <Widget>[
                SummaryChip(
                  icon: Icons.apartment,
                  label: entity.building?.name ?? '건물 정보 없음',
                ),
                SummaryChip(
                  icon: Icons.groups,
                  label: '${entity.capacity ?? 0}명 수용',
                ),
                SummaryChip(
                  icon: Icons.meeting_room_outlined,
                  label: entity.type.name,
                ),
              ],
            ),
          ],
        ),
      ),
      loading: () => const HeaderLoadingTile(height: 120),
      error: (_, __) => const HeaderErrorTile(message: '강의실 정보를 불러올 수 없습니다.'),
    );
  }
}
