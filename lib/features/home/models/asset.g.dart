// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Asset _$AssetFromJson(Map<String, dynamic> json) => _Asset(
  id: _toId(json['id']),
  name: json['name'] as String,
  type: json['type'] as String? ?? 'ewallet',
  balance: json['balance'] as String? ?? 'IDR 0',
);

Map<String, dynamic> _$AssetToJson(_Asset instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'balance': instance.balance,
};
