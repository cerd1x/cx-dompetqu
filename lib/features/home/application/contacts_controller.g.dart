// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContactsController)
final contactsControllerProvider = ContactsControllerProvider._();

final class ContactsControllerProvider
    extends $NotifierProvider<ContactsController, ContactsState> {
  ContactsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsControllerHash();

  @$internal
  @override
  ContactsController create() => ContactsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactsState>(value),
    );
  }
}

String _$contactsControllerHash() =>
    r'4b967df889b49f9dd65935ece4e7d5707f86d63d';

abstract class _$ContactsController extends $Notifier<ContactsState> {
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
