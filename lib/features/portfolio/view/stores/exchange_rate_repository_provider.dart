import 'package:cx_dompetqiu/features/portfolio/adapters/datasources/frankfurter_source.dart';
import 'package:cx_dompetqiu/features/portfolio/adapters/repositories/exchange_rate_repository_impl.dart';
import 'package:cx_dompetqiu/features/portfolio/domain/repositories/exchange_rate_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/exchange_rate_repository_provider.g.dart';

/// Provider repository yang memakai adapter Frankfurter.
///
/// Ganti adapter cukup di sini (mis. sumber lain yang berbayar/berapi-key).
@Riverpod(keepAlive: true)
ExchangeRateRepository exchangeRateRepository(Ref ref) =>
    ExchangeRateRepositoryImpl(FrankfurterExchangeRateSource());
