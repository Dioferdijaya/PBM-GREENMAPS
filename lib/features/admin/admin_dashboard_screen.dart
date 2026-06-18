import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/deposit_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/deposit_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final dp = context.watch<DepositProvider>();
    
    var allDeposits = dp.deposits;
    if (auth.isAdminBank) {
      allDeposits = allDeposits.where((d) => d.wasteBankId == user.wasteBankId).toList();
    }

    final pendingCount = allDeposits.where((d) => d.status == DepositStatus.pending).length;
    final processingCount = allDeposits.where((d) => d.status == DepositStatus.processing).length;
    final acceptedCount = allDeposits.where((d) => d.status == DepositStatus.accepted).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(user.name.substring(0, 1),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            auth.isSuperAdmin ? 'Super Admin' : 'Admin Bank',
                            style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11),
                          ),
                          Text(user.name,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          auth.isSuperAdmin ? '⚡ Super Admin' : '🏦 Bank Admin',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ]),
                    // Show bank name for bank admin
                    if (auth.isAdminBank) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(children: [
                          const Icon(Icons.account_balance_rounded, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              allDeposits.isNotEmpty
                                  ? allDeposits.first.wasteBankName
                                  : 'Bank Sampah',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ]),
                      ),
                    ],
                    const SizedBox(height: 20),
                    // Quick stats
                    Row(children: [
                      _QuickStatCard(Icons.pending_actions_rounded, 'Menunggu\nVerifikasi', pendingCount.toString(), Colors.orange),
                      const SizedBox(width: 12),
                      _QuickStatCard(Icons.hourglass_top_rounded, 'Sedang\nDiproses', processingCount.toString(), Colors.blue),
                      const SizedBox(width: 12),
                      _QuickStatCard(Icons.check_circle_outline_rounded, 'Berhasil\nDiproses', acceptedCount.toString(), Colors.green),
                    ]),
                  ]),
                ),
              ),
            ),
          ),

          // Quick action shortcuts
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(children: [
                _ShortcutCard(
                  icon: Icons.verified_user_rounded,
                  label: 'Verifikasi\nSetoran',
                  color: const Color(0xFF1565C0),
                  onTap: () => context.go('/admin/verification'),
                ),
                const SizedBox(width: 12),
                if (auth.isSuperAdmin) ...[
                  _ShortcutCard(
                    icon: Icons.account_balance_rounded,
                    label: 'Kelola\nBank',
                    color: const Color(0xFF00796B),
                    onTap: () => context.go('/admin/banks'),
                  ),
                  const SizedBox(width: 12),
                  _ShortcutCard(
                    icon: Icons.local_offer_rounded,
                    label: 'Kelola\nVoucher',
                    color: const Color(0xFF6A1B9A),
                    onTap: () => context.go('/admin/vouchers'),
                  ),
                ] else
                  _ShortcutCard(
                    icon: Icons.person_outline_rounded,
                    label: 'Profil\nAdmin',
                    color: const Color(0xFF6A1B9A),
                    onTap: () => context.go('/admin/profile'),
                  ),
              ]),
            ),
          ),

          // Recent Activity
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SectionHeader(title: 'Setoran Terbaru', actionLabel: 'Lihat Semua', onAction: () => context.go('/admin/verification')),
                const SizedBox(height: 14),
                if (allDeposits.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.card),
                    child: const Center(
                      child: Column(children: [
                        Icon(Icons.inbox_rounded, size: 40, color: AppColors.textHint),
                        SizedBox(height: 8),
                        Text('Belum ada setoran masuk', style: TextStyle(color: AppColors.textSecondary)),
                      ]),
                    ),
                  )
                else
                  ...allDeposits.take(5).map((d) => _AdminDepositCard(deposit: d)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ShortcutCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color), textAlign: TextAlign.center),
        ]),
      ),
    ),
  );
}


class _QuickStatCard extends StatelessWidget {
  final IconData icon; final String label, value; final Color color;
  const _QuickStatCard(this.icon, this.label, this.value, this.color);
  
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.card),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20)),
        const SizedBox(height: 12),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ]),
    ),
  );
}

class _AdminDepositCard extends StatelessWidget {
  final DepositModel deposit;
  const _AdminDepositCard({required this.deposit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/admin/verification/${deposit.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.card),
        child: Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Icon(Icons.recycling_rounded, size: 24, color: AppColors.primary))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(deposit.wasteTypeName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            Text('${deposit.estimatedWeight} Kg • User: ${deposit.userId}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(AppUtils.timeAgo(deposit.createdAt), style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
          ])),
          StatusBadge(status: deposit.status),
        ]),
      ),
    );
  }
}
