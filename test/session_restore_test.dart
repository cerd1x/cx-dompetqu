import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dompetqu/core/graphql/graphql_providers.dart';
import 'package:dompetqu/core/network/cookie_aware_client.dart';
import 'package:dompetqu/features/auth/application/session_controller.dart';
import 'package:dompetqu/features/auth/data/auth_remote_source.dart';
import 'package:dompetqu/features/auth/models/user.dart';
import 'package:dompetqu/features/home/data/assets_remote_source.dart';
import 'package:dompetqu/features/home/data/contacts_remote_source.dart';
import 'package:dompetqu/features/home/data/inventory_remote_source.dart';
import 'package:dompetqu/features/home/data/statistics_remote_source.dart';
import 'package:dompetqu/features/home/data/transactions_remote_source.dart';
import 'package:dompetqu/features/home/models/asset.dart';
import 'package:dompetqu/features/home/models/contact.dart';
import 'package:dompetqu/features/home/models/product.dart';
import 'package:dompetqu/features/home/models/statistics.dart';
import 'package:dompetqu/features/home/models/transaction.dart';
import 'package:dompetqu/main.dart';

GraphQLClient _dummyClient() => GraphQLClient(
      link: HttpLink('http://localhost:9999'),
      cache: GraphQLCache(store: InMemoryStore()),
    );

class FakeAuthRemoteSource extends AuthRemoteSource {
  FakeAuthRemoteSource() : super(_dummyClient());

  @override
  Future<bool> checkAuthorized() async => true;

  @override
  Future<User?> me() async => User(id: 'u1', name: 'Test', username: 'test');
}

class FakeContactsRemoteSource extends ContactsRemoteSource {
  FakeContactsRemoteSource() : super(_dummyClient());

  @override
  Future<List<Contact>> contacts() async => const [];
}

class FakeInventoryRemoteSource extends InventoryRemoteSource {
  FakeInventoryRemoteSource() : super(_dummyClient());

  @override
  Future<List<Product>> products() async => const [];
}

class FakeAssetsRemoteSource extends AssetsRemoteSource {
  FakeAssetsRemoteSource() : super(_dummyClient());

  @override
  Future<List<Asset>> assets() async => const [];
}

class FakeTransactionsRemoteSource extends TransactionsRemoteSource {
  FakeTransactionsRemoteSource() : super(_dummyClient());

  @override
  Future<List<Transaction>> transactions() async => const [];
}

class FakeStatisticsRemoteSource extends StatisticsRemoteSource {
  FakeStatisticsRemoteSource() : super(_dummyClient());

  @override
  Future<Statistics> statistics() async => const Statistics();
}

void main() {
  testWidgets('session restore completes without uninitialized provider error',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer(
      overrides: [
        authRemoteSourceProvider.overrideWithValue(FakeAuthRemoteSource()),
        cookieAwareClientProvider.overrideWithValue(CookieAwareClient()),
        contactsRemoteSourceProvider.overrideWithValue(
          FakeContactsRemoteSource(),
        ),
        inventoryRemoteSourceProvider.overrideWithValue(
          FakeInventoryRemoteSource(),
        ),
        assetsRemoteSourceProvider.overrideWithValue(FakeAssetsRemoteSource()),
        transactionsRemoteSourceProvider.overrideWithValue(
          FakeTransactionsRemoteSource(),
        ),
        statisticsRemoteSourceProvider.overrideWithValue(
          FakeStatisticsRemoteSource(),
        ),
      ],
    );
    addTearDown(container.dispose);

    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const DompetQuApp(),
      ),
    );

    // Frame pertama: router dibangun, redirect berjalan, restore() dimulai.
    await tester.pump();
    // Tunggu restore() selesai (checkAuthorized + me) dan router.refresh().
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }

    // Jika ada self-read saat build (riverpod 3), restore() akan gagal dan
    // status tetap unknown — uncaught zone error juga menggagalkan test.
    expect(container.read(sessionControllerProvider).status,
        AuthStatus.authenticated);
    expect(container.read(appRouterProvider).state.uri.path, '/');
  });
}
