import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/asset.freezed.dart';

/// Satu aset (kas/ewallet/dll) — padanan data model
/// `features/assets/data/models/asset.dart` (tanpa JSON: konversi ada di
/// mapper/repository, bukan di domain).
@freezed
abstract class Asset with _$Asset {
  const factory Asset({
    required String id,
    required String name,
    @Default('ewallet') String type,
    @Default('IDR 0') String balance,
  }) = _Asset;

  const Asset._();
}
