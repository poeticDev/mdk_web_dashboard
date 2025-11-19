import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/core/auth/application/login_controller.dart';
import 'package:web_dashboard/core/auth/domain/state/login_form_state.dart';

const double _cardMaxWidth = 420;
const double _cardMinWidth = 320;
const double _cardWidthRatio = 0.9;
const double _cardPadding = 24;
const double _sectionSpacing = 24;
const double _fieldSpacing = 12;
const double _buttonHeight = 48;
const double _logoSize = 64;
const String _serviceName = 'MDK 관제 대시보드';
const String _serviceTagline = '보안을 위해 계정 정보를 입력하세요.';
const String _loginButtonLabel = '로그인';
const BorderRadius _cardRadius = BorderRadius.all(Radius.circular(16));
const EdgeInsets _cardPaddingInsets = EdgeInsets.all(_cardPadding);
const LinearGradient _backgroundGradient = LinearGradient(
  colors: <Color>[Color(0xFF0F2027), Color(0xFF2C5364)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

enum LoginFeedbackType { neutral, success, error }

class LoginViewData {
  const LoginViewData({
    required this.isSubmitting,
    required this.feedbackMessage,
    required this.feedbackType,
    this.versionLabel = 'v0.1.0',
  });

  factory LoginViewData.fromState(LoginFormState state) => LoginViewData(
    isSubmitting: state.isSubmitting,
    feedbackMessage: state.errorMessage,
    feedbackType: state.errorMessage == null
        ? LoginFeedbackType.neutral
        : LoginFeedbackType.error,
  );

  final bool isSubmitting;
  final String? feedbackMessage;
  final LoginFeedbackType feedbackType;
  final String versionLabel;

  bool get hasFeedback =>
      feedbackMessage != null && feedbackMessage!.isNotEmpty;
}

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginFormState formState = ref.watch(loginControllerProvider);
    final LoginViewData data = LoginViewData.fromState(formState);
    final LoginController controller = ref.read(
      loginControllerProvider.notifier,
    );
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: _backgroundGradient),
        child: SafeArea(
          child: _LoginBody(
            data: data,
            onUsernameChanged: controller.updateUsername,
            onPasswordChanged: controller.updatePassword,
            onSubmit: controller.executeLogin,
          ),
        ),
      ),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody({
    required this.data,
    this.onUsernameChanged,
    this.onPasswordChanged,
    this.onSubmit,
  });

  final LoginViewData data;
  final ValueChanged<String>? onUsernameChanged;
  final ValueChanged<String>? onPasswordChanged;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double cardWidth = _resolveCardWidth(constraints.maxWidth);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const _LoginHeader(),
            Expanded(
              child: Center(
                child: _LoginCard(
                  width: cardWidth,
                  data: data,
                  onUsernameChanged: onUsernameChanged,
                  onPasswordChanged: onPasswordChanged,
                  onSubmit: onSubmit,
                ),
              ),
            ),
            _LoginFooter(versionLabel: data.versionLabel),
          ],
        );
      },
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(
        top: _sectionSpacing,
        bottom: _fieldSpacing,
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: _logoSize,
            height: _logoSize,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(_logoSize / 4),
            ),
            child: const Icon(
              Icons.security_outlined,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _serviceName,
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _serviceTagline,
            style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.width,
    required this.data,
    this.onUsernameChanged,
    this.onPasswordChanged,
    this.onSubmit,
  });

  final double width;
  final LoginViewData data;
  final ValueChanged<String>? onUsernameChanged;
  final ValueChanged<String>? onPasswordChanged;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: width),
      child: Card(
        elevation: 12,
        shape: const RoundedRectangleBorder(borderRadius: _cardRadius),
        child: Padding(
          padding: _cardPaddingInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildFormChildren(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return <Widget>[
      const _LoginCardTitle(),
      const SizedBox(height: _sectionSpacing),
      _LoginTextField(
        label: '아이디',
        icon: Icons.person_outline,
        obscureText: false,
        enabled: !data.isSubmitting,
        keyboardType: TextInputType.emailAddress,
        onChanged: onUsernameChanged,
      ),
      const SizedBox(height: _fieldSpacing),
      _LoginTextField(
        label: '비밀번호',
        icon: Icons.lock_outline,
        obscureText: true,
        enabled: !data.isSubmitting,
        onChanged: onPasswordChanged,
      ),
      const SizedBox(height: _sectionSpacing),
      _LoginButton(isSubmitting: data.isSubmitting, onPressed: onSubmit),
      const SizedBox(height: _fieldSpacing),
      _LoginFeedbackBanner(data: data),
    ];
  }
}

class _LoginCardTitle extends StatelessWidget {
  const _LoginCardTitle();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '로그인',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text('사내 계정으로 인증한 후 관제 대시보드에 접근하세요.', style: textTheme.bodyMedium),
      ],
    );
  }
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.label,
    required this.icon,
    required this.obscureText,
    required this.enabled,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final IconData icon;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.isSubmitting, this.onPressed});

  final bool isSubmitting;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: _buttonHeight,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : onPressed,
        child: isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(_loginButtonLabel),
      ),
    );
  }
}

class _LoginFeedbackBanner extends StatelessWidget {
  const _LoginFeedbackBanner({required this.data});

  final LoginViewData data;

  @override
  Widget build(BuildContext context) {
    if (!data.hasFeedback) {
      return const SizedBox.shrink();
    }
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Color backgroundColor = _feedbackBackgroundColor(
      data.feedbackType,
      colors,
    );
    final Color foregroundColor = _feedbackForegroundColor(
      data.feedbackType,
      colors,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Icon(_feedbackIcon(data.feedbackType), color: foregroundColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              data.feedbackMessage ?? '',
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginFooter extends StatelessWidget {
  const _LoginFooter({required this.versionLabel});

  final String versionLabel;

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: Colors.white70);
    return Padding(
      padding: const EdgeInsets.only(bottom: _sectionSpacing),
      child: Column(
        children: <Widget>[
          Text('버전 $versionLabel', style: textStyle),
          const SizedBox(height: 4),
          Text('© 2025 MDK. All rights reserved.', style: textStyle),
        ],
      ),
    );
  }
}

double _resolveCardWidth(double viewportWidth) {
  if (viewportWidth >= _cardMaxWidth) {
    return _cardMaxWidth;
  }
  final double scaledWidth = viewportWidth * _cardWidthRatio;
  if (scaledWidth <= _cardMinWidth) {
    return _cardMinWidth;
  }
  return scaledWidth;
}

Color _feedbackBackgroundColor(LoginFeedbackType type, ColorScheme scheme) {
  if (type == LoginFeedbackType.success) {
    return scheme.secondaryContainer;
  }
  if (type == LoginFeedbackType.error) {
    return scheme.errorContainer;
  }
  return scheme.surfaceContainerHighest;
}

Color _feedbackForegroundColor(LoginFeedbackType type, ColorScheme scheme) {
  if (type == LoginFeedbackType.success) {
    return scheme.onSecondaryContainer;
  }
  if (type == LoginFeedbackType.error) {
    return scheme.onErrorContainer;
  }
  return scheme.onSurface;
}

IconData _feedbackIcon(LoginFeedbackType type) {
  if (type == LoginFeedbackType.success) {
    return Icons.check_circle_outline;
  }
  if (type == LoginFeedbackType.error) {
    return Icons.error_outline;
  }
  return Icons.info_outline;
}
