// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

import 'package:web_dashboard/main.dart';

void main() {
  testWidgets('Login page renders header text', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.physicalSizeTestValue = const Size(1920, 1080);
    binding.window.devicePixelRatioTestValue = 1;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });
    SharedPreferences.setMockInitialValues(<String, Object>{});
    SharedPreferencesAsyncPlatform.instance ??=
        _InMemorySharedPreferencesAsync();
  
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(initialThemeMode: AdaptiveThemeMode.light),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('MDK 관제 대시보드'), findsOneWidget);
    expect(find.text('보안을 위해 계정 정보를 입력하세요.'), findsOneWidget);
  });
}

final class _InMemorySharedPreferencesAsync extends SharedPreferencesAsyncPlatform {
  final Map<String, Object> _store = <String, Object>{};

  @override
  Future<void> setString(String key, String value, SharedPreferencesOptions options) async {
    _store[key] = value;
  }

  @override
  Future<void> setBool(String key, bool value, SharedPreferencesOptions options) async {
    _store[key] = value;
  }

  @override
  Future<void> setDouble(String key, double value, SharedPreferencesOptions options) async {
    _store[key] = value;
  }

  @override
  Future<void> setInt(String key, int value, SharedPreferencesOptions options) async {
    _store[key] = value;
  }

  @override
  Future<void> setStringList(String key, List<String> value, SharedPreferencesOptions options) async {
    _store[key] = value;
  }

  @override
  Future<String?> getString(String key, SharedPreferencesOptions options) async {
    final Object? value = _store[key];
    return value is String ? value : null;
  }

  @override
  Future<bool?> getBool(String key, SharedPreferencesOptions options) async {
    final Object? value = _store[key];
    return value is bool ? value : null;
  }

  @override
  Future<double?> getDouble(String key, SharedPreferencesOptions options) async {
    final Object? value = _store[key];
    return value is double ? value : null;
  }

  @override
  Future<int?> getInt(String key, SharedPreferencesOptions options) async {
    final Object? value = _store[key];
    return value is int ? value : null;
  }

  @override
  Future<List<String>?> getStringList(String key, SharedPreferencesOptions options) async {
    final Object? value = _store[key];
    return value is List<String> ? value : null;
  }

  @override
  Future<void> clear(ClearPreferencesParameters parameters, SharedPreferencesOptions options) async {
    final Set<String>? allowList = parameters.filter?.allowList;
    if (allowList == null) {
      _store.clear();
      return;
    }
    for (final String key in allowList) {
      _store.remove(key);
    }
  }

  @override
  Future<Map<String, Object>> getPreferences(GetPreferencesParameters parameters, SharedPreferencesOptions options) async {
    final Set<String>? allowList = parameters.filter?.allowList;
    if (allowList == null) {
      return Map<String, Object>.from(_store);
    }
    return Map<String, Object>.fromEntries(
      _store.entries.where((MapEntry<String, Object> entry) => allowList.contains(entry.key)),
    );
  }

  @override
  Future<Set<String>> getKeys(GetPreferencesParameters parameters, SharedPreferencesOptions options) async {
    final Set<String>? allowList = parameters.filter?.allowList;
    if (allowList == null) {
      return Set<String>.from(_store.keys);
    }
    return _store.keys.where(allowList.contains).toSet();
  }
}
