// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcp_server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_McpServer _$McpServerFromJson(Map<String, dynamic> json) => _McpServer(
  id: json['id'] as String,
  name: json['name'] as String,
  url: json['url'] as String,
);

Map<String, dynamic> _$McpServerToJson(_McpServer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
    };
