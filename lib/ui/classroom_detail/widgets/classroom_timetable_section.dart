import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mdk_app_theme/theme_utilities.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:web_dashboard/common/utils/date_time_utils.dart';
import 'package:web_dashboard/common/widgets/app_snack_bar.dart';
import 'package:web_dashboard/core/auth/application/auth_controller.dart';
import 'package:web_dashboard/core/auth/domain/entities/auth_user.dart';
import 'package:web_dashboard/core/auth/domain/state/auth_state.dart';
import 'package:web_dashboard/core/timetable/application/controllers/classroom_timetable_controller.dart';
import 'package:web_dashboard/core/timetable/application/state/classroom_timetable_state.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_entity.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_repository.dart'
    show LectureWriteInput, UpdateLectureInput, LectureField;
import 'package:web_dashboard/core/timetable/presentation/datasources/lecture_calendar_data_source.dart';
import 'package:web_dashboard/core/timetable/presentation/utils/lecture_color_resolver.dart';
import 'package:web_dashboard/core/timetable/presentation/viewmodels/lecture_view_model.dart';
import 'package:web_dashboard/ui/classroom_detail/widgets/classroom_timetable_dialogs.dart';
import 'package:web_dashboard/ui/classroom_detail/widgets/classroom_timetable_modal.dart';

const double _weekCalendarHeight = 800;
const double _monthCalendarHeight = 600;
const double _timeSlotIntervalHeight = 60;
const String _koreaTimeZoneId = 'Korea Standard Time';
const String _rangeStartPattern = 'MM/dd HH:mm';
const String _rangeEndPattern = 'HH:mm';

/// 강의실 상세 화면에서 시간표 영역을 노출하는 카드 위젯.
class ClassroomTimetableSection extends ConsumerStatefulWidget {
  const ClassroomTimetableSection({required this.classroomId, super.key});

  final String classroomId;

  @override
  ConsumerState<ClassroomTimetableSection> createState() =>
      _ClassroomTimetableSectionState();
}

