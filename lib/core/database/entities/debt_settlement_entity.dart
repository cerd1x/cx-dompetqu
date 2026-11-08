import 'package:objectbox/objectbox.dart';

/// Settled debt transaction IDs.
@Entity()
class DebtSettlementEntity {
  DebtSettlementEntity({this.id = 0, this.transactionId = ''});

  int id = 0;

  @Index()
  @Unique()
  String transactionId = '';
}
