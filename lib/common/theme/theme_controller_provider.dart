import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mdk_app_theme/mdk_app_theme.dart';

/// Riverpod provider that exposes the shared ThemeController from
/// `mdk_app_theme`.
final Provider<ThemeController> themeControllerProvider =
    Provider<ThemeController>((Ref ref) {
      return ThemeController();
    });