class _ClassroomTimetableSectionState
    extends ConsumerState<ClassroomTimetableSection> {
  CalendarView _calendarView = CalendarView.week;
  DateTime _focusedDate = DateTime.now();
  final CalendarController _calendarController = CalendarController();

  /// 캘린더 컨트롤러의 초깃값을 준비한다.
  void _initializeCalendar() {
    _calendarController
      ..view = _calendarView
      ..displayDate = _focusedDate;
  }

  /// 첫 렌더링 직후 초기 범위를 불러온다.
  void _loadInitialLectures() {
    final ClassroomTimetableController controller = ref.read(
      classroomTimetableControllerProvider(widget.classroomId).notifier,
    );
    _refreshTimetable(controller, _currentRange());
  }

  /// 위젯 생명주기 시작 시 컨트롤러 및 초기 데이터를 준비한다.
  @override
  void initState() {
    super.initState();
    _initializeCalendar();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialLectures());
  }

  /// 강의실 시간표 카드 UI를 구성한다.
  @override
  Widget build(BuildContext context) {
    final ClassroomTimetableState state = ref.watch(
      classroomTimetableControllerProvider(widget.classroomId),
    );
    final ClassroomTimetableController controller = ref.read(
      classroomTimetableControllerProvider(widget.classroomId).notifier,
    );
    final AuthState authState = ref.watch(authControllerProvider);
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final bool canManage = _canManageRoles(
      authState.currentUser?.roles ?? const <UserRole>[],
    );
    final AppColors appColors = isDark
        ? AppColors.dark(ThemeBrand.defaultBrand)
        : AppColors.light(ThemeBrand.defaultBrand);
    final LectureColorResolver colorResolver = LectureColorResolver(appColors);
    final List<LectureViewModel> viewModels = state.lectures
        .map(
          (LectureEntity lecture) => LectureViewModel.fromEntity(
            lecture,
            color: colorResolver.resolveColor(lecture),
          ),
        )
        .toList();
    final LectureCalendarDataSource dataSource = LectureCalendarDataSource(
      items: viewModels,
      loadMoreLectures: (DateTime from, DateTime to) => _loadMoreLectures(
        from: from,
        to: to,
        controller: controller,
        colorResolver: colorResolver,
      ),
    );
    final TimetableDateRange? range = state.visibleRange;
    final double calendarHeight = _calendarView == CalendarView.week
        ? _weekCalendarHeight
        : _monthCalendarHeight;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            _TimetableHeader(
              view: _calendarView,
              range: range,
              isLoading: state.isLoading,
              onViewChanged: (CalendarView value) =>
                  _updateCalendarView(value, controller),
              onNavigate: (int delta) => _navigateCalendar(delta, controller),
              onToday: () => _jumpToToday(controller),
              canManage: canManage,
              onCreateRequest: () => _handleCreateFromHeader(controller),
              onPermissionDenied: _showPermissionDeniedSnackBar,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: calendarHeight,
              child: SfCalendar(
                controller: _calendarController,
                view: _calendarView,
                allowedViews: const <CalendarView>[
                  CalendarView.week,
                  CalendarView.month,
                ],
                headerHeight: 0,
                viewHeaderHeight: 80,
                // headerStyle: CalendarHeaderStyle(
                //   backgroundColor: theme.colorScheme.surface,
                //   textStyle: theme.textTheme.headlineLarge
                // ),
                // headerDateFormat: 'y MMMM',
                viewHeaderStyle: ViewHeaderStyle(
                  dateTextStyle: theme.textTheme.titleMedium,
                  dayTextStyle: theme.textTheme.titleMedium,
                ),
                backgroundColor: theme.colorScheme.surface,
                dataSource: dataSource,
                // allowAppointmentResize: true,
                firstDayOfWeek: 1,
                showNavigationArrow: true,
                todayHighlightColor: theme.colorScheme.error,
                monthViewSettings: MonthViewSettings(
                  showAgenda: true,
                  appointmentDisplayCount: 3,
                  appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                  monthCellStyle: MonthCellStyle(
                    trailingDatesBackgroundColor:
                        theme.colorScheme.inversePrimary,
                    leadingDatesBackgroundColor:
                        theme.colorScheme.inversePrimary,
                  ),
                ),
                timeZone: _koreaTimeZoneId,
                timeSlotViewSettings: const TimeSlotViewSettings(
                  startHour: 8,
                  endHour: 22,
                  timeIntervalHeight: _timeSlotIntervalHeight,
                  // timeInterval: Duration(minutes: 30)
                  timeFormat: 'H:mm',
                ),
                appointmentBuilder:
                    (BuildContext context, CalendarAppointmentDetails details) {
                      final LectureViewModel vm =
                          details.appointments.first as LectureViewModel;
                      final bool isOngoing =
                          DateTime.now().isAfter(vm.start) &&
                          DateTime.now().isBefore(vm.end);
                      return _LectureAppointmentTile(
                        viewModel: vm,
                        isOngoing: isOngoing,
                      );
                    },
                loadMoreWidgetBuilder: (context, loadMoreAppointments) {
                  return FutureBuilder<void>(
                    future: loadMoreAppointments(),
                    builder: (context, snapshot) {
                      print('loadMoreWidgetBuilder called');
                      print('snapshot: $snapshot');

                      return Container(
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
                onViewChanged: (ViewChangedDetails details) =>
                    _handleVisibleDatesChange(details, controller),
                onTap: (CalendarTapDetails details) =>
                    _handleCalendarTap(details, canManage, controller),
              ),
            ),
            if (state.isLoading && viewModels.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  state.errorMessage ?? '알 수 없는 오류가 발생했습니다.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            if (!state.isLoading && !state.hasError && viewModels.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  '표시할 일정이 없습니다.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 주/월 뷰 전환 시 내부 상태와 데이터를 동기화한다.
  void _updateCalendarView(
    CalendarView value,
    ClassroomTimetableController controller,
  ) {
    setState(() {
      _calendarView = value;
    });
    _calendarController.view = value;
    _refreshTimetable(controller, _currentRange());
  }

  /// 이전/다음 탐색 버튼을 처리해 기준 날짜를 이동한다.
  void _navigateCalendar(int delta, ClassroomTimetableController controller) {
    setState(() {
      _focusedDate = _calendarView == CalendarView.week
          ? _focusedDate.add(Duration(days: 7 * delta))
          : DateTime(
              _focusedDate.year,
              _focusedDate.month + delta,
              _focusedDate.day,
            );
    });
    _calendarController.displayDate = _focusedDate;
    _refreshTimetable(controller, _currentRange());
  }

  /// 오늘 버튼을 눌렀을 때 기준 날짜를 현재 날짜로 맞춘다.
  void _jumpToToday(ClassroomTimetableController controller) {
    setState(() {
      _focusedDate = DateTime.now();
    });
    _calendarController.displayDate = _focusedDate;
    _refreshTimetable(controller, _currentRange());
  }

  /// 캘린더 가시 범위가 바뀌면 포커스 날짜와 조회 범위를 갱신한다.
  void _handleVisibleDatesChange(
    ViewChangedDetails details,
    ClassroomTimetableController controller,
  ) {
    if (details.visibleDates.isEmpty) {
      return;
    }
    final int middleIndex = (details.visibleDates.length / 2).floor();
    final DateTime middleDate = details.visibleDates[middleIndex];
    final TimetableDateRange nextRange = _rangeFromVisibleDates(
      details.visibleDates,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _focusedDate = middleDate;
      });
      _refreshTimetable(controller, nextRange);
    });
  }

  /// 컨트롤러에 선택된 기간을 전달하고 데이터를 다시 불러온다.
  void _refreshTimetable(
    ClassroomTimetableController controller,
    TimetableDateRange range,
  ) {
    controller
      ..updateRange(range)
      ..loadLectures(range: range);
  }

  /// 현재 뷰 모드에 맞춰 주간 혹은 월간 조회 범위를 계산한다.
  TimetableDateRange _currentRange() {
    return _calendarView == CalendarView.week
        ? TimetableDateRange.weekOf(_focusedDate)
        : TimetableDateRange.monthOf(_focusedDate);
  }

  /// 캘린더가 제공하는 가시 날짜 목록을 조회 범위로 변환한다.
  TimetableDateRange _rangeFromVisibleDates(List<DateTime> visibleDates) {
    if (_calendarView == CalendarView.month) {
      return TimetableDateRange.monthOf(visibleDates.first);
    }
    final DateTime start = visibleDates.first;
    final DateTime end = visibleDates.last;
    return _rangeFromDates(start, end);
  }

  /// 로드 모어 이벤트에 맞춰 서버에서 추가 강의 일정을 받아온다.
  Future<List<LectureViewModel>> _loadMoreLectures({
    required DateTime from,
    required DateTime to,
    required ClassroomTimetableController controller,
    required LectureColorResolver colorResolver,
  }) async {
    final TimetableDateRange range = _rangeFromDates(from, to);
    final List<LectureEntity> lectures = await controller.fetchLecturesByRange(
      range,
    );
    return lectures
        .map(
          (LectureEntity lecture) => LectureViewModel.fromEntity(
            lecture,
            color: colorResolver.resolveColor(lecture),
          ),
        )
        .toList();
  }

  /// 시작/종료 DateTime을 TimetableDateRange로 정규화한다.
  TimetableDateRange _rangeFromDates(DateTime start, DateTime end) {
    return TimetableDateRange(
      from: DateTime(start.year, start.month, start.day),
      to: DateTime(end.year, end.month, end.day, 23, 59, 59),
    );
  }

  /// 헤더에서 일정 등록 버튼을 눌렀을 때 기본 시작 시간을 제안한다.
  void _handleCreateFromHeader(ClassroomTimetableController controller) {
    final DateTime suggestedStart = DateTime(
      _focusedDate.year,
      _focusedDate.month,
      _focusedDate.day,
      9,
    );
    _openCreateDialog(controller, suggestedStart);
  }

  /// 캘린더 셀 혹은 일정 탭에 따라 생성/수정 모달을 구분해 띄운다.
  void _handleCalendarTap(
    CalendarTapDetails details,
    bool canManage,
    ClassroomTimetableController controller,
  ) {
    if (details.targetElement == CalendarElement.appointment &&
        (details.appointments?.isNotEmpty ?? false)) {
      if (!canManage) {
        _showPermissionDeniedSnackBar();
        return;
      }
      final LectureViewModel vm =
          details.appointments!.first as LectureViewModel;
      _openDetailDialog(controller, vm);
      return;
    }
    if (details.targetElement == CalendarElement.calendarCell &&
        details.date != null) {
      if (!canManage) {
        _showPermissionDeniedSnackBar();
        return;
      }
      _openCreateDialog(controller, details.date!);
    }
  }

  /// 역할 정보로 관리자 권한 여부를 파악한다.
  bool _canManageRoles(List<UserRole> roles) {
    return roles.any(
      (UserRole role) =>
          role == UserRole.admin ||
          role == UserRole.operator ||
          role == UserRole.limitedOperator,
    );
  }

  /// 권한이 없을 때 경고 스낵바를 표시한다.
  void _showPermissionDeniedSnackBar() {
    if (!mounted) {
      return;
    }
    AppSnackBar.show(
      context,
      message: '권한이 없습니다. 관리자/운영자만 가능합니다.',
      type: AppSnackBarType.warning,
    );
  }

  /// 날짜 범위를 로케일에 맞춰 문자열로 변환한다.
  String _formatRange(DateTime start, DateTime end) {
    final String localeTag = Localizations.localeOf(context).toLanguageTag();
    return DateTimeUtils.formatRange(
      start,
      end,
      startPattern: _rangeStartPattern,
      endPattern: _rangeEndPattern,
      locale: localeTag,
    );
  }

  /// 공통 스낵바 메시지를 노출한다.
  void _showPendingFeature(String message) {
    if (!mounted) {
      return;
    }
    AppSnackBar.show(context, message: message, type: AppSnackBarType.info);
  }

  void _openCreateDialog(
    ClassroomTimetableController controller,
    DateTime start,
  ) {
    ClassroomTimetableModal.show(
      context: context,
      mode: ClassroomTimetableModalMode.create,
      classroomId: widget.classroomId,
      classroomName: '공학관 ${widget.classroomId}',
      initialStart: start,
      onCreateSubmit: (LectureWriteInput input) =>
          _handleCreateSubmit(controller, input),
    );
  }

  void _openDetailDialog(
    ClassroomTimetableController controller,
    LectureViewModel vm,
  ) {
    ClassroomTimetableDialogs.showDetailDialog(
      context: context,
      lecture: vm,
      formatRange: _formatRange,
      onSuspendPending: () =>
          _showPendingFeature('휴강 처리 기능은 준비 중입니다.'),
      onEditPending: () => _openEditDialog(controller, vm),
    );
  }

  void _openEditDialog(
    ClassroomTimetableController controller,
    LectureViewModel vm,
  ) {
    ClassroomTimetableModal.show(
      context: context,
      mode: ClassroomTimetableModalMode.edit,
      classroomId: widget.classroomId,
      classroomName: vm.classroomName,
      initialStart: vm.start,
      initialLecture: vm,
      onUpdateSubmit: (UpdateLectureInput input) =>
          _handleUpdateSubmit(controller, vm, input),
    );
  }

  Future<void> _handleCreateSubmit(
    ClassroomTimetableController controller,
    LectureWriteInput input,
  ) async {
    await _saveLecture(
      controller: controller,
      payload: input,
      successMessage: '일정이 등록되었습니다.',
    );
  }

  Future<void> _handleUpdateSubmit(
    ClassroomTimetableController controller,
    LectureViewModel original,
    UpdateLectureInput input,
  ) async {
    final Set<LectureField> changedFields = _computeChangedFields(
      original,
      input.payload,
    );
    if (changedFields.isEmpty) {
      if (mounted) {
        AppSnackBar.show(
          context,
          message: '변경된 내용이 없습니다.',
          type: AppSnackBarType.info,
        );
      }
      return;
    }
    await _saveLecture(
      controller: controller,
      payload: input.payload,
      lectureId: input.lectureId,
      expectedVersion: input.expectedVersion,
      changedFields: changedFields,
      successMessage: '일정이 수정되었습니다.',
    );
  }

  Future<void> _saveLecture({
    required ClassroomTimetableController controller,
    required LectureWriteInput payload,
    String? lectureId,
    int? expectedVersion,
    Set<LectureField>? changedFields,
    required String successMessage,
  }) async {
    try {
      await controller.saveLecture(
        payload: payload,
        lectureId: lectureId,
        expectedVersion: expectedVersion,
        updatedFields: changedFields,
      );
      if (!mounted) {
        return;
      }
      AppSnackBar.show(
        context,
        message: successMessage,
        type: AppSnackBarType.success,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      AppSnackBar.show(
        context,
        message: '일정 저장에 실패했습니다.',
        type: AppSnackBarType.error,
      );
    }
  }

  Set<LectureField> _computeChangedFields(
    LectureViewModel original,
    LectureWriteInput next,
  ) {
    final Set<LectureField> fields = <LectureField>{};
    if (original.title.trim() != next.title.trim()) {
      fields.add(LectureField.title);
    }
    if (original.type != next.type) {
      fields.add(LectureField.type);
    }
    if (!_isSameMoment(original.start, next.start)) {
      fields.add(LectureField.startTime);
    }
    if (!_isSameMoment(original.end, next.end)) {
      fields.add(LectureField.endTime);
    }
    if (_normalizeText(original.departmentName) !=
        _normalizeText(next.departmentId)) {
      fields.add(LectureField.departmentId);
    }
    if (_normalizeText(original.instructorName) !=
        _normalizeText(next.instructorId)) {
      fields.add(LectureField.instructorId);
    }
    if (_colorHexFromColor(original.color) != _normalizeHex(next.colorHex)) {
      fields.add(LectureField.colorHex);
    }
    if (_normalizeText(original.recurrenceRule) !=
        _normalizeText(next.recurrenceRule)) {
      fields.add(LectureField.recurrenceRule);
    }
    if (_normalizeText(original.notes) != _normalizeText(next.notes)) {
      fields.add(LectureField.notes);
    }
    return fields;
  }

  bool _isSameMoment(DateTime a, DateTime b) =>
      a.toUtc().isAtSameMomentAs(b.toUtc());

  String _normalizeText(String? value) => value?.trim() ?? '';

  String _colorHexFromColor(Color color) {
    final int r = (color.r * 255.0).round() & 0xff;
    final int g = (color.g * 255.0).round() & 0xff;
    final int b = (color.b * 255.0).round() & 0xff;
    return '${r.toRadixString(16).padLeft(2, '0')}'
            '${g.toRadixString(16).padLeft(2, '0')}'
            '${b.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  String _normalizeHex(String? value) {
    final String normalized =
        value?.replaceAll('#', '').trim().toUpperCase() ?? '';
    return normalized;
  }
}

/// 시간표 카드 상단 컨트롤 UI를 담당하는 위젯.
class _TimetableHeader extends StatelessWidget {
  const _TimetableHeader({
    required this.view,
    required this.range,
    required this.isLoading,
    required this.onViewChanged,
    required this.onNavigate,
    required this.onToday,
    required this.canManage,
    required this.onCreateRequest,
    required this.onPermissionDenied,
  });

  final CalendarView view;
  final TimetableDateRange? range;
  final bool isLoading;
  final ValueChanged<CalendarView> onViewChanged;
  final ValueChanged<int> onNavigate;
  final VoidCallback onToday;
  final bool canManage;
  final VoidCallback onCreateRequest;
  final VoidCallback onPermissionDenied;

  /// 주/월 토글과 기간 이동 컨트롤을 배치한다.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String periodText = range == null
        ? ''
        : '${range!.from.year}.${range!.from.month}.${range!.from.day}'
              ' ~ ${range!.to.year}.${range!.to.month}.${range!.to.day}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            ToggleButtons(
              isSelected: <bool>[
                view == CalendarView.week,
                view == CalendarView.month,
              ],
              onPressed: (int index) {
                onViewChanged(
                  index == 0 ? CalendarView.week : CalendarView.month,
                );
              },
              borderRadius: BorderRadius.circular(8),
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('주간'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('월간'),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Text(periodText, style: theme.textTheme.titleMedium),
            const Spacer(),
            IconButton(
              tooltip: '이전',
              onPressed: () => onNavigate(-1),
              icon: const Icon(Icons.chevron_left),
            ),
            IconButton(
              tooltip: '다음',
              onPressed: () => onNavigate(1),
              icon: const Icon(Icons.chevron_right),
            ),
            TextButton(onPressed: onToday, child: const Text('오늘')),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: canManage ? onCreateRequest : onPermissionDenied,
              icon: const Icon(Icons.add),
              label: const Text('일정 등록'),
            ),
          ],
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}

/// 캘린더 내 개별 강의 일정을 그리는 타일 위젯.
class _LectureAppointmentTile extends StatelessWidget {
  const _LectureAppointmentTile({
    required this.viewModel,
    required this.isOngoing,
  });

  final LectureViewModel viewModel;
  final bool isOngoing;

  /// 일정 색상과 텍스트 정보를 꾸며서 반환한다.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color borderColor = isOngoing
        ? theme.colorScheme.onSurface
        : viewModel.color.withValues(alpha: 0.4);
    return Container(
      decoration: BoxDecoration(
        color: viewModel.color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: isOngoing ? 1.4 : 0.5),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          Text(
            viewModel.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (viewModel.instructorName != null)
            Text(
              viewModel.instructorName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
        ],
      ),
    );
  }
}
