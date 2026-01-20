// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landing_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(landingFoundationClassroomsReadRepository)
const landingFoundationClassroomsReadRepositoryProvider =
    LandingFoundationClassroomsReadRepositoryProvider._();

final class LandingFoundationClassroomsReadRepositoryProvider
    extends
        $FunctionalProvider<
          FoundationClassroomsReadRepository,
          FoundationClassroomsReadRepository,
          FoundationClassroomsReadRepository
        >
    with $Provider<FoundationClassroomsReadRepository> {
  const LandingFoundationClassroomsReadRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'landingFoundationClassroomsReadRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$landingFoundationClassroomsReadRepositoryHash();

  @$internal
  @override
  $ProviderElement<FoundationClassroomsReadRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FoundationClassroomsReadRepository create(Ref ref) {
    return landingFoundationClassroomsReadRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FoundationClassroomsReadRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FoundationClassroomsReadRepository>(
        value,
      ),
    );
  }
}

String _$landingFoundationClassroomsReadRepositoryHash() =>
    r'f424f4faf515cb7e1b3613eb343fe131ff919f6a';
