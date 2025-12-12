import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Simple SfCalendar sample wired to the current theme colors.
class CalendarThemePreview extends StatelessWidget {
  const CalendarThemePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Calendar Theme Preview',
              style: textTheme.titleMedium?.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Syncfusion SfCalendar running with AppTheme colors.',
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 360,
              child: SfCalendar(
                view: CalendarView.week,
                allowedViews: const <CalendarView>[
                  CalendarView.week,
                  CalendarView.month,
                ],
                headerStyle: CalendarHeaderStyle(
                  textStyle: textTheme.titleSmall?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                viewHeaderStyle: ViewHeaderStyle(
                  dayTextStyle: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.7),
                  ),
                  dateTextStyle: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                backgroundColor: scheme.surface,
                todayHighlightColor: scheme.primary,
                selectionDecoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.12),
                  border: Border.all(color: scheme.primary, width: 1.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                dataSource: _PreviewCalendarDataSource(
                  _buildPreviewAppointments(scheme),
                ),
                monthViewSettings: MonthViewSettings(
                  showAgenda: true,
                  agendaStyle: AgendaStyle(
                    backgroundColor: scheme.surface,
                    appointmentTextStyle: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface,
                    ),
                    dayTextStyle: textTheme.labelSmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Appointment> _buildPreviewAppointments(ColorScheme scheme) {
  final DateTime today = DateTime.now();
  final DateTime monday =
      today.subtract(Duration(days: today.weekday - DateTime.monday));
  final DateTime tuesday = monday.add(const Duration(days: 1));
  final DateTime wednesday = monday.add(const Duration(days: 2));

  return <Appointment>[
    Appointment(
      startTime: DateTime(monday.year, monday.month, monday.day, 9),
      endTime: DateTime(monday.year, monday.month, monday.day, 11),
      subject: 'Lecture · 402',
      color: scheme.primary,
    ),
    Appointment(
      startTime: DateTime(tuesday.year, tuesday.month, tuesday.day, 13),
      endTime: DateTime(tuesday.year, tuesday.month, tuesday.day, 14, 30),
      subject: 'Event · Workshop',
      color: scheme.secondary,
    ),
    Appointment(
      startTime: DateTime(wednesday.year, wednesday.month, wednesday.day, 10),
      endTime: DateTime(wednesday.year, wednesday.month, wednesday.day, 12),
      subject: 'Exam · Midterm',
      color: scheme.error.withValues(alpha: 0.9),
    ),
  ];
}

class _PreviewCalendarDataSource extends CalendarDataSource {
  _PreviewCalendarDataSource(List<Appointment> data) {
    appointments = data;
  }
}
