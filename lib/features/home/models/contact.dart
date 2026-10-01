import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

/// Padanan `Contact` di schema GraphQL (`services/domain/contacts`).
@freezed
abstract class Contact with _$Contact {
  const factory Contact({
    @JsonKey(fromJson: _toId) required String id,
    required String name,
    String? email,
    String? phone,
    @Default([]) List<String> phones,
    String? group,
    String? avatar,
    @JsonKey(fromJson: _date) DateTime? createdAt,
    @JsonKey(fromJson: _date) DateTime? updatedAt,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}

String _toId(dynamic v) => v.toString();

DateTime? _date(dynamic v) => v is String ? DateTime.tryParse(v) : null;
