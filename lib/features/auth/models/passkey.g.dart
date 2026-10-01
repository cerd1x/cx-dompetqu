// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passkey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PasskeyOptions _$PasskeyOptionsFromJson(Map<String, dynamic> json) =>
    _PasskeyOptions(
      options: json['options'] as String,
      challenge: json['challenge'] as String,
    );

Map<String, dynamic> _$PasskeyOptionsToJson(_PasskeyOptions instance) =>
    <String, dynamic>{
      'options': instance.options,
      'challenge': instance.challenge,
    };

_PasskeyCredential _$PasskeyCredentialFromJson(Map<String, dynamic> json) =>
    _PasskeyCredential(
      id: json['id'] as String,
      deviceName: json['deviceName'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PasskeyCredentialToJson(_PasskeyCredential instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceName': instance.deviceName,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
