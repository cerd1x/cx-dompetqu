// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_remote_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contactsRemoteSource)
final contactsRemoteSourceProvider = ContactsRemoteSourceProvider._();

final class ContactsRemoteSourceProvider
    extends
        $FunctionalProvider<
          ContactsRemoteSource,
          ContactsRemoteSource,
          ContactsRemoteSource
        >
    with $Provider<ContactsRemoteSource> {
  ContactsRemoteSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsRemoteSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsRemoteSourceHash();

  @$internal
  @override
  $ProviderElement<ContactsRemoteSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContactsRemoteSource create(Ref ref) {
    return contactsRemoteSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactsRemoteSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactsRemoteSource>(value),
    );
  }
}

String _$contactsRemoteSourceHash() =>
    r'1237c83a7a42d8c2ac71ddb331bf6458106563eb';
