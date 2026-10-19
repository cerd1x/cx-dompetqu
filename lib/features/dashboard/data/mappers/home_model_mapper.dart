import 'package:dompetqu/features/assets/data/models/asset.dart' as data;
import 'package:dompetqu/features/assets/data/models/asset_mutation.dart'
    as data;
import 'package:dompetqu/features/assets/domain/entities/asset.dart' as domain;
import 'package:dompetqu/features/assets/domain/entities/asset_mutation.dart'
    as domain;
import 'package:dompetqu/features/contacts/data/models/contact.dart' as data;
import 'package:dompetqu/features/contacts/data/models/contact_page.dart'
    as data;
import 'package:dompetqu/features/contacts/domain/entities/contact.dart'
    as domain;
import 'package:dompetqu/features/contacts/domain/entities/contact_page.dart'
    as domain;
import 'package:dompetqu/features/inventory/data/models/product.dart' as data;
import 'package:dompetqu/features/inventory/domain/entities/product.dart'
    as domain;
import 'package:dompetqu/features/statistics/data/models/statistics.dart'
    as data;
import 'package:dompetqu/features/statistics/domain/entities/statistics.dart'
    as domain;
import 'package:dompetqu/features/transactions/data/models/transaction.dart'
    as data;
import 'package:dompetqu/features/transactions/data/models/transaction_page.dart'
    as data;
import 'package:dompetqu/features/transactions/domain/entities/transaction.dart'
    as domain;
import 'package:dompetqu/features/transactions/domain/entities/transaction_page.dart'
    as domain;

extension AssetModelMapper on data.Asset {
  domain.Asset toEntity() =>
      domain.Asset(id: id, name: name, type: type, balance: balance);
}

extension AssetMutationModelMapper on data.AssetMutation {
  domain.AssetMutation toEntity() => domain.AssetMutation(
    id: id,
    type: type,
    amount: amount,
    currency: currency,
    balanceBefore: balanceBefore,
    balanceAfter: balanceAfter,
    description: description,
    createdAt: createdAt,
  );
}

extension ContactModelMapper on data.Contact {
  domain.Contact toEntity() => domain.Contact(
    id: id,
    name: name,
    email: email,
    phone: phone,
    phones: phones,
    group: group,
    avatar: avatar,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension ContactPageModelMapper on data.ContactPage {
  domain.ContactPage toEntity() => domain.ContactPage(
    items: items.map((item) => item.toEntity()).toList(growable: false),
    hasNextPage: hasNextPage,
    nextCursor: nextCursor,
  );
}

extension ProductModelMapper on data.Product {
  domain.Product toEntity() => domain.Product(
    id: id,
    name: name,
    description: description,
    price: price,
    capital: capital,
    margin: margin,
    currency: currency,
    stock: stock,
    trackStock: trackStock,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension StatisticsModelMapper on data.Statistics {
  domain.Statistics toEntity() => domain.Statistics(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    totalProfit: totalProfit,
    totalLoan: totalLoan,
    totalCash: totalCash,
    totalAsset: totalAsset,
  );
}

extension TransactionModelMapper on data.Transaction {
  domain.Transaction toEntity() => domain.Transaction(
    id: id,
    type: type,
    amount: amount,
    capital: capital,
    description: description,
    category: category,
    paymentMethod: paymentMethod?.toEntity(),
    customerId: customerId,
    status: status,
    paymentStatus: paymentStatus,
    createdAt: createdAt,
  );
}

extension PaymentMethodModelMapper on data.PaymentMethod {
  domain.PaymentMethod toEntity() =>
      domain.PaymentMethod(type: type, assetId: assetId);
}

extension TransactionPageModelMapper on data.TransactionPage {
  domain.TransactionPage toEntity() => domain.TransactionPage(
    items: items.map((item) => item.toEntity()).toList(growable: false),
    hasNextPage: hasNextPage,
    nextCursor: nextCursor,
  );
}
