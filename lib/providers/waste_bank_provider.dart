import 'package:flutter/foundation.dart';
import '../data/models/waste_bank_model.dart';
import '../data/models/waste_type_model.dart';
import '../data/mock/mock_data.dart';

class WasteBankProvider extends ChangeNotifier {
  final List<WasteBankModel> _banks = List.from(MockData.wasteBanks);
  final List<WasteTypeModel> _wasteTypes = List.from(MockData.wasteTypes);
  WasteBankModel? _selected;

  List<WasteBankModel> get banks => _banks;
  List<WasteTypeModel> get wasteTypes => _wasteTypes;
  WasteBankModel? get selected => _selected;

  void selectBank(WasteBankModel bank) {
    _selected = bank;
    notifyListeners();
  }

  List<WasteBankModel> nearby(double userLat, double userLng, {double radiusKm = 10}) {
    return _banks.where((b) {
      final dlat = (b.lat - userLat).abs();
      final dlng = (b.lng - userLng).abs();
      return dlat < radiusKm / 111 && dlng < radiusKm / 111;
    }).toList();
  }

  WasteTypeModel? wasteTypeById(String id) {
    try { return _wasteTypes.firstWhere((wt) => wt.id == id); } catch (_) { return null; }
  }

  // Admin CRUD
  void addBank(WasteBankModel bank) { _banks.add(bank); notifyListeners(); }
  void removeBank(String id) { _banks.removeWhere((b) => b.id == id); notifyListeners(); }
  void addWasteType(WasteTypeModel wt) { _wasteTypes.add(wt); notifyListeners(); }
  void removeWasteType(String id) { _wasteTypes.removeWhere((wt) => wt.id == id); notifyListeners(); }
}
