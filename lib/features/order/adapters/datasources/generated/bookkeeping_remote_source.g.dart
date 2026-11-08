// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../bookkeeping_remote_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookkeepingRemoteSource)
final bookkeepingRemoteSourceProvider = BookkeepingRemoteSourceProvider._();

final class BookkeepingRemoteSourceProvider
    extends
        $FunctionalProvider<
          BookkeepingRemoteSource,
          BookkeepingRemoteSource,
          BookkeepingRemoteSource
        >
    with $Provider<BookkeepingRemoteSource> {
  BookkeepingRemoteSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookkeepingRemoteSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookkeepingRemoteSourceHash();

  @$internal
  @override
  $ProviderElement<BookkeepingRemoteSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookkeepingRemoteSource create(Ref ref) {
    return bookkeepingRemoteSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookkeepingRemoteSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookkeepingRemoteSource>(value),
    );
  }
}

String _$bookkeepingRemoteSourceHash() =>
    r'2534a8dfcab457ba26c5db624afb9668f4de34c7';
