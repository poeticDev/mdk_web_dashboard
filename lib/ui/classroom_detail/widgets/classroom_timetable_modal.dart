import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mdk_app_theme/theme_utilities.dart';
import 'package:web_dashboard/common/widgets/app_dialog.dart';
import 'package:web_dashboard/common/widgets/app_snack_bar.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_origin_repository.dart';
import 'package:web_dashboard/core/timetable/presentation/viewmodels/lecture_view_model.dart';

const List<Color> _lectureColorPalette = <Color>[
  Color(0xFFE3EFF7),
  Color(0xFFFFE3E3),
  Color(0xFFFFE8D1),
  Color(0xFFFFF5CC),
  Color(0xFFDFF7DF),
  Color(0xFFD6CCFF),
];

enum WeeklyRepeatOption { none, weeks, until }

enum ClassroomTimetableModalMode { create, edit }

/// 일정 등록/수정을 위한 공통 모달.
class ClassroomTimetableModal extends StatefulWidget {
  const ClassroomTimetableModal({
    required this.mode,
    required this.classroomId,
    required this.classroomName,
    required this.initialStart,
    this.onCreateSubmit,
    this.onUpdateSubmit,
    this.initialLecture,
    super.key,
  });

  final ClassroomTimetableModalMode mode;
  final String classroomId;
  final String classroomName;
  final DateTime initialStart;
  final LectureViewModel? initialLecture;
  final ValueChanged<LectureOriginWriteInput>? onCreateSubmit;
  final ValueChanged<LectureOriginUpdateInput>? onUpdateSubmit;

  static Future<void> show({
    required BuildContext context,
    required ClassroomTimetableModalMode mode,
    required String classroomId,
    required String classroomName,
    required DateTime initialStart,
    LectureViewModel? initialLecture,
    ValueChanged<LectureOriginWriteInput>? onCreateSubmit,
    ValueChanged<LectureOriginUpdateInput>? onUpdateSubmit,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) {
        return ClassroomTimetableModal(
          mode: mode,
          classroomId: classroomId,
          classroomName: classroomName,
          initialStart: initialStart,
          initialLecture: initialLecture,
          onCreateSubmit: onCreateSubmit,
          onUpdateSubmit: onUpdateSubmit,
        );
      },
    );
  }

  @override
  State<ClassroomTimetableModal> createState() =>
      _ClassroomTimetableModalState();
}

