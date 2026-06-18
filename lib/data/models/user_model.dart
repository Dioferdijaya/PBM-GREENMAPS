class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String role; // 'user' | 'superadmin' | 'admin_bank'
  final String? wasteBankId; // Only for admin_bank
  final int totalPoints;
  final double totalWasteKg;
  final int depositCount;
  final bool isSuspended;
  final DateTime createdAt;
  final List<String> badges;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.role = 'user',
    this.wasteBankId,
    this.totalPoints = 0,
    this.totalWasteKg = 0.0,
    this.depositCount = 0,
    this.isSuspended = false,
    required this.createdAt,
    this.badges = const [],
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? wasteBankId,
    int? totalPoints,
    double? totalWasteKg,
    int? depositCount,
    bool? isSuspended,
    List<String>? badges,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role,
      wasteBankId: wasteBankId ?? this.wasteBankId,
      totalPoints: totalPoints ?? this.totalPoints,
      totalWasteKg: totalWasteKg ?? this.totalWasteKg,
      depositCount: depositCount ?? this.depositCount,
      isSuspended: isSuspended ?? this.isSuspended,
      createdAt: createdAt,
      badges: badges ?? this.badges,
    );
  }
}
