import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_dashboard/common/widgets/app_dialog.dart';
import 'package:web_dashboard/common/widgets/app_snack_bar.dart';
import 'package:web_dashboard/core/timetable/domain/entities/lecture_type.dart';
import 'package:web_dashboard/core/timetable/domain/repositories/lecture_repository.dart';
import 'package:web_dashboard/core/timetable/presentation/viewmodels/lecture_view_model.dart';

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
  final ValueChanged<LectureWriteInput>? onCreateSubmit;
  final ValueChanged<UpdateLectureInput>? onUpdateSubmit;

  static Future<void> show({
    required BuildContext context,
    required ClassroomTimetableModalMode mode,
    required String classroomId,
    required String classroomName,
    required DateTime initialStart,
    LectureViewModel? initialLecture,
    ValueChanged<LectureWriteInput>? onCreateSubmit,
    ValueChanged<UpdateLectureInput>? onUpdateSubmit,
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
  late TextEditingController _colorController;
  late TextEditingController _rruleController;
  late TextEditingController _memoController;
  late LectureType _selectedType;
  late DateTime _start;
  late DateTime _end;

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
    _colorController = TextEditingController(
      text: lecture == null ? '' : _formatColorHex(lecture.color),
    );
    _rruleController =
        TextEditingController(text: lecture?.recurrenceRule ?? '');
    _memoController = TextEditingController(text: lecture?.notes ?? '');
    _selectedType = lecture != null ? lecture.type : LectureType.lecture;
    _start = lecture?.start ?? widget.initialStart;
    _end = lecture?.end ?? widget.initialStart.add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _departmentController.dispose();
    _instructorController.dispose();
    _colorController.dispose();
    _rruleController.dispose();
    _memoController.dispose();
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
                _ColorField(controller: _colorController),
                const SizedBox(height: 12),
                _RRuleField(controller: _rruleController),
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

  String _formatColorHex(Color color) {
    final int rChannel = (color.r * 255.0).round() & 0xff;
    final int gChannel = (color.g * 255.0).round() & 0xff;
    final int bChannel = (color.b * 255.0).round() & 0xff;
    final String r = rChannel.toRadixString(16).padLeft(2, '0');
    final String g = gChannel.toRadixString(16).padLeft(2, '0');
    final String b = bChannel.toRadixString(16).padLeft(2, '0');
    return (r + g + b).toUpperCase();
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
    final LectureWriteInput payload = LectureWriteInput(
      title: _titleController.text.trim(),
      type: _selectedType,
      classroomId: widget.classroomId,
      start: _start,
      end: _end,
      departmentId: _normalizeOptional(_departmentController.text),
      instructorId: _normalizeOptional(_instructorController.text),
      colorHex: _normalizeColorHex(_colorController.text),
      recurrenceRule: _normalizeOptional(_rruleController.text),
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
        UpdateLectureInput(
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

  String? _normalizeColorHex(String value) {
    final String trimmed = value.trim().replaceFirst('#', '');
    if (trimmed.isEmpty) {
      return null;
    }
    return '#${trimmed.toUpperCase()}';
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
              child: Text(type.name),
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

class _ColorField extends StatelessWidget {
  const _ColorField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp('[0-9a-fA-F]')),
      ],
      decoration: const InputDecoration(
        labelText: '색상 코드',
        prefixText: '#',
        hintText: '예) FF5A5F',
      ),
    );
  }
}

class _RRuleField extends StatelessWidget {
  const _RRuleField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: '반복 규칙 (RFC5545)',
        hintText: 'RRULE:FREQ=WEEKLY;BYDAY=MO,WE',
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
