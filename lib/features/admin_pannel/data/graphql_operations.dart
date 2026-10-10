/// Daftar root operation GraphQL yang bisa dimatikan lewat kill switch.
///
/// Diambil dari SDL di cx-services (`domain/*/adapters/driving/graphql/*.gql`,
/// blok `type Query` dan `type Mutation`). Kill switch hanya berlaku untuk root
/// field, bukan field nested — sesuai `MapperKind.ROOT_FIELD` di backend.
///
/// Perbarui daftar ini bila SDL backend berubah.
library;

/// Root field bertipe `Query`.
const List<String> kGraphqlQueryOperations = [
  'Query.adminOverview',
  'Query.adminUserTransactions',
  'Query.adminUsers',
  'Query.asset',
  'Query.assetById',
  'Query.assetMutations',
  'Query.assets',
  'Query.checkAuthorized',
  'Query.contact',
  'Query.contactConnection',
  'Query.contacts',
  'Query.invoice',
  'Query.invoices',
  'Query.invoicesByStatus',
  'Query.me',
  'Query.order',
  'Query.orders',
  'Query.passkeyAuthenticationOptions',
  'Query.passkeyRegistrationOptions',
  'Query.passkeys',
  'Query.payment',
  'Query.payments',
  'Query.paymentsByStatus',
  'Query.product',
  'Query.products',
  'Query.setting',
  'Query.statistics',
  'Query.transaction',
  'Query.transactionConnection',
  'Query.transactions',
  'Query.transactionsByDateRange',
  'Query.transactionsByType',
  'Query.user',
  'Query.users',
];

/// Root field bertipe `Mutation`.
const List<String> kGraphqlMutationOperations = [
  'Mutation.addBalance',
  'Mutation.adminDeleteUser',
  'Mutation.adminSetUserRole',
  'Mutation.cancelInvoice',
  'Mutation.createAsset',
  'Mutation.createContact',
  'Mutation.createInvoice',
  'Mutation.createOrder',
  'Mutation.createOrderExpense',
  'Mutation.createOrderLoan',
  'Mutation.createOrderProductSale',
  'Mutation.createProduct',
  'Mutation.createTransaction',
  'Mutation.createUser',
  'Mutation.deleteAsset',
  'Mutation.deleteContact',
  'Mutation.deleteOrder',
  'Mutation.deletePasskey',
  'Mutation.deleteProduct',
  'Mutation.deleteTransaction',
  'Mutation.importContacts',
  'Mutation.importProductFromCSV',
  'Mutation.issueInvoice',
  'Mutation.mergeContacts',
  'Mutation.processPayment',
  'Mutation.registerPasskey',
  'Mutation.retryPayment',
  'Mutation.signIn',
  'Mutation.signInWithPassKey',
  'Mutation.signOut',
  'Mutation.signUp',
  'Mutation.subtractBalance',
  'Mutation.swapBalance',
  'Mutation.updateAsset',
  'Mutation.updateContact',
  'Mutation.updateOrder',
  'Mutation.updateProduct',
  'Mutation.updateSetting',
  'Mutation.updateTransaction',
  'Mutation.updateUserAvatar',
];

/// Gabungan semua operation (Query lalu Mutation).
const List<String> kGraphqlOperations = [
  ...kGraphqlQueryOperations,
  ...kGraphqlMutationOperations,
];
