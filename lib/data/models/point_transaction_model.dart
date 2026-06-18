enum PointTransactionType { earned, spent, adjusted }

class PointTransactionModel {
  final String id;
  final String userId;
  final int amount; // positive = in, negative = out
  final PointTransactionType type;
  final String description;
  final String? referenceId; // deposit ID or voucher ID
  final DateTime createdAt;

  PointTransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.description,
    this.referenceId,
    required this.createdAt,
  });

  bool get isIncoming => amount > 0;
}
