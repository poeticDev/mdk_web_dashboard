import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_dashboard/core/classroom_detail/application/sensors/classroom_sensor_providers.dart';

void main() {
  test('classroomEnvironmentMetricsProvider exposes mock metrics', () async {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    final List<EnvironmentMetricViewModel> metrics = await _waitForMetrics(
      container,
      'room-1',
    );

    expect(metrics, isNotEmpty);
    expect(metrics.first.label, '온도');
  });
}

Future<List<EnvironmentMetricViewModel>> _waitForMetrics(
  ProviderContainer container,
  String classroomId,
) {
  final Completer<List<EnvironmentMetricViewModel>> completer =
      Completer<List<EnvironmentMetricViewModel>>();
  late ProviderSubscription<AsyncValue<List<EnvironmentMetricViewModel>>> sub;
  sub = container.listen<AsyncValue<List<EnvironmentMetricViewModel>>>(
    classroomEnvironmentMetricsProvider(classroomId),
    (AsyncValue<List<EnvironmentMetricViewModel>>? previous,
        AsyncValue<List<EnvironmentMetricViewModel>> next) {
      if (!completer.isCompleted && next.hasValue) {
        completer.complete(next.value!);
        sub.close();
      }
    },
    fireImmediately: true,
  );
  return completer.future.timeout(const Duration(seconds: 1));
}
