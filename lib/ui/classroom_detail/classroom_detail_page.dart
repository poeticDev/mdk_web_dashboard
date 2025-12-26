import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/common/app_bar/common_app_bar.dart';
import 'package:web_dashboard/common/app_bar/common_app_bar_options.dart';
import 'package:web_dashboard/common/responsive/responsive_layout.dart';
import 'package:web_dashboard/common/widgets/app_snack_bar.dart';
import 'package:web_dashboard/core/classroom_detail/application/classroom_detail_providers.dart';
import 'package:web_dashboard/core/classroom_detail/domain/entities/classroom_detail_entity.dart';
import 'package:web_dashboard/routes/page_meta.dart';
import 'package:web_dashboard/ui/classroom_detail/widgets/classroom_detail_header_section.dart';
import 'package:web_dashboard/ui/classroom_detail/widgets/classroom_timetable_section.dart';

class ClassroomDetailPage extends ConsumerWidget {
  const ClassroomDetailPage({required this.roomId, super.key});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ClassroomDetailEntity> detailValue = ref.watch(
      classroomDetailInfoProvider(roomId),
    );
    final String title = detailValue.maybeWhen(
      data: (ClassroomDetailEntity entity) => '${entity.name} 강의실',
      orElse: () => '강의실 상세',
    );
    return Scaffold(
      appBar: CommonAppBar(
        meta: AppPageMeta.classroomDetail,
        options: CommonAppBarOptions(titleOverride: title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: context.responsivePagePadding(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                constraints: const BoxConstraints(maxWidth: 1024),
                child: ClassroomDetailHeaderSection(
                  classroomId: roomId,
                  onCameraPressed: () => _showComingSoonSnackBar(context),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ClassroomTimetableSection(classroomId: roomId),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoonSnackBar(BuildContext context) {
    AppSnackBar.show(
      context,
      message: '실시간 카메라 연동은 준비 중입니다.',
      type: AppSnackBarType.info,
    );
  }
}
