import 'package:flutter/material.dart';

/// 공통 다이얼로그 버튼 정의.
class AppDialogAction {
  const AppDialogAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDestructive;
}

/// 앱 전역 다이얼로그 레이아웃.
class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    required this.content,
    required this.actions,
    super.key,
  });

  final Widget title;
  final Widget content;
  final List<AppDialogAction> actions;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    required List<AppDialogAction> actions,
  }) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AppDialog(
          title: Text(title),
          content: content,
          actions: actions,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      content: content,
      title: title,
      actions: actions.map((AppDialogAction action) {
        return _buildAction(context, action);
      }).toList(),
    );
  }

  Widget _buildAction(BuildContext context, AppDialogAction action) {
    if (action.isPrimary) {
      return FilledButton(
        onPressed: action.onPressed,
        child: Text(action.label),
      );
    }
    if (action.isDestructive) {
      return TextButton(
        onPressed: action.onPressed,
        child: Text(
          action.label,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }
    return TextButton(
      onPressed: action.onPressed,
      child: Text(action.label),
    );
  }
}
