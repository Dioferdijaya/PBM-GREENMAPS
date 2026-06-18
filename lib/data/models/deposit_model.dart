enum DepositStatus { pending, processing, accepted, rejected }

extension DepositStatusExt on DepositStatus {
  String get label {
    switch (this) {
      case DepositStatus.pending:
        return 'Menunggu';
      case DepositStatus.processing:
        return 'Diproses';
      case DepositStatus.accepted:
        return 'Diterima';
      case DepositStatus.rejected:
        return 'Ditolak';
    }
  }

  String get colorHex {
    switch (this) {
      case DepositStatus.pending:
        return '#FF9800';
      case DepositStatus.processing:
        return '#2196F3';
      case DepositStatus.accepted:
        return '#4CAF50';
      case DepositStatus.rejected:
        return '#F44336';
    }
  }
}

class DepositModel {
  final String id;
  final String userId;
  final String wasteBankId;
  final String wasteBankName;
  final String wasteTypeId;
  final String wasteTypeName;
  final double estimatedWeight;
  final double? actualWeight;
  final String? photoUrl;
  final DepositStatus status;
  final int? pointsEarned;
  final String? adminNote;
  final DateTime createdAt;
  final DateTime? processedAt;

  DepositModel({
    required this.id,
    required this.userId,
    required this.wasteBankId,
    required this.wasteBankName,
    required this.wasteTypeId,
    required this.wasteTypeName,
    required this.estimatedWeight,
    this.actualWeight,
    this.photoUrl,
    this.status = DepositStatus.pending,
    this.pointsEarned,
    this.adminNote,
    required this.createdAt,
    this.processedAt,
  });

  DepositModel copyWith({
    double? actualWeight,
    DepositStatus? status,
    int? pointsEarned,
    String? adminNote,
    DateTime? processedAt,
  }) {
    return DepositModel(
      id: id,
      userId: userId,
      wasteBankId: wasteBankId,
      wasteBankName: wasteBankName,
      wasteTypeId: wasteTypeId,
      wasteTypeName: wasteTypeName,
      estimatedWeight: estimatedWeight,
      actualWeight: actualWeight ?? this.actualWeight,
      photoUrl: photoUrl,
      status: status ?? this.status,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      adminNote: adminNote ?? this.adminNote,
      createdAt: createdAt,
      processedAt: processedAt ?? this.processedAt,
    );
  }
}
