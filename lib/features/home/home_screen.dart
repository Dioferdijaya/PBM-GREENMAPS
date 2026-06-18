import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/deposit_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../providers/deposit_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final wallet = context.watch<WalletProvider>();
    final user = auth.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar / Hero header ──────────────────────
          SliverToBoxAdapter(child: _buildHeader(context, user, wallet)),
          // ── Stats Row ─────────────────────────────────
          SliverToBoxAdapter(child: _buildStatsRow(context, user)),
          // ── Quick Actions ─────────────────────────────
          SliverToBoxAdapter(child: _buildQuickActions(context)),
          // ── Education Banner ──────────────────────────
          SliverToBoxAdapter(child: _buildEducationBanner(context)),
          // ── Nearby Banks ──────────────────────────────
          SliverToBoxAdapter(child: _buildNearbyBanks(context)),
          // ── Recent Deposits ───────────────────────────
          SliverToBoxAdapter(child: _buildRecentDeposits(context, user.id)),
          // ── Achievement Progress ───────────────────────
          SliverToBoxAdapter(child: _buildAchievements(context, user)),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, user, WalletProvider wallet) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        image: DecorationImage(
          image: const AssetImage('assets/images/home_header.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            children: [
              // Top row
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppUtils.getGreeting()}, 👋',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.name.split(' ').first,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.go('/profile'),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          user.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => context.go('/settings'),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.settings_outlined,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Points card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Poin Saya',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              AppUtils.formatPoints(wallet.balance),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 5, left: 6),
                              child: Text(
                                'poin',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.go('/wallet'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Text(
                          'Lihat Dompet',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, user) {
    final stats = [
      {'icon': Icons.recycling_rounded, 'label': 'Sampah Terkumpul', 'value': '${user.totalWasteKg} Kg'},
      {'icon': Icons.card_giftcard_rounded, 'label': 'Voucher Tersedia', 'value': '${MockData.vouchers.length} Voucher'},
      {'icon': Icons.account_balance_rounded, 'label': 'Bank Terdekat', 'value': '${MockData.wasteBanks.length} Lokasi'},
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: stats.map((s) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: s == stats.last ? 0 : 10,
              ),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                children: [
                  Icon(s['icon'] as IconData, size: 28, color: AppColors.primary),
                  const SizedBox(height: 8),
                  Text(
                    s['value'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    s['label'] as String,
                    style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.recycling_rounded, 'label': 'Setor\nSampah', 'route': '/deposit/create', 'color': AppColors.primary},
      {'icon': Icons.map_rounded, 'label': 'Peta Bank\nSampah', 'route': '/map', 'color': Color(0xFF00897B)},
      {'icon': Icons.local_offer_rounded, 'label': 'Tukar\nVoucher', 'route': '/marketplace', 'color': Color(0xFF7B1FA2)},
      {'icon': Icons.menu_book_rounded, 'label': 'Edukasi\nLingkungan', 'route': '/education', 'color': Color(0xFFE65100)},
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Aksi Cepat'),
          const SizedBox(height: 14),
          Row(
            children: actions.map((a) {
              final color = a['color'] as Color;
              return Expanded(
                child: GestureDetector(
                  onTap: () => context.go(a['route'] as String),
                  child: Container(
                    margin: EdgeInsets.only(right: a == actions.last ? 0 : 10),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Icon(a['icon'] as IconData, color: color, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          a['label'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationBanner(BuildContext context) {
    final banners = [
      {'icon': Icons.public_rounded, 'title': 'Cara Memilah Sampah', 'id': 'a001', 'color': Color(0xFF1B5E20)},
      {'icon': Icons.recycling_rounded, 'title': 'Manfaat Daur Ulang', 'id': 'a002', 'color': Color(0xFF00695C)},
      {'icon': Icons.emoji_objects_rounded, 'title': 'SDG 12 & Kamu', 'id': 'a003', 'color': Color(0xFF1565C0)},
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Edukasi Lingkungan',
            actionLabel: 'Lihat Semua',
            onAction: () => context.go('/education'),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: banners.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final b = banners[i];
                return GestureDetector(
                  onTap: () => context.go('/education/article/${b['id']}'),
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [b['color'] as Color,
                          Color.lerp(b['color'] as Color, Colors.black, 0.2)!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(b['icon'] as IconData, size: 36, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            b['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyBanks(BuildContext context) {
    final banks = MockData.wasteBanks.take(3).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Bank Sampah Terdekat',
            actionLabel: 'Lihat Peta',
            onAction: () => context.go('/map'),
          ),
          const SizedBox(height: 14),
          ...banks.map((bank) => GestureDetector(
            onTap: () => context.go('/map/bank/${bank.id}'),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.card,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: bank.isOpen
                          ? AppColors.primarySurface
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child: Icon(Icons.account_balance_rounded, size: 24, color: AppColors.primary)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bank.name,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 3),
                        Text(bank.openHours,
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: bank.isOpen
                          ? AppColors.success.withOpacity(0.1)
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      bank.isOpen ? 'Buka' : 'Tutup',
                      style: TextStyle(
                        color: bank.isOpen ? AppColors.success : AppColors.error,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildRecentDeposits(BuildContext context, String userId) {
    final deposits = context
        .watch<DepositProvider>()
        .depositsForUser(userId)
        .take(3)
        .toList();
    if (deposits.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Setoran Terkini',
            actionLabel: 'Lihat Semua',
            onAction: () => context.go('/deposit'),
          ),
          const SizedBox(height: 14),
          ...deposits.map((d) => GestureDetector(
            onTap: () => context.go('/deposit/detail/${d.id}'),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.card,
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child: Icon(Icons.recycling_rounded, size: 22, color: AppColors.primary)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d.wasteTypeName,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        Text('${d.estimatedWeight} Kg • ${d.wasteBankName}',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (d.pointsEarned != null)
                        Text(
                          '+${d.pointsEarned} poin',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      const SizedBox(height: 4),
                      _statusChip(d.status.label, d.status),
                    ],
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _statusChip(String label, DepositStatus status) {
    Color color;
    switch (status.toString()) {
      case 'DepositStatus.accepted': color = AppColors.success; break;
      case 'DepositStatus.rejected': color = AppColors.error; break;
      case 'DepositStatus.processing': color = AppColors.info; break;
      default: color = AppColors.warning;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildAchievements(BuildContext context, user) {
    final achievements = MockData.achievements;
    final unlocked = achievements.where((a) => a.isUnlocked).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Achievement',
            actionLabel: 'Lihat Semua',
            onAction: () => context.go('/home/achievements'),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '$unlocked/${achievements.length}',
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Badge Terkumpul',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          LinearPercentIndicator(
                            percent: unlocked / achievements.length,
                            lineHeight: 8,
                            backgroundColor: AppColors.primarySurface,
                            progressColor: AppColors.primary,
                            barRadius: const Radius.circular(50),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: achievements.take(6).map((a) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: Column(
                          children: [
                            Icon(
                              a.icon,
                              size: 28,
                              color: a.isUnlocked ? AppColors.primary : Colors.grey,
                            ),
                            if (!a.isUnlocked)
                              const Icon(Icons.lock_rounded,
                                  size: 12, color: AppColors.textHint),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
