/// Fitur aplikasi yang dapat dipilih sebagai sumber log ke file.
enum AppLogFeature {
  app,
  appLock,
  adminPanel,
  analytics,
  assets,
  auth,
  betaReport,
  charts,
  contacts,
  dashboard,
  genAi,
  inventory,
  order,
  portfolio,
  settings,
  statistics,
  struct,
  transactions,
  graphql,
  network,
  core;

  /// Menghubungkan tag logger yang sudah digunakan ke kategori fitur.
  static AppLogFeature fromTag(String? tag) {
    final normalized = tag?.toLowerCase() ?? '';
    if (normalized == 'app') return app;
    if (normalized.contains('applock')) return appLock;
    if (normalized.contains('killswitch')) return adminPanel;
    if (normalized.contains('analytics')) return analytics;
    if (normalized.contains('asset')) return assets;
    if (normalized == 'session' ||
        normalized.contains('auth') ||
        normalized == 'passkey') {
      return auth;
    }
    if (normalized.contains('betareport')) return betaReport;
    if (normalized.contains('chart')) return charts;
    if (normalized.contains('contact')) return contacts;
    if (normalized.contains('dashboard')) return dashboard;
    if (normalized.contains('ai') || normalized.contains('mcp')) return genAi;
    if (normalized.contains('inventory')) return inventory;
    if (normalized.contains('order') || normalized == 'saleform') return order;
    if (normalized.contains('portfolio')) return portfolio;
    if (normalized.contains('setting')) return settings;
    if (normalized.contains('statistic')) return statistics;
    if (normalized.contains('struct')) return struct;
    if (normalized.contains('transaction')) return transactions;
    if (normalized == 'graphql') return graphql;
    if (normalized.contains('cookie') || normalized.contains('network')) {
      return network;
    }
    return core;
  }
}
