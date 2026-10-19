import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/asset_mutation.freezed.dart';

/// Satu mutasi saldo aset — padanan data model
/// `features/assets/data/models/asset_mutation.dart` (tanpa JSON: konversi
/// ada di mapper/repository, bukan di domain).
@freezed
abstract class AssetMutation with _$AssetMutation {
  const factory AssetMutation({
    required String id,
    required String type,
    required String amount,
    required String currency,
    required String balanceBefore,
    required String balanceAfter,
    required String? description,
    required DateTime? createdAt,
  }) = _AssetMutation;

  const AssetMutation._();
}
