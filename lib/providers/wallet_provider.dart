import 'package:flutter/foundation.dart';
import '../data/models/point_transaction_model.dart';
import '../data/mock/mock_data.dart';

class WalletProvider extends ChangeNotifier {
  List<PointTransactionModel> _transactions = List.from(MockData.pointTransactions);
  int _balance = MockData.currentUser.totalPoints;
  // Track which user's wallet is active (defaults to demo user)
  String? _currentUserId = MockData.currentUser.id;

  int get balance => _balance;
  List<PointTransactionModel> get transactions =>
      List.from(_transactions)..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  // Initialize wallet state for a specific user
  void initForUser(String userId, int startingPoints) {
    _currentUserId = userId;
    if (userId == MockData.currentUser.id) {
      // Demo user - restore mock transactions and real points
      _transactions = List.from(MockData.pointTransactions);
      _balance = startingPoints;
    } else {
      // New / other user - start fresh
      _transactions = MockData.pointTransactions
          .where((t) => t.userId == userId)
          .toList();
      _balance = startingPoints;
    }
    notifyListeners();
  }

  int get totalIn => _transactions
      .where((t) => t.amount > 0)
      .fold(0, (sum, t) => sum + t.amount);

  int get totalOut => _transactions
      .where((t) => t.amount < 0)
      .fold(0, (sum, t) => sum + t.amount.abs());

  List<PointTransactionModel> transactionsForUser(String userId) =>
      _transactions.where((t) => t.userId == userId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  void addTransaction(PointTransactionModel tx) {
    _transactions.insert(0, tx);
    // Update balance only if transaction belongs to the currently active user
    if (tx.userId == _currentUserId) {
      _balance += tx.amount;
    }
    notifyListeners();
  }

  Future<bool> spendPoints(int amount, String description, String? refId, String userId) async {
    if (_balance < amount) return false;
    addTransaction(PointTransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      amount: -amount,
      type: PointTransactionType.spent,
      description: description,
      referenceId: refId,
      createdAt: DateTime.now(),
    ));
    return true;
  }

  Future<void> earnPoints(int amount, String description, String? refId, String userId) async {
    addTransaction(PointTransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      amount: amount,
      type: PointTransactionType.earned,
      description: description,
      referenceId: refId,
      createdAt: DateTime.now(),
    ));
  }

  // Admin adjust
  Future<void> adjustPoints(int amount, String description, String userId) async {
    addTransaction(PointTransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      amount: amount,
      type: PointTransactionType.adjusted,
      description: description,
      createdAt: DateTime.now(),
    ));
  }

  void setBalance(int balance) {
    _balance = balance;
    notifyListeners();
  }
}
