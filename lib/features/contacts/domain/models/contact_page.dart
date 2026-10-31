import 'package:freezed_annotation/freezed_annotation.dart';

import 'contact.dart';

part 'generated/contact_page.freezed.dart';

/// Satu halaman kontak pada domain — padanan data model
/// `features/contacts/data/models/contact_page.dart` (tanpa JSON: konversi
/// ada di mapper/repository, bukan di domain).
@freezed
abstract class ContactPage with _$ContactPage {
  const factory ContactPage({
    required List<Contact> items,
    required bool hasNextPage,
    required String? nextCursor,
  }) = _ContactPage;

  const ContactPage._();
}