class _ClassroomTimetableModalState extends State<ClassroomTimetableModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _departmentController;
  late TextEditingController _instructorController;
  late TextEditingController _memoController;
  late TextEditingController _repeatCountController;
  late LectureType _selectedType;
  late DateTime _start;
  late DateTime _end;
  late Color _selectedColor;
  WeeklyRepeatOption _repeatOption = WeeklyRepeatOption.none;
  int _repeatWeekCount = 1;
  DateTime? _repeatUntilDate;

  @override
  void initState() {
    super.initState();
    _initFormFields();
  }

  void _initFormFields() {
    final LectureViewModel? lecture = widget.initialLecture;
    _titleController = TextEditingController(text: lecture?.title ?? '');
    _departmentController =
        TextEditingController(text: lecture?.departmentName ?? '');
    _instructorController =
        TextEditingController(text: lecture?.instructorName ?? '');
    _memoController = TextEditingController(text: lecture?.notes ?? '');
    _repeatCountController = TextEditingController();
    _selectedType = lecture != null ? lecture.type : LectureType.lecture;
    _start = lecture?.start ?? widget.initialStart;
    _end = lecture?.end ?? widget.initialStart.add(const Duration(hours: 1));
    _selectedColor = lecture?.color ?? _lectureColorPalette.first;
    if (_isForcedColor(_selectedType)) {
      _selectedColor = _forcedColorForType(_selectedType);
    }
    _applyExistingRecurrence(lecture?.recurrenceRule);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _departmentController.dispose();
    _instructorController.dispose();
    _memoController.dispose();
    _repeatCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: Text(_resolveTitle(widget.mode)),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ModalContextSummary(
                  classroomName: widget.classroomName,
                  mode: widget.mode,
                ),
                const SizedBox(height: 16),
                _TitleField(controller: _titleController),
                const SizedBox(height: 12),
                _TypeField(
                  value: _selectedType,
                  onChanged: (LectureType? type) {
                    if (type == null) {
                      return;
                    }
                    setState(() {
                      _selectedType = type;
                      if (_isForcedColor(type)) {
                        _selectedColor = _forcedColorForType(type);
                      }
                    });
                  },
                ),
                const SizedBox(height: 12),
                _DepartmentField(controller: _departmentController),
                const SizedBox(height: 12),
                _InstructorField(controller: _instructorController),
                const SizedBox(height: 12),
                _DateTimeFields(
                  start: _start,
                  end: _end,
                  onChanged: (DateTime newStart, DateTime newEnd) {
                    setState(() {
                      _start = newStart;
                      _end = newEnd;
                    });
                  },
                ),
                const SizedBox(height: 12),
                _ColorPickerField(
                  selected: _effectiveColor,
                  palette: _lectureColorPalette,
                  disabled: _isForcedColor(_selectedType),
                  onChanged: (Color color) {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                ),
                const SizedBox(height: 12),
                _buildRecurrenceOptions(),
                const SizedBox(height: 12),
                _MemoField(controller: _memoController),
              ],
            ),
          ),
        ),
      ),
      actions: <AppDialogAction>[
        AppDialogAction(
          label: '닫기',
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppDialogAction(
          label: widget.mode == ClassroomTimetableModalMode.create ? '등록' : '수정',
          isPrimary: true,
          onPressed: _handleSubmit,
        ),
      ],
    );
  }

  String _resolveTitle(ClassroomTimetableModalMode mode) {
    return mode == ClassroomTimetableModalMode.create ? '새 일정 등록' : '일정 수정';
  }

  Color get _effectiveColor =>
      _isForcedColor(_selectedType) ? _forcedColorForType(_selectedType) : _selectedColor;

  bool _isForcedColor(LectureType type) =>
      type == LectureType.event || type == LectureType.exam;

  AppColors _resolveAppColors() {
    final Brightness brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? AppColors.dark(ThemeBrand.defaultBrand)
        : AppColors.light(ThemeBrand.defaultBrand);
  }

  Color _forcedColorForType(LectureType type) {
    final AppColors palette = _resolveAppColors();
    switch (type) {
      case LectureType.event:
        return palette.success;
      case LectureType.exam:
        return palette.warning;
      case LectureType.lecture:
        return _selectedColor;
    }
  }

  Widget _buildRecurrenceOptions() {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('주 반복 옵션', style: theme.textTheme.titleSmall),
        _OptionTile(
          label: '반복 없음',
          value: _repeatOption == WeeklyRepeatOption.none,
          onChanged: () => _setRepeatOption(WeeklyRepeatOption.none),
        ),
        _OptionTile(
          label: '0주간 반복',
          value: _repeatOption == WeeklyRepeatOption.weeks,
          onChanged: () => _setRepeatOption(WeeklyRepeatOption.weeks),
          child: Padding(
            padding: const EdgeInsets.only(left: 32, top: 8),
            child: SizedBox(
              width: 120,
              child: TextFormField(
                controller: _repeatCountController,
                enabled: _repeatOption == WeeklyRepeatOption.weeks,
                decoration: const InputDecoration(
                  labelText: '주 횟수 (1-99)',
                  counterText: '',
                ),
                maxLength: 2,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: _onWeekCountChanged,
              ),
            ),
          ),
        ),
        _OptionTile(
          label: '특정 날짜까지 반복',
          value: _repeatOption == WeeklyRepeatOption.until,
          onChanged: () => _setRepeatOption(WeeklyRepeatOption.until),
          child: Padding(
            padding: const EdgeInsets.only(left: 32, top: 8),
            child: OutlinedButton.icon(
              onPressed: _repeatOption == WeeklyRepeatOption.until
                  ? _pickRepeatUntilDate
                  : null,
              icon: const Icon(Icons.calendar_month),
              label: Text(
                _repeatUntilDate == null
                    ? '종료 날짜 선택'
                    : _formatKoreanDate(_repeatUntilDate!),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _repeatSummaryText(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: _buildSubtleOnSurface(theme),
          ),
        ),
      ],
    );
  }

  void _setRepeatOption(WeeklyRepeatOption option) {
    setState(() {
      _repeatOption = option;
      if (option != WeeklyRepeatOption.weeks) {
        _repeatWeekCount = _repeatWeekCount.clamp(1, 99);
        _repeatCountController.text = _repeatWeekCount.toString();
      }
      if (option != WeeklyRepeatOption.until) {
        _repeatUntilDate = null;
      }
    });
  }

  void _onWeekCountChanged(String value) {
    final int parsed = int.tryParse(value) ?? 1;
    setState(() {
      _repeatWeekCount = parsed.clamp(1, 99);
      _repeatCountController.text = _repeatWeekCount.toString();
    });
  }

  Future<void> _pickRepeatUntilDate() async {
    final DateTime initial =
        _repeatUntilDate ?? _start.add(const Duration(days: 7));
    final DateTime firstDate =
        DateTime(_start.year, _start.month, _start.day);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: DateTime(_start.year + 5),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _repeatUntilDate = picked;
    });
  }

  String _repeatSummaryText() {
    switch (_repeatOption) {
      case WeeklyRepeatOption.none:
        return '반복 없음';
      case WeeklyRepeatOption.weeks:
        final DateTime last =
            _start.add(Duration(days: 7 * (_repeatWeekCount - 1)));
        return '$_repeatWeekCount주간 반복 · '
            '${_formatKoreanDate(last)}까지 매주 반복됩니다.';
      case WeeklyRepeatOption.until:
        if (_repeatUntilDate == null) {
          return '종료 날짜를 선택하세요.';
        }
        return '${_formatKoreanDate(_repeatUntilDate!)}까지 매주 반복됩니다.';
    }
  }

  String _formatKoreanDate(DateTime date) =>
      '${date.year}년 ${date.month}월 ${date.day}일';

  Color _buildSubtleOnSurface(ThemeData theme) {
    final Color base = theme.colorScheme.onSurface;
    return base.withValues(alpha: base.a * 0.7);
  }

  String? _buildRecurrenceRule() {
    if (_repeatOption == WeeklyRepeatOption.none) {
      return null;
    }
    final String byDay = _weekdayToken(_start.weekday);
    if (_repeatOption == WeeklyRepeatOption.weeks) {
      final int count = _repeatWeekCount.clamp(1, 99);
      return 'FREQ=WEEKLY;INTERVAL=1;BYDAY=$byDay;COUNT=$count';
    }
    if (_repeatOption == WeeklyRepeatOption.until && _repeatUntilDate != null) {
      final DateTime untilDateTime = DateTime(
        _repeatUntilDate!.year,
        _repeatUntilDate!.month,
        _repeatUntilDate!.day,
        _end.hour,
        _end.minute,
      );
      final String until = _formatUtc(untilDateTime);
      return 'FREQ=WEEKLY;INTERVAL=1;BYDAY=$byDay;UNTIL=$until';
    }
    return null;
  }

  String _weekdayToken(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'MO';
      case DateTime.tuesday:
        return 'TU';
      case DateTime.wednesday:
        return 'WE';
      case DateTime.thursday:
        return 'TH';
      case DateTime.friday:
        return 'FR';
      case DateTime.saturday:
        return 'SA';
      case DateTime.sunday:
      default:
        return 'SU';
    }
  }

  String _formatUtc(DateTime dateTime) {
    final DateTime utc = dateTime.toUtc();
    return '${utc.year.toString().padLeft(4, '0')}'
        '${utc.month.toString().padLeft(2, '0')}'
        '${utc.day.toString().padLeft(2, '0')}T'
        '${utc.hour.toString().padLeft(2, '0')}'
        '${utc.minute.toString().padLeft(2, '0')}'
        '${utc.second.toString().padLeft(2, '0')}Z';
  }

  String _formatColorHex(Color color) {
    final int rChannel = (color.r * 255.0).round() & 0xff;
    final int gChannel = (color.g * 255.0).round() & 0xff;
    final int bChannel = (color.b * 255.0).round() & 0xff;
    final String r = rChannel.toRadixString(16).padLeft(2, '0');
    final String g = gChannel.toRadixString(16).padLeft(2, '0');
    final String b = bChannel.toRadixString(16).padLeft(2, '0');
    return (r + g + b).toUpperCase();
  }

  String? _colorHexForSubmission() {
    final Color color = _effectiveColor;
    return '#${_formatColorHex(color)}';
  }

  void _applyExistingRecurrence(String? rrule) {
    _repeatOption = WeeklyRepeatOption.none;
    _repeatWeekCount = 1;
    _repeatCountController.text = '1';
    _repeatUntilDate = null;
    if (rrule == null || rrule.isEmpty) {
      return;
    }
    final String upper = rrule.toUpperCase();
    if (!upper.contains('FREQ=WEEKLY')) {
      return;
    }
    if (upper.contains('COUNT=')) {
      final RegExpMatch? match = RegExp(r'COUNT=(\d+)').firstMatch(upper);
      if (match != null) {
        final int parsed = int.parse(match.group(1)!);
        _repeatWeekCount = parsed.clamp(1, 99);
        _repeatCountController.text = _repeatWeekCount.toString();
        _repeatOption = WeeklyRepeatOption.weeks;
      }
      return;
    }
    if (upper.contains('UNTIL=')) {
      final RegExpMatch? match = RegExp(r'UNTIL=([0-9TZ]+)').firstMatch(upper);
      if (match != null) {
        final DateTime? until = _parseUntilDate(match.group(1)!);
        if (until != null) {
          _repeatUntilDate = until;
          _repeatOption = WeeklyRepeatOption.until;
        }
      }
    }
  }

  DateTime? _parseUntilDate(String raw) {
    try {
      if (raw.length >= 15 && raw.contains('T')) {
        final String datePart = raw.substring(0, 8);
        final int year = int.parse(datePart.substring(0, 4));
        final int month = int.parse(datePart.substring(4, 6));
        final int day = int.parse(datePart.substring(6, 8));
        return DateTime(year, month, day);
      }
      if (raw.length == 8) {
        final int year = int.parse(raw.substring(0, 4));
        final int month = int.parse(raw.substring(4, 6));
        final int day = int.parse(raw.substring(6, 8));
        return DateTime(year, month, day);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  void _handleSubmit() {
    final FormState? state = _formKey.currentState;
    if (state == null || !state.validate()) {
      return;
    }
    if (!_end.isAfter(_start)) {
      AppSnackBar.show(
        context,
        message: '종료 시간은 시작 시간보다 늦어야 합니다.',
        type: AppSnackBarType.error,
      );
      return;
    }
    final LectureOriginWriteInput payload = LectureOriginWriteInput(
      title: _titleController.text.trim(),
      type: _selectedType,
      classroomId: widget.classroomId,
      start: _start,
      end: _end,
      departmentId: _normalizeOptional(_departmentController.text),
      instructorId: _normalizeOptional(_instructorController.text),
      colorHex: _colorHexForSubmission(),
      recurrenceRule: _buildRecurrenceRule(),
      notes: _normalizeOptional(_memoController.text),
    );
    if (widget.mode == ClassroomTimetableModalMode.create) {
      widget.onCreateSubmit?.call(payload);
    } else {
      final String? lectureId = widget.initialLecture?.id;
      if (lectureId == null) {
        AppSnackBar.show(
          context,
          message: '선택된 일정 정보가 없습니다.',
          type: AppSnackBarType.error,
        );
        return;
      }
      widget.onUpdateSubmit?.call(
        LectureOriginUpdateInput(
          lectureId: lectureId,
          payload: payload,
          expectedVersion: widget.initialLecture?.version,
        ),
      );
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  String? _normalizeOptional(String value) {
    final String trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

}

class _ModalContextSummary extends StatelessWidget {
  const _ModalContextSummary({
    required this.classroomName,
    required this.mode,
  });

  final String classroomName;
  final ClassroomTimetableModalMode mode;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          classroomName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          mode == ClassroomTimetableModalMode.create
              ? '현재 강의실에 새 일정을 등록합니다.'
              : '선택한 일정을 수정합니다.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: '강의명',
        hintText: '예) 스마트 보안 실습',
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return '강의명을 입력하세요.';
        }
        return null;
      },
    );
  }
}

class _TypeField extends StatelessWidget {
  const _TypeField({
    required this.value,
    required this.onChanged,
  });

  final LectureType value;
  final ValueChanged<LectureType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<LectureType>(
      key: ValueKey<LectureType>(value),
      initialValue: value,
      decoration: const InputDecoration(labelText: '강의 유형'),
      items: LectureType.values
          .map(
            (LectureType type) => DropdownMenuItem<LectureType>(
              value: type,
              child: Text(type.displayName),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _DepartmentField extends StatelessWidget {
  const _DepartmentField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: '학과'),
    );
  }
}

class _InstructorField extends StatelessWidget {
  const _InstructorField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: '강의자'),
    );
  }
}

