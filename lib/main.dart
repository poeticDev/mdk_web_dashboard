import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:web_dashboard/core/auth/application/auth_controller.dart';
import 'package:web_dashboard/di/service_locator.dart';
import 'package:web_dashboard/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

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
    return MaterialApp.router(
      title: 'MDK Web Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Pretendard Variable',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff334479)),
      ),
      routerConfig: router,
    );
  }
}
