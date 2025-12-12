import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_dashboard/common/app_bar/common_app_bar_options.dart';
import 'package:web_dashboard/common/responsive/responsive_layout.dart';
import 'package:web_dashboard/common/widgets/app_theme_toggle.dart';
import 'package:web_dashboard/core/auth/application/auth_controller.dart';
import 'package:web_dashboard/core/auth/domain/entities/auth_user.dart';
import 'package:web_dashboard/routes/page_meta.dart';

const double _kAppBarHeight = 72;
const double _kHorizontalPadding = 24;
const double _kActionSpacing = 16;

class CommonAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key, this.meta, this.options, this.onBackPressed});

  final AppPageMeta? meta;
  final CommonAppBarOptions? options;
  final VoidCallback? onBackPressed;

  @override
  Size get preferredSize => const Size.fromHeight(_kAppBarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppPageMeta resolvedMeta = meta ?? resolvePageMeta(context: context);
    final bool isMobile = context.isMobileLayout;
    final bool showBackButton =
        options?.showBackButton ?? resolvedMeta.showBackButton;
    final bool showThemeToggle =
        options?.showThemeToggle ?? resolvedMeta.showThemeToggle;
    final bool showUserBanner =
        options?.showUserBanner ?? resolvedMeta.showUserBanner;
    final String title = options?.titleOverride ?? resolvedMeta.title;
    final List<Widget> extraTrailing = options?.trailing ?? const <Widget>[];

    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final Color background =
        theme.appBarTheme.backgroundColor ?? scheme.surface;

    return Material(
      color: background,
      elevation: 2,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: _kAppBarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _kHorizontalPadding,
            ),
            child: Row(
              children: <Widget>[
                if (showBackButton) _BackButton(onPressed: onBackPressed),
                const _LogoSection(),
                const SizedBox(width: 12),
                _PageTitle(title: title),
                const Spacer(),
                ...extraTrailing,
                if (extraTrailing.isNotEmpty &&
                    (showThemeToggle || showUserBanner))
                  const SizedBox(width: _kActionSpacing),
                if (showThemeToggle) const _ThemeToggleButton(),
                if (showThemeToggle && showUserBanner)
                  const SizedBox(width: _kActionSpacing),
                if (showUserBanner) _UserBanner(compact: isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      tooltip: '뒤로가기',
    );
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          clipBehavior: Clip.antiAlias,
          height: 44,
          width: 44,
          child: Image.asset('assets/img/logo.png', fit: BoxFit.cover),
        ),
      ],
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context).textTheme.titleLarge;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    return const AppThemeToggle();
  }
}

class _UserBanner extends ConsumerWidget {
  const _UserBanner({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final AuthUser? user = authState.currentUser;
    final String displayName = user?.username ?? '게스트 사용자';
    final String roleLabel = _roleDisplay(user);
    final String initials = _initials(displayName);

    return PopupMenuButton<_UserMenuAction>(
      offset: const Offset(0, 40),
      onSelected: (action) {
        // TODO: 라우팅/로그아웃 구현 시 아래 분기에서 처리하세요.
        if (action == _UserMenuAction.logout) {
          // trigger logout via AuthController
          ref.read(authControllerProvider.notifier).logout();
        }
      },
      itemBuilder: (BuildContext context) =>
          const <PopupMenuEntry<_UserMenuAction>>[
            PopupMenuItem<_UserMenuAction>(
              value: _UserMenuAction.profile,
              child: Text('내 정보'),
            ),
            PopupMenuItem<_UserMenuAction>(
              value: _UserMenuAction.logout,
              child: Text('로그아웃'),
            ),
          ],
      child: compact
          ? CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.person_outline),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                    child: Text(
                      initials,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        displayName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        roleLabel,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),
    );
  }

  String _roleDisplay(AuthUser? user) {
    if (user == null || user.roles.isEmpty) {
      return '게스트';
    }
    final UserRole primary = user.roles.first;
    switch (primary) {
      case UserRole.admin:
        return '관리자';
      case UserRole.operator:
        return '운영자';
      case UserRole.limitedOperator:
        return '제한 운영자';
      case UserRole.viewer:
        return '뷰어';
      case UserRole.unknown:
        return '게스트';
    }
  }

  String _initials(String name) {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    final List<String> parts = trimmed.split(' ');
    if (parts.length == 1) {
      return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

enum _UserMenuAction { profile, logout }
