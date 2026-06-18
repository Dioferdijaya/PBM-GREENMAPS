import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/user_model.dart';
import '../../data/models/waste_bank_model.dart';
import '../../providers/deposit_provider.dart';
import 'package:provider/provider.dart';

class SuperAdminBanksScreen extends StatelessWidget {
  const SuperAdminBanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dp = context.watch<DepositProvider>();

    final banks = [
      _BankAdminPair(MockData.wasteBanks[0], MockData.adminBank1),
      _BankAdminPair(MockData.wasteBanks[1], MockData.adminBank2),
      _BankAdminPair(MockData.wasteBanks[2], MockData.adminBank3),
      _BankAdminPair(MockData.wasteBanks[3], MockData.adminBank4),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kelola Bank Sampah',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Aceh Besar & Banda Aceh',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 20),
                      // Summary stats
                      Row(
                        children: [
                          _SummaryChip(
                            Icons.account_balance_rounded,
                            '${banks.length}',
                            'Bank Sampah',
                          ),
                          const SizedBox(width: 10),
                          _SummaryChip(
                            Icons.pending_actions_rounded,
                            '${dp.deposits.where((d) => d.status.name == 'pending').length}',
                            'Menunggu',
                          ),
                          const SizedBox(width: 10),
                          _SummaryChip(
                            Icons.check_circle_rounded,
                            '${dp.deposits.where((d) => d.status.name == 'accepted').length}',
                            'Diterima',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final pair = banks[i];
                  final bankDeposits = dp.deposits
                      .where((d) => d.wasteBankId == pair.bank.id)
                      .toList();
                  final pending = bankDeposits
                      .where((d) => d.status.name == 'pending')
                      .length;
                  return _BankAdminCard(
                    bank: pair.bank,
                    admin: pair.admin,
                    depositCount: bankDeposits.length,
                    pendingCount: pending,
                    index: i,
                  );
                },
                childCount: banks.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BankAdminPair {
  final WasteBankModel bank;
  final UserModel admin;
  const _BankAdminPair(this.bank, this.admin);
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _SummaryChip(this.icon, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
                Text(label,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 9)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BankAdminCard extends StatelessWidget {
  final WasteBankModel bank;
  final UserModel admin;
  final int depositCount;
  final int pendingCount;
  final int index;
  const _BankAdminCard({
    required this.bank,
    required this.admin,
    required this.depositCount,
    required this.pendingCount,
    required this.index,
  });

  static const _colors = [
    [Color(0xFF00C853), Color(0xFF00E676)],
    [Color(0xFF0288D1), Color(0xFF03A9F4)],
    [Color(0xFF7B1FA2), Color(0xFFAB47BC)],
    [Color(0xFFE65100), Color(0xFFFF7043)],
  ];

  @override
  Widget build(BuildContext context) {
    final colors = _colors[index % _colors.length];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          // Bank header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.account_balance_rounded,
                        color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bank.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        bank.address,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: bank.isOpen
                        ? Colors.white.withOpacity(0.25)
                        : Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    bank.isOpen ? '● Buka' : '● Tutup',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          // Admin & stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Admin info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: colors[0].withOpacity(0.15),
                        child: Text(
                          admin.name.substring(0, 1),
                          style: TextStyle(
                              color: colors[0],
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(admin.name,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w700)),
                            Text(admin.email,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors[0].withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('Admin Bank',
                            style: TextStyle(
                                color: colors[0],
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Deposit stats
                Row(
                  children: [
                    _StatBadge(
                      label: 'Total Setoran',
                      value: '$depositCount',
                      color: colors[0],
                      icon: Icons.recycling_rounded,
                    ),
                    const SizedBox(width: 10),
                    _StatBadge(
                      label: 'Menunggu',
                      value: '$pendingCount',
                      color: pendingCount > 0
                          ? const Color(0xFFE65100)
                          : AppColors.textSecondary,
                      icon: Icons.pending_actions_rounded,
                    ),
                    const SizedBox(width: 10),
                    _StatBadge(
                      label: 'Jam Buka',
                      value: bank.openHours.split(' - ')[0],
                      color: AppColors.textSecondary,
                      icon: Icons.access_time_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Bank info row
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(bank.operationalDays,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary)),
                    const Spacer(),
                    const Icon(Icons.star_rounded,
                        size: 13, color: Color(0xFFFFB300)),
                    const SizedBox(width: 4),
                    Text('${bank.rating}',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label, value;
  final Color color;
  final IconData icon;
  const _StatBadge(
      {required this.label,
      required this.value,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w800)),
            Text(label,
                style: const TextStyle(
                    fontSize: 9, color: AppColors.textSecondary),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
