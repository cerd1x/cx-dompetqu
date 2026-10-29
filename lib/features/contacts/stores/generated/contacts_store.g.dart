// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../contacts_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContactsStore)
final contactsStoreProvider = ContactsStoreProvider._();

final class ContactsStoreProvider
    extends $NotifierProvider<ContactsStore, ContactsState> {
  ContactsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsStoreHash();

  @$internal
  @override
  ContactsStore create() => ContactsStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactsState>(value),
    );
  }
}

String _$contactsStoreHash() => r'76db4b9c222c1a066f08c8779478e9df09201cdd';

abstract class _$ContactsStore extends $Notifier<ContactsState> {
  ContactsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ContactsState, ContactsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ContactsState, ContactsState>,
              ContactsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
