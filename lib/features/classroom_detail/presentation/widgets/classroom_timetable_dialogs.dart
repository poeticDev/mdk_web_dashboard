// 시간표 상세 다이얼로그를 제공한다.
import 'package:flutter/material.dart';
import 'package:web_dashboard/common/widgets/app_dialog.dart';
import 'package:web_dashboard/features/classroom_detail/viewmodels/lecture_view_model.dart';

typedef TimetableRangeFormatter = String Function(DateTime start, DateTime end);

/// 시간표에서 사용하는 모달 묶음.
class ClassroomTimetableDialogs {
  const ClassroomTimetableDialogs._();

  static Future<void> showCreateDialog({
    required BuildContext context,
    required DateTime start,
    required TimetableRangeFormatter formatRange,
    required VoidCallback onSubmitPending,
  }) async {
    final TextEditingController titleController = _buildTitleController(start);
    final TextEditingController memoController = TextEditingController();
    await _presentCreateDialog(
      context: context,
      start: start,
      formatRange: formatRange,
      titleController: titleController,
      memoController: memoController,
      onSubmitPending: onSubmitPending,
    );
    titleController.dispose();
    memoController.dispose();
  }

  static Future<void> showDetailDialog({
    required BuildContext context,
    required LectureViewModel lecture,
    required TimetableRangeFormatter formatRange,
    required VoidCallback onSuspendPending,
    required VoidCallback onEditPending,
  }) {
    return _presentDetailDialog(
      context: context,
      lecture: lecture,
      formatRange: formatRange,
      onSuspendPending: onSuspendPending,
      onEditPending: onEditPending,
    );
  }

  static TextEditingController _buildTitleController(DateTime start) {
    return TextEditingController(text: '${start.month}월 ${start.day}일 일정');
  }

  static Future<void> _presentCreateDialog({
    required BuildContext context,
    required DateTime start,
    required TimetableRangeFormatter formatRange,
    required TextEditingController titleController,
    required TextEditingController memoController,
    required VoidCallback onSubmitPending,
  }) {
    final DateTime end = start.add(const Duration(hours: 1));
    final Widget content = _LectureCreateContent(
      rangeLabel: formatRange(start, end),
      titleController: titleController,
      memoController: memoController,
    );
    return AppDialog.show<void>(
      context: context,
      title: '새 일정 등록 (더미)',
      content: content,
      actions: _buildCreateActions(context, onSubmitPending),
    );
  }

  static Future<void> _presentDetailDialog({
    required BuildContext context,
    required LectureViewModel lecture,
    required TimetableRangeFormatter formatRange,
    required VoidCallback onSuspendPending,
    required VoidCallback onEditPending,
  }) {
    final Widget content = _LectureDetailContent(
      lecture: lecture,
      rangeLabel: formatRange(lecture.start, lecture.end),
    );

    final String suspendingLabel = lecture.statusLabel == '휴강'
        ? '재개'
        : '휴강 처리';
    
    return AppDialog.show<void>(
      context: context,
      title: '일정 상세',
      content: content,
      actions: _buildDetailActions(
        context: context,
        suspendingLabel: suspendingLabel,
        onSuspendPending: onSuspendPending,
        onEditPending: onEditPending,
      ),
    );
  }

  static List<AppDialogAction> _buildCreateActions(
    BuildContext context,
    VoidCallback onSubmitPending,
  ) {
    return <AppDialogAction>[
      AppDialogAction(
        label: '취소',
        onPressed: () => Navigator.of(context).pop(),
      ),
      AppDialogAction(
        label: '등록',
        isPrimary: true,
        onPressed: () {
          Navigator.of(context).pop();
          onSubmitPending();
        },
      ),
    ];
  }

  static List<AppDialogAction> _buildDetailActions({
    required BuildContext context,
    required String suspendingLabel,
    required VoidCallback onSuspendPending,
    required VoidCallback onEditPending,
  }) {
    return <AppDialogAction>[
      AppDialogAction(
        label: '닫기',
        onPressed: () => Navigator.of(context).pop(),
      ),
      AppDialogAction(
        label: suspendingLabel,
        onPressed: () {
          Navigator.of(context).pop();
          onSuspendPending();
        },
      ),
      AppDialogAction(
        label: '수정',
        isPrimary: true,
        onPressed: () {
          Navigator.of(context).pop();
          onEditPending();
        },
      ),
    ];
  }
}

class _LectureCreateContent extends StatelessWidget {
  const _LectureCreateContent({
    required this.rangeLabel,
    required this.titleController,
    required this.memoController,
  });

  final String rangeLabel;
  final TextEditingController titleController;
  final TextEditingController memoController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('시간: $rangeLabel'),
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
    );
  }
}

class _LectureDetailContent extends StatelessWidget {
  const _LectureDetailContent({
    required this.lecture,
    required this.rangeLabel,
  });

  final LectureViewModel lecture;
  final String rangeLabel;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('강의명: ${lecture.title}'),
          Text('강의실: ${lecture.classroomName}'),
          Text('시간: $rangeLabel'),
          if (lecture.instructorName != null)
            Text('강사: ${lecture.instructorName}'),
          const SizedBox(height: 8),
          Text('상태: ${lecture.statusLabel}'),
        ],
      ),
    );
  }
}
