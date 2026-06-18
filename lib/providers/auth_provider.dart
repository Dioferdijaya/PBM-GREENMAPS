import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';
import '../data/mock/mock_data.dart';
import '../core/constants/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSuperAdmin => _currentUser?.role == 'superadmin';
  bool get isAdminBank => _currentUser?.role == 'admin_bank';
  bool get isAdmin => isSuperAdmin || isAdminBank;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
    final role = prefs.getString(AppConstants.keyUserRole) ?? '';
    if (_isLoggedIn) {
      if (role == 'superadmin') _currentUser = MockData.superAdmin;
      else if (role == 'admin_bank') {
        final email = prefs.getString('admin_email');
        if (email == 'admin1@greenmap.id') _currentUser = MockData.adminBank1;
        else if (email == 'admin2@greenmap.id') _currentUser = MockData.adminBank2;
        else if (email == 'admin3@greenmap.id') _currentUser = MockData.adminBank3;
        else if (email == 'admin4@greenmap.id') _currentUser = MockData.adminBank4;
      }
      else {
        final email = prefs.getString('user_email');
        try {
          _currentUser = MockData.users.firstWhere((u) => u.email == email);
        } catch (_) {
          _currentUser = MockData.currentUser;
        }
      }
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    // Super Admin credentials
    if (email == 'superadmin@greenmap.id' && password == 'admin123') {
      _currentUser = MockData.superAdmin;
      await _saveSession('superadmin', email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    }

    // Admin Bank credentials
    if (password == 'admin123' && email.startsWith('admin') && email.endsWith('@greenmap.id')) {
      if (email == 'admin1@greenmap.id') _currentUser = MockData.adminBank1;
      else if (email == 'admin2@greenmap.id') _currentUser = MockData.adminBank2;
      else if (email == 'admin3@greenmap.id') _currentUser = MockData.adminBank3;
      else if (email == 'admin4@greenmap.id') _currentUser = MockData.adminBank4;
      else {
        _error = 'Email atau password salah';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _saveSession('admin_bank', email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    }

    // User credentials (Dynamic mock check)
    try {
      final user = MockData.users.firstWhere((u) => u.email == email);
      // For mock purposes, assume password is correct or check it if we stored it
      // but since UserModel doesn't have password, just accept it
      if (password.length >= 6) { // basic validation
        _currentUser = user;
        await _saveSession(AppConstants.roleUser, email: email);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (_) {
      // User not found, fall through
    }

    _error = 'Email atau password salah';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String phone, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    _currentUser = UserModel(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      createdAt: DateTime.now(),
    );
    MockData.users.add(_currentUser!);
    await _saveSession(AppConstants.roleUser, email: email);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> _saveSession(String role, {String? email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);
    await prefs.setString(AppConstants.keyUserRole, role);
    if (email != null) {
      if (role == 'admin_bank' || role == 'superadmin') {
        await prefs.setString('admin_email', email);
      } else {
        await prefs.setString('user_email', email);
      }
    }
    _isLoggedIn = true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> updateProfile(String name, String phone) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(name: name, phone: phone);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void addPointsAndWaste(String userId, int points, double wasteKg) {
    if (_currentUser?.id == userId) {
      _currentUser = _currentUser!.copyWith(
        totalPoints: _currentUser!.totalPoints + points,
        totalWasteKg: _currentUser!.totalWasteKg + wasteKg,
      );
      notifyListeners();
    }
    
    // Also update in MockData so it persists
    if (userId == MockData.currentUser.id) {
      // Just update the static currentUser directly for simple mock state
      // Note: We can't actually change final fields of MockData.currentUser if it's static final,
      // but let's just find it in the users list
      final idx = MockData.users.indexWhere((u) => u.id == userId);
      if (idx != -1) {
        MockData.users[idx] = MockData.users[idx].copyWith(
          totalPoints: MockData.users[idx].totalPoints + points,
          totalWasteKg: MockData.users[idx].totalWasteKg + wasteKg,
        );
      }
    }
  }
}
