import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/contact.freezed.dart';

/// Satu kontak pada domain — padanan data model
/// `features/contacts/data/models/contact.dart` (tanpa JSON: konversi ada di
/// mapper/repository, bukan di domain).
@freezed
abstract class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String name,
    String? email,
    String? phone,
    @Default(<String>[]) List<String> phones,
    String? group,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Contact;

  const Contact._();
}
