import 'package:flutter/material.dart';

enum VoucherCategory { coffee, food, minimarket, transport, other }

extension VoucherCategoryExt on VoucherCategory {
  String get label {
    switch (this) {
      case VoucherCategory.coffee:
        return 'Coffee Shop';
      case VoucherCategory.food:
        return 'Makanan';
      case VoucherCategory.minimarket:
        return 'Minimarket';
      case VoucherCategory.transport:
        return 'Transportasi';
      case VoucherCategory.other:
        return 'Lainnya';
    }
  }

  IconData get icon {
    switch (this) {
      case VoucherCategory.coffee:
        return Icons.local_cafe_rounded;
      case VoucherCategory.food:
        return Icons.fastfood_rounded;
      case VoucherCategory.minimarket:
        return Icons.store_rounded;
      case VoucherCategory.transport:
        return Icons.directions_bus_rounded;
      case VoucherCategory.other:
        return Icons.card_giftcard_rounded;
    }
  }
}

class VoucherModel {
  final String id;
  final String name;
  final String description;
  final String merchant;
  final String? imageUrl;
  final int pointsCost;
  final int stock;
  final VoucherCategory category;
  final DateTime expiryDate;
  final int value; // rupiah value
  final bool isActive;
  final bool isFeatured;

  VoucherModel({
    required this.id,
    required this.name,
    required this.description,
    required this.merchant,
    this.imageUrl,
    required this.pointsCost,
    required this.stock,
    required this.category,
    required this.expiryDate,
    required this.value,
    this.isActive = true,
    this.isFeatured = false,
  });

  VoucherModel copyWith({
    String? name,
    String? description,
    String? merchant,
    String? imageUrl,
    int? pointsCost,
    int? stock,
    VoucherCategory? category,
    DateTime? expiryDate,
    int? value,
    bool? isActive,
    bool? isFeatured,
  }) {
    return VoucherModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      merchant: merchant ?? this.merchant,
      imageUrl: imageUrl ?? this.imageUrl,
      pointsCost: pointsCost ?? this.pointsCost,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      expiryDate: expiryDate ?? this.expiryDate,
      value: value ?? this.value,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}

enum RedemptionStatus { active, used, expired }

class RedemptionModel {
  final String id;
  final String userId;
  final String voucherId;
  final String voucherName;
  final String merchant;
  final int pointsSpent;
  final String qrCode;
  final String uniqueCode;
  final RedemptionStatus status;
  final DateTime redeemedAt;
  final DateTime expiresAt;
  final int voucherValue;

  RedemptionModel({
    required this.id,
    required this.userId,
    required this.voucherId,
    required this.voucherName,
    required this.merchant,
    required this.pointsSpent,
    required this.qrCode,
    required this.uniqueCode,
    required this.status,
    required this.redeemedAt,
    required this.expiresAt,
    required this.voucherValue,
  });
}
