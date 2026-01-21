// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom_now_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(classroomOccurrenceNowSseRemoteDataSource)
const classroomOccurrenceNowSseRemoteDataSourceProvider =
    ClassroomOccurrenceNowSseRemoteDataSourceProvider._();

final class ClassroomOccurrenceNowSseRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          OccurrenceNowSseRemoteDataSource,
          OccurrenceNowSseRemoteDataSource,
          OccurrenceNowSseRemoteDataSource
        >
    with $Provider<OccurrenceNowSseRemoteDataSource> {
  const ClassroomOccurrenceNowSseRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'classroomOccurrenceNowSseRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$classroomOccurrenceNowSseRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<OccurrenceNowSseRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OccurrenceNowSseRemoteDataSource create(Ref ref) {
    return classroomOccurrenceNowSseRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OccurrenceNowSseRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OccurrenceNowSseRemoteDataSource>(
        value,
      ),
    );
  }
}

String _$classroomOccurrenceNowSseRemoteDataSourceHash() =>
    r'4edcfe989abb5545680175f8a2cbacaa1a1118af';
