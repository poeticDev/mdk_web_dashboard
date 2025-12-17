import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mdk_app_theme/theme_utilities.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:web_dashboard/core/auth/application/auth_controller.dart';
import 'package:web_dashboard/core/auth/domain/entities/auth_user.dart';
import 'package:web_dashboard/core/timetable/application/controllers/classroom_timetable_controller.dart';
import 'package:web_dashboard/core/timetable/application/state/classroom_timetable_state.dart';
import 'package:web_dashboard/core/timetable/presentation/datasources/lecture_calendar_data_source.dart';
import 'package:web_dashboard/core/timetable/presentation/utils/lecture_color_resolver.dart';
import 'package:web_dashboard/core/timetable/presentation/viewmodels/lecture_view_model.dart';

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

  @override
  void initState() {
    super.initState();
    _calendarController.view = _calendarView;
    _calendarController.displayDate = _focusedDate;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(
          classroomTimetableControllerProvider(widget.classroomId).notifier,
        )
        ..updateRange(_currentRange())
        ..loadLectures(range: _currentRange());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      classroomTimetableControllerProvider(widget.classroomId),
    );
    final controller = ref.read(
      classroomTimetableControllerProvider(widget.classroomId).notifier,
    );
    final authState = ref.watch(authControllerProvider);
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final bool canManage =
        _canManageRoles(authState.currentUser?.roles ?? const <UserRole>[]);
    final AppColors appColors = isDark
        ? AppColors.dark(ThemeBrand.defaultBrand)
        : AppColors.light(ThemeBrand.defaultBrand);
    final LectureColorResolver colorResolver = LectureColorResolver(appColors);
    final List<LectureViewModel> viewModels = state.lectures.map((lecture) {
      return LectureViewModel.fromEntity(
        lecture,
        color: colorResolver.resolveColor(lecture),
      );
    }).toList();
    final LectureCalendarDataSource dataSource = LectureCalendarDataSource(
      viewModels,
    );
    final TimetableDateRange? range = state.visibleRange;

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
              onViewChanged: (CalendarView value) {
                setState(() {
                  _calendarView = value;
                });
                _calendarController.view = value;
                final TimetableDateRange nextRange = _currentRange();
                controller.updateRange(nextRange);
                controller.loadLectures(range: nextRange);
              },
              onNavigate: (int delta) {
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
                final TimetableDateRange nextRange = _currentRange();
                controller.updateRange(nextRange);
                controller.loadLectures(range: nextRange);
              },
              onToday: () {
                setState(() {
                  _focusedDate = DateTime.now();
                });
                _calendarController.displayDate = _focusedDate;
                final TimetableDateRange nextRange = _currentRange();
                controller.updateRange(nextRange);
                controller.loadLectures(range: nextRange);
              },
              canManage: canManage,
              onCreateRequest: _handleCreateFromHeader,
              onPermissionDenied: _showPermissionDeniedSnackBar,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: _calendarView == CalendarView.week ? 800 : 600,
              child: SfCalendar(
                controller: _calendarController,
                view: _calendarView,
                allowedViews: const <CalendarView>[
                  CalendarView.week,
                  CalendarView.month,
                ],
                headerHeight: 0,
                backgroundColor: theme.colorScheme.surface,
                dataSource: dataSource,
                showNavigationArrow: false,
                todayHighlightColor: theme.colorScheme.secondary,
                monthViewSettings: MonthViewSettings(
                  showAgenda: true,
                  appointmentDisplayCount: 3,
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                ),
                timeSlotViewSettings: const TimeSlotViewSettings(
                  startHour: 8,
                  endHour: 22,
                  timeIntervalHeight: 60,
                ),
                appointmentBuilder:
                    (BuildContext context, CalendarAppointmentDetails details) {
                      final LectureViewModel vm = details.appointments.first;
                      final bool isOngoing =
                          DateTime.now().isAfter(vm.start) &&
                          DateTime.now().isBefore(vm.end);
                      return Container(
                        decoration: BoxDecoration(
                          color: vm.color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isOngoing
                                ? theme.colorScheme.onSurface
                                : vm.color.withValues(alpha: 0.4),
                            width: isOngoing ? 1.4 : 0.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              vm.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (vm.instructorName != null)
                              Text(
                                vm.instructorName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                onViewChanged: (ViewChangedDetails details) {
                  if (details.visibleDates.isEmpty) {
                    return;
                  }

                  final DateTime middleDate = details
                      .visibleDates[(details.visibleDates.length / 2).floor()];
                  final TimetableDateRange nextRange = _rangeFromVisibleDates(
                    details.visibleDates,
                  );

                  // 캘린더 레이아웃이 끝난 다음 프레임에 실행
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;

                    setState(() {
                      _focusedDate = middleDate;
                    });

                    controller.updateRange(nextRange);
                    controller.loadLectures(range: nextRange);
                  });
                },
                onTap: (CalendarTapDetails details) =>
                    _handleCalendarTap(details, canManage),
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

  TimetableDateRange _currentRange() {
    return _calendarView == CalendarView.week
        ? TimetableDateRange.weekOf(_focusedDate)
        : TimetableDateRange.monthOf(_focusedDate);
  }

  TimetableDateRange _rangeFromVisibleDates(List<DateTime> visibleDates) {
    if (_calendarView == CalendarView.month) {
      return TimetableDateRange.monthOf(visibleDates.first);
    }
    final DateTime start = visibleDates.first;
    final DateTime end = visibleDates.last;
    return TimetableDateRange(
      from: DateTime(start.year, start.month, start.day),
      to: DateTime(end.year, end.month, end.day, 23, 59, 59),
    );
  }

  void _handleCreateFromHeader() {
    final DateTime suggestedStart = DateTime(
      _focusedDate.year,
      _focusedDate.month,
      _focusedDate.day,
      9,
    );
    _showCreateModal(suggestedStart);
  }

  void _handleCalendarTap(CalendarTapDetails details, bool canManage) {
    if (details.targetElement == CalendarElement.appointment &&
        (details.appointments?.isNotEmpty ?? false)) {
      if (!canManage) {
        _showPermissionDeniedSnackBar();
        return;
      }
      final LectureViewModel vm =
          details.appointments!.first as LectureViewModel;
      _showEditModal(vm);
      return;
    }
    if (details.targetElement == CalendarElement.calendarCell &&
        details.date != null) {
      if (!canManage) {
        _showPermissionDeniedSnackBar();
        return;
      }
      _showCreateModal(details.date!);
    }
  }

  bool _canManageRoles(List<UserRole> roles) {
    return roles.any(
      (UserRole role) =>
          role == UserRole.admin ||
          role == UserRole.operator ||
          role == UserRole.limitedOperator,
    );
  }

  void _showPermissionDeniedSnackBar() {
    _showComingSoonSnackBar('권한이 없습니다. 관리자/운영자만 가능합니다.');
  }

  Future<void> _showCreateModal(DateTime start) async {
    final DateTime end = start.add(const Duration(hours: 1));
    final TextEditingController titleController = TextEditingController(
      text: '${start.month}월 ${start.day}일 일정',
    );
    final TextEditingController memoController = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('새 일정 등록 (더미)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('시간: ${_formatRange(start, end)}'),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: '강의명'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: memoController,
                decoration: const InputDecoration(labelText: '메모'),
                maxLines: 2,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showComingSoonSnackBar('일정 등록 API는 준비 중입니다.');
              },
              child: const Text('등록'),
            ),
          ],
        );
      },
    );
    titleController.dispose();
    memoController.dispose();
  }

  Future<void> _showEditModal(LectureViewModel vm) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('일정 상세 (더미)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('강의명: ${vm.title}'),
              Text('강의실: ${vm.classroomName}'),
              Text('시간: ${_formatRange(vm.start, vm.end)}'),
              if (vm.instructorName != null)
                Text('강사: ${vm.instructorName}'),
              const SizedBox(height: 8),
              Text('상태: ${vm.statusLabel}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('닫기'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showComingSoonSnackBar('휴강 처리 기능은 준비 중입니다.');
              },
              child: const Text('휴강 처리'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showComingSoonSnackBar('일정 수정 API는 준비 중입니다.');
              },
              child: const Text('수정'),
            ),
          ],
        );
      },
    );
  }

  String _formatRange(DateTime start, DateTime end) {
    return '${start.month}/${start.day} '
        '${_twoDigits(start.hour)}:${_twoDigits(start.minute)}'
        ' ~ ${_twoDigits(end.hour)}:${_twoDigits(end.minute)}';
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  void _showComingSoonSnackBar(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

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
