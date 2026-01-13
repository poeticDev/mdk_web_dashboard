import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web_dashboard/common/responsive/responsive_layout.dart';
import 'package:web_dashboard/features/classroom_detail/presentation/widgets/header/device_panel.dart';
import 'package:web_dashboard/features/classroom_detail/presentation/widgets/header/environment_panel.dart';
import 'package:web_dashboard/features/classroom_detail/presentation/widgets/header/header_title.dart';
import 'package:web_dashboard/features/classroom_detail/presentation/widgets/header/room_summary_card.dart';

const double _headerHeight = 132;
const double _panelSpacing = 16;

/// 헤더 타이틀·요약·장비·환경 패널을 배치하는 셸 위젯.
class ClassroomDetailHeaderSection extends ConsumerWidget {
  const ClassroomDetailHeaderSection({
    required this.classroomId,
    this.onCameraPressed,
    super.key,
  });

  final String classroomId;
  final VoidCallback? onCameraPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveLayoutBuilder(
      builder: (BuildContext context, DeviceFormFactor formFactor) {
        final bool isWideLayout = formFactor != DeviceFormFactor.mobile;
        return Column(
          spacing: _panelSpacing,
          children: <Widget>[
            ClassroomHeaderTitle(
              classroomId: classroomId,
              isWideLayout: isWideLayout,
              onCameraPressed: onCameraPressed,
            ),
            SizedBox(
              height: isWideLayout ? _headerHeight : null,
              child: ResponsiveRowColumn(
                layout: isWideLayout
                    ? ResponsiveRowColumnType.ROW
                    : ResponsiveRowColumnType.COLUMN,
                rowMainAxisAlignment: MainAxisAlignment.center,
                rowCrossAxisAlignment: CrossAxisAlignment.center,
                rowSpacing: _panelSpacing,
                columnSpacing: _panelSpacing,
                children: <ResponsiveRowColumnItem>[
                  ResponsiveRowColumnItem(
                    rowFlex: 3,
                    child: RoomSummaryCard(classroomId: classroomId),
                  ),
                  // ResponsiveRowColumnItem(
                  //   child: DevicePanel(classroomId: classroomId),
                  // ),
                  ResponsiveRowColumnItem(
                    child: EnvironmentPanel(classroomId: classroomId),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
