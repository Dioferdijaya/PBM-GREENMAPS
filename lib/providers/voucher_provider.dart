import 'package:flutter/foundation.dart';
import '../data/models/voucher_model.dart';
import '../data/mock/mock_data.dart';
import 'package:uuid/uuid.dart';

class VoucherProvider extends ChangeNotifier {
  final List<VoucherModel> _vouchers = List.from(MockData.vouchers);
  List<RedemptionModel> _myVouchers = List.from(MockData.myVouchers);

  // Simulated admin-level redemption records (all users)
  final List<RedemptionModel> _allRedemptions = [
    ...MockData.myVouchers,
    RedemptionModel(
      id: 'r010', userId: 'u002', voucherId: 'v001',
      voucherName: 'Kopi Gratis Janji Jiwa', merchant: 'Janji Jiwa',
      pointsSpent: 500, qrCode: 'GM-JJ-2024-010', uniqueCode: 'GMJJ2024010',
      status: RedemptionStatus.used,
      redeemedAt: DateTime.now().subtract(const Duration(days: 20)),
      expiresAt: DateTime.now().subtract(const Duration(days: 10)),
      voucherValue: 25000,
    ),
    RedemptionModel(
      id: 'r011', userId: 'u003', voucherId: 'v001',
      voucherName: 'Kopi Gratis Janji Jiwa', merchant: 'Janji Jiwa',
      pointsSpent: 500, qrCode: 'GM-JJ-2024-011', uniqueCode: 'GMJJ2024011',
      status: RedemptionStatus.active,
      redeemedAt: DateTime.now().subtract(const Duration(days: 2)),
      expiresAt: DateTime.now().add(const Duration(days: 12)),
      voucherValue: 25000,
    ),
    RedemptionModel(
      id: 'r012', userId: 'u004', voucherId: 'v002',
      voucherName: 'Burger King Meal', merchant: 'Burger King',
      pointsSpent: 350, qrCode: 'GM-BK-2024-012', uniqueCode: 'GMBK2024012',
      status: RedemptionStatus.used,
      redeemedAt: DateTime.now().subtract(const Duration(days: 5)),
      expiresAt: DateTime.now().add(const Duration(days: 9)),
      voucherValue: 50000,
    ),
    RedemptionModel(
      id: 'r013', userId: 'u005', voucherId: 'v003',
      voucherName: 'Grab 15K', merchant: 'Grab',
      pointsSpent: 200, qrCode: 'GM-GB-2024-013', uniqueCode: 'GMGB2024013',
      status: RedemptionStatus.active,
      redeemedAt: DateTime.now().subtract(const Duration(days: 1)),
      expiresAt: DateTime.now().add(const Duration(days: 13)),
      voucherValue: 15000,
    ),
    RedemptionModel(
      id: 'r014', userId: 'u002', voucherId: 'v004',
      voucherName: 'Indomaret 10K', merchant: 'Indomaret',
      pointsSpent: 150, qrCode: 'GM-IM-2024-014', uniqueCode: 'GMIM2024014',
      status: RedemptionStatus.used,
      redeemedAt: DateTime.now().subtract(const Duration(days: 8)),
      expiresAt: DateTime.now().subtract(const Duration(days: 1)),
      voucherValue: 10000,
    ),
  ];

  bool _isLoading = false;

  List<VoucherModel> get vouchers => _vouchers.where((v) => v.isActive).toList();
  List<RedemptionModel> get myVouchers => _myVouchers;
  bool get isLoading => _isLoading;

  // Admin: all vouchers (active and inactive)
  List<VoucherModel> get allVouchersAdmin => List.unmodifiable(_vouchers);

  // Admin: all redemptions across all users
  List<RedemptionModel> get allRedemptions => List.unmodifiable(_allRedemptions);

  // Admin stats per voucher
  int redeemedCount(String voucherId) =>
      _allRedemptions.where((r) => r.voucherId == voucherId).length;

  int activeRedemptionCount(String voucherId) =>
      _allRedemptions.where((r) => r.voucherId == voucherId && r.status == RedemptionStatus.active).length;

  int usedRedemptionCount(String voucherId) =>
      _allRedemptions.where((r) => r.voucherId == voucherId && r.status == RedemptionStatus.used).length;

  // Global admin stats
  int get totalRedeemedAll => _allRedemptions.length;
  int get totalActiveRedemptions => _allRedemptions.where((r) => r.status == RedemptionStatus.active).length;

  List<VoucherModel> byCategory(VoucherCategory? category) {
    if (category == null) return vouchers;
    return vouchers.where((v) => v.category == category).toList();
  }

  List<VoucherModel> get featured => vouchers.where((v) => v.isFeatured).toList();

  List<RedemptionModel> myVouchersByStatus(RedemptionStatus status) =>
      _myVouchers.where((r) => r.status == status).toList();

  Future<RedemptionModel?> redeemVoucher(VoucherModel voucher, String userId) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    final code = 'GM${DateTime.now().millisecondsSinceEpoch}';
    final redemption = RedemptionModel(
      id: const Uuid().v4(),
      userId: userId,
      voucherId: voucher.id,
      voucherName: voucher.name,
      merchant: voucher.merchant,
      pointsSpent: voucher.pointsCost,
      qrCode: code,
      uniqueCode: code.substring(0, 12),
      status: RedemptionStatus.active,
      redeemedAt: DateTime.now(),
      expiresAt: voucher.expiryDate,
      voucherValue: voucher.value,
    );

    _myVouchers.insert(0, redemption);
    _allRedemptions.insert(0, redemption);

    // Decrease stock
    final idx = _vouchers.indexWhere((v) => v.id == voucher.id);
    if (idx != -1 && _vouchers[idx].stock > 0) {
      _vouchers[idx] = _vouchers[idx].copyWith(stock: _vouchers[idx].stock - 1);
    }

    _isLoading = false;
    notifyListeners();
    return redemption;
  }

  VoucherModel? getById(String id) {
    try { return _vouchers.firstWhere((v) => v.id == id); } catch (_) { return null; }
  }

  RedemptionModel? getRedemptionById(String id) {
    try { return _myVouchers.firstWhere((r) => r.id == id); } catch (_) { return null; }
  }

  // Admin CRUD
  void addVoucher(VoucherModel v) {
    _vouchers.insert(0, v);
    notifyListeners();
  }

  void updateStock(String id, int newStock) {
    final index = _vouchers.indexWhere((v) => v.id == id);
    if (index != -1) {
      _vouchers[index] = _vouchers[index].copyWith(stock: newStock);
      notifyListeners();
    }
  }

  void updateVoucher(VoucherModel updatedVoucher) {
    final index = _vouchers.indexWhere((v) => v.id == updatedVoucher.id);
    if (index != -1) {
      _vouchers[index] = updatedVoucher;
      notifyListeners();
    }
  }

  void removeVoucher(String id) {
    _vouchers.removeWhere((v) => v.id == id);
    notifyListeners();
  }
}
