// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardSseMapper)
const dashboardSseMapperProvider = DashboardSseMapperProvider._();

final class DashboardSseMapperProvider
    extends
        $FunctionalProvider<
          DashboardSseMapper,
          DashboardSseMapper,
          DashboardSseMapper
        >
    with $Provider<DashboardSseMapper> {
  const DashboardSseMapperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardSseMapperProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardSseMapperHash();

  @$internal
  @override
  $ProviderElement<DashboardSseMapper> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DashboardSseMapper create(Ref ref) {
    return dashboardSseMapper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardSseMapper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardSseMapper>(value),
    );
  }
}

String _$dashboardSseMapperHash() =>
    r'038df2acadb3be2717808633e6c85f12a577e84e';
