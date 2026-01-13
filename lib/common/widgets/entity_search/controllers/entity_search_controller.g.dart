// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_search_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 학과/유저 검색 요청을 수행하고 Riverpod 상태를 노출하는 컨트롤러.

@ProviderFor(EntitySearchController)
const entitySearchControllerProvider = EntitySearchControllerFamily._();

/// 학과/유저 검색 요청을 수행하고 Riverpod 상태를 노출하는 컨트롤러.
final class EntitySearchControllerProvider
    extends $AsyncNotifierProvider<EntitySearchController, EntitySearchState> {
  /// 학과/유저 검색 요청을 수행하고 Riverpod 상태를 노출하는 컨트롤러.
  const EntitySearchControllerProvider._({
    required EntitySearchControllerFamily super.from,
    required EntitySearchArgs super.argument,
  }) : super(
         retry: null,
         name: r'entitySearchControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$entitySearchControllerHash();

  @override
  String toString() {
    return r'entitySearchControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EntitySearchController create() => EntitySearchController();

  @override
  bool operator ==(Object other) {
    return other is EntitySearchControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$entitySearchControllerHash() =>
    r'615b3ccfdfd83bb973161659652f2463e707fec3';

/// 학과/유저 검색 요청을 수행하고 Riverpod 상태를 노출하는 컨트롤러.

final class EntitySearchControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          EntitySearchController,
          AsyncValue<EntitySearchState>,
          EntitySearchState,
          FutureOr<EntitySearchState>,
          EntitySearchArgs
        > {
  const EntitySearchControllerFamily._()
    : super(
        retry: null,
        name: r'entitySearchControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 학과/유저 검색 요청을 수행하고 Riverpod 상태를 노출하는 컨트롤러.

  EntitySearchControllerProvider call(EntitySearchArgs args) =>
      EntitySearchControllerProvider._(argument: args, from: this);

  @override
  String toString() => r'entitySearchControllerProvider';
}

/// 학과/유저 검색 요청을 수행하고 Riverpod 상태를 노출하는 컨트롤러.

abstract class _$EntitySearchController
    extends $AsyncNotifier<EntitySearchState> {
  late final _$args = ref.$arg as EntitySearchArgs;
  EntitySearchArgs get args => _$args;

  FutureOr<EntitySearchState> build(EntitySearchArgs args);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<EntitySearchState>, EntitySearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EntitySearchState>, EntitySearchState>,
              AsyncValue<EntitySearchState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
