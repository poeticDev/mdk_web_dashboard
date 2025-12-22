import 'package:flutter/material.dart';
import 'package:web_dashboard/common/app_bar/common_app_bar.dart';
import 'package:web_dashboard/common/app_bar/common_app_bar_options.dart';
import 'package:web_dashboard/common/responsive/responsive_layout.dart';
import 'package:web_dashboard/common/widgets/app_snack_bar.dart';
import 'package:web_dashboard/routes/page_meta.dart';
import 'package:web_dashboard/ui/classroom_detail/models/classroom_detail_header_data.dart';
import 'package:web_dashboard/ui/classroom_detail/widgets/classroom_detail_header_section.dart';
import 'package:web_dashboard/ui/classroom_detail/widgets/classroom_timetable_section.dart';

class ClassroomDetailPage extends StatefulWidget {
  const ClassroomDetailPage({required this.roomId, super.key});

  final String roomId;

  @override
  State<ClassroomDetailPage> createState() => _ClassroomDetailPageState();
}

class _ClassroomDetailPageState extends State<ClassroomDetailPage> {
  late ClassroomDetailHeaderData _headerData;

  @override
  void initState() {
    super.initState();
    _headerData = _buildMockHeaderData(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        meta: AppPageMeta.classroomDetail,
        options: CommonAppBarOptions(
          titleOverride: '강의실 ${_headerData.summary.roomName}',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // 공통 helper 기본값으로 화면 간 패딩 정책을 공유한다.
          padding: context.responsivePagePadding(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(maxWidth: 1024),
                child: ClassroomDetailHeaderSection(
                  data: _headerData,
                  onToggleChanged: _handleToggleChanged,
                  onCameraPressed: () => _showComingSoonSnackBar(context),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ClassroomTimetableSection(
                  classroomId: widget.roomId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleToggleChanged(String toggleId, bool value) {
    // 실제 API 연동 전까지는 즉시 상태를 복제해 optimistic UI를 구성한다.
    final List<DeviceToggleStatus> updatedToggles = _headerData.deviceToggles
        .map(
          (DeviceToggleStatus toggle) =>
              toggle.id == toggleId ? toggle.copyWith(isOn: value) : toggle,
        )
        .toList();
    setState(() {
      _headerData = ClassroomDetailHeaderData(
        summary: _headerData.summary,
        deviceToggles: updatedToggles,
        environmentMetrics: _headerData.environmentMetrics,
      );
    });
  }

  void _showComingSoonSnackBar(BuildContext context) {
    AppSnackBar.show(
      context,
      message: '실시간 카메라 연동은 준비 중입니다.',
      type: AppSnackBarType.info,
    );
  }
}

ClassroomDetailHeaderData _buildMockHeaderData(String roomId) {
  // API 스펙 확정 전까지는 고정 데이터를 활용해 UI를 검증한다.
  final ClassroomSummaryInfo summary = ClassroomSummaryInfo(
    roomName: '공학관 $roomId',
    department: '스마트보안학과',
    currentCourse: '스마트 IoT 시스템 실습',
    professor: '김보안 교수',
    sessionTime: const SessionTimeRange(
      start: TimeOfDay(hour: 9, minute: 0),
      end: TimeOfDay(hour: 10, minute: 50),
    ),
    status: ClassroomSessionStatus.inUse,
    capacity: 40,
    currentOccupancy: 32,
  );
  return ClassroomDetailHeaderData(
    summary: summary,
    deviceToggles: <DeviceToggleStatus>[
      const DeviceToggleStatus(
        id: 'light',
        label: '전등',
        icon: Icons.light_mode_outlined,
        isOn: true,
        description: '교수자 제어 우선',
      ),
      const DeviceToggleStatus(
        id: 'projector',
        label: '전체 장비',
        icon: Icons.present_to_all,
        isOn: true,
        description: 'HDMI1 입력',
      ),
    ],
    environmentMetrics: const <EnvironmentMetric>[
      EnvironmentMetric(
        id: 'temperature',
        label: '온도',
        value: '23',
        unit: '°C',
        icon: Icons.thermostat,
      ),
      EnvironmentMetric(
        id: 'humidity',
        label: '습도',
        value: '42',
        unit: '%',
        icon: Icons.water_drop_outlined,
      ),
      // EnvironmentMetric(
      //   id: 'co2',
      //   label: 'CO₂',
      //   value: '560',
      //   unit: 'ppm',
      //   icon: Icons.air_outlined,
      // ),
    ],
  );
}
