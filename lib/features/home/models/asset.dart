import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset.freezed.dart';
part 'asset.g.dart';

/// Padanan `Asset` di schema GraphQL (`services/domain/assets`).
///
/// `balance` bertipe string "ISO_CODE VALUE", mis. "IDR 20000".
@freezed
abstract class Asset with _$Asset {
  const factory Asset({
    @JsonKey(fromJson: _toId) required String id,
    required String name,
    @Default('ewallet') String type,
    @Default('IDR 0') String balance,
  }) = _Asset;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}

String _toId(dynamic v) => v.toString();
