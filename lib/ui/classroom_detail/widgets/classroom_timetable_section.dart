import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mdk_app_theme/theme_utilities.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
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

  @override
  void initState() {
    super.initState();
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
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
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
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _TimetableHeader(
              view: _calendarView,
              range: range,
              isLoading: state.isLoading,
              onViewChanged: (CalendarView value) {
                setState(() {
                  _calendarView = value;
                });
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
                final TimetableDateRange nextRange = _currentRange();
                controller.updateRange(nextRange);
                controller.loadLectures(range: nextRange);
              },
              onToday: () {
                setState(() {
                  _focusedDate = DateTime.now();
                });
                final TimetableDateRange nextRange = _currentRange();
                controller.updateRange(nextRange);
                controller.loadLectures(range: nextRange);
              },
              onCreate: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('일정 등록 기능은 준비 중입니다.')),
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: _calendarView == CalendarView.week ? 520 : 480,
              child: SfCalendar(
                view: _calendarView,
                allowedViews: const <CalendarView>[
                  CalendarView.week,
                  CalendarView.month,
                ],
                headerHeight: 0,
                backgroundColor: theme.colorScheme.surface,
                dataSource: dataSource,
                showNavigationArrow: false,
                todayHighlightColor: theme.colorScheme.primary,
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
}

class _TimetableHeader extends StatelessWidget {
  const _TimetableHeader({
    required this.view,
    required this.range,
    required this.isLoading,
    required this.onViewChanged,
    required this.onNavigate,
    required this.onToday,
    required this.onCreate,
  });

  final CalendarView view;
  final TimetableDateRange? range;
  final bool isLoading;
  final ValueChanged<CalendarView> onViewChanged;
  final ValueChanged<int> onNavigate;
  final VoidCallback onToday;
  final VoidCallback onCreate;

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
              onPressed: onCreate,
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
