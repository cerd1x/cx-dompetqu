abstract interface class DebtSettlementsRepository {
  Future<Set<String>> load();
  Future<void> save(Set<String> transactionIds);
}
