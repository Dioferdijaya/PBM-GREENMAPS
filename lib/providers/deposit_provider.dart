import 'package:flutter/foundation.dart';
import '../data/models/deposit_model.dart';
import '../data/models/waste_type_model.dart';
import '../data/models/waste_bank_model.dart';
import '../data/mock/mock_data.dart';
import 'package:uuid/uuid.dart';

class DepositProvider extends ChangeNotifier {
  List<DepositModel> _deposits = List.from(MockData.deposits);
  bool _isLoading = false;

  List<DepositModel> get deposits => _deposits;
  bool get isLoading => _isLoading;

  List<DepositModel> depositsForUser(String userId) =>
      _deposits.where((d) => d.userId == userId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<DepositModel> get allDeposits =>
      List.from(_deposits)..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<DepositModel> depositsByStatus(DepositStatus status) =>
      _deposits.where((d) => d.status == status).toList();

  Future<bool> createDeposit({
    required String userId,
    required WasteBankModel wasteBank,
    required WasteTypeModel wasteType,
    required double estimatedWeight,
    String? photoUrl,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    final deposit = DepositModel(
      id: const Uuid().v4(),
      userId: userId,
      wasteBankId: wasteBank.id,
      wasteBankName: wasteBank.name,
      wasteTypeId: wasteType.id,
      wasteTypeName: wasteType.name,
      estimatedWeight: estimatedWeight,
      photoUrl: photoUrl,
      status: DepositStatus.pending,
      createdAt: DateTime.now(),
    );

    _deposits.insert(0, deposit);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> updateDepositStatus(
    String depositId,
    DepositStatus status, {
    double? actualWeight,
    String? adminNote,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    final index = _deposits.indexWhere((d) => d.id == depositId);
    if (index == -1) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

    int? points;
    if (status == DepositStatus.accepted) {
       final wt = MockData.wasteTypes.firstWhere((w) => w.id == _deposits[index].wasteTypeId, orElse: () => MockData.wasteTypes.first);
       points = ((actualWeight ?? _deposits[index].estimatedWeight) * wt.pointsPerKg).toInt();
    }

    _deposits[index] = _deposits[index].copyWith(
      actualWeight: actualWeight,
      status: status,
      pointsEarned: points,
      adminNote: adminNote,
      processedAt: status == DepositStatus.accepted || status == DepositStatus.rejected ? DateTime.now() : null,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  DepositModel? getById(String id) {
    try {
      return _deposits.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }
}
