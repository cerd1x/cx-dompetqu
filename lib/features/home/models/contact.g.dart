// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Contact _$ContactFromJson(Map<String, dynamic> json) => _Contact(
  id: _toId(json['id']),
  name: json['name'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  phones:
      (json['phones'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  group: json['group'] as String?,
  avatar: json['avatar'] as String?,
  createdAt: _date(json['createdAt']),
  updatedAt: _date(json['updatedAt']),
);

Map<String, dynamic> _$ContactToJson(_Contact instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'phones': instance.phones,
  'group': instance.group,
  'avatar': instance.avatar,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
