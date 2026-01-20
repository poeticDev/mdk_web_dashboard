// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landing_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LandingController)
const landingControllerProvider = LandingControllerProvider._();

final class LandingControllerProvider
    extends $NotifierProvider<LandingController, LandingState> {
  const LandingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'landingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$landingControllerHash();

  @$internal
  @override
  LandingController create() => LandingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LandingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LandingState>(value),
    );
  }
}

String _$landingControllerHash() => r'125e92d7bfcf38203def82531947bfce80995c6b';

abstract class _$LandingController extends $Notifier<LandingState> {
  LandingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LandingState, LandingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LandingState, LandingState>,
              LandingState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