class _DateTimeFields extends StatelessWidget {
  const _DateTimeFields({
    required this.start,
    required this.end,
    required this.onChanged,
  });

  final DateTime start;
  final DateTime end;
  final void Function(DateTime, DateTime) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _DateField(
            label: '시작',
            value: start,
            onPicked: (DateTime newValue) {
              onChanged(newValue, end.isAfter(newValue) ? end : newValue);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DateField(
            label: '종료',
            value: end,
            onPicked: (DateTime newValue) {
              final DateTime normalized =
                  newValue.isAfter(start) ? newValue : start.add(const Duration(hours: 1));
              onChanged(start, normalized);
            },
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onPicked,
  });

  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onPicked;

  @override
  Widget build(BuildContext context) {
    final String formatted =
        '${value.year}-${value.month}-${value.day} ${value.hour}:${value.minute.toString().padLeft(2, '0')}';
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_month),
      ),
      controller: TextEditingController(text: formatted),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (pickedDate == null) {
          return;
        }
        if (!context.mounted) {
          return;
        }
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(value),
        );
        if (pickedTime == null) {
          return;
        }
        if (!context.mounted) {
          return;
        }
        final DateTime result = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onPicked(result);
      },
    );
  }
}

class _ColorPickerField extends StatelessWidget {
  const _ColorPickerField({
    required this.selected,
    required this.palette,
    required this.disabled,
    required this.onChanged,
  });

  final Color selected;
  final List<Color> palette;
  final bool disabled;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    if (disabled) {
      return InputDecorator(
        decoration: const InputDecoration(labelText: '강의 색상'),
        child: Text(
          '이 유형은 고정 색상을 사용합니다.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }
    return InputDecorator(
      decoration: const InputDecoration(labelText: '강의 색상'),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 8,
        runSpacing: 8,
        children: palette.map((Color color) {
          final bool isSelected = color == selected;
          return GestureDetector(
            onTap: () => onChanged(color),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MemoField extends StatelessWidget {
  const _MemoField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: '메모',
        hintText: '추가 정보를 입력하세요.',
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.value,
    required this.onChanged,
    this.child,
  });

  final String label;
  final bool value;
  final VoidCallback onChanged;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: value,
          onChanged: (_) => onChanged(),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(label),
        ),
        if (value && child != null) child!,
      ],
    );
  }
}
