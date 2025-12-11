import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:mdk_app_theme/theme_utilities.dart';

import 'package:web_dashboard/core/auth/application/auth_controller.dart';
import 'package:web_dashboard/di/service_locator.dart';
import 'package:web_dashboard/routes/app_router.dart';

const List<Breakpoint> _appBreakpoints = <Breakpoint>[
  Breakpoint(start: 0, end: 599, name: MOBILE),
  Breakpoint(start: 600, end: 1023, name: TABLET),
  Breakpoint(start: 1024, end: 1439, name: DESKTOP),
  Breakpoint(start: 1440, end: double.infinity, name: '4K'),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AdaptiveThemeMode initialThemeMode =
      await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;
  await initDependencies();
  ThemeRegistry.instance.ensureDefaults();
  runApp(
    ProviderScope(
      child: MyApp(initialThemeMode: initialThemeMode),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key, required this.initialThemeMode});

  final AdaptiveThemeMode initialThemeMode;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(authControllerProvider.notifier).loadCurrentUser(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter router = ref.watch(appRouterProvider);

    return AdaptiveTheme(
      light: AppTheme.light(),
      dark: AppTheme.dark(),
      initial: widget.initialThemeMode,
      builder: (ThemeData lightTheme, ThemeData darkTheme) {
        return MaterialApp.router(
          title: 'MDK Web Dashboard',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          builder: (BuildContext context, Widget? child) =>
              ResponsiveBreakpoints.builder(
            child: child ?? const SizedBox.shrink(),
            breakpoints: _appBreakpoints,
          ),
          routerConfig: router,
        );
      },
    );
  }
}
