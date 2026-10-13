import 'package:shared_preferences/shared_preferences.dart';

abstract interface class DebtSettlementsLocalDataSource {
  Future<Set<String>> load();
  Future<void> save(Set<String> transactionIds);
}

class SharedPreferencesDebtSettlementsDataSource
    implements DebtSettlementsLocalDataSource {
  static const _storageKey = 'settled_debt_ids';

  @override
  Future<Set<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_storageKey) ?? const []).toSet();
  }

  @override
  Future<void> save(Set<String> transactionIds) async {
    final ids = transactionIds.toList()..sort();
    await (await SharedPreferences.getInstance()).setStringList(
      _storageKey,
      ids,
    );
  }
}
