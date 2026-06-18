import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final user = context.watch<AuthProvider>().currentUser!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('Dompet Poin',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => context.go('/wallet/history'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Text('Riwayat',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Balance card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Text('💰',
                                  style: TextStyle(fontSize: 40)),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Saldo Poin',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13)),
                                  Text(
                                    AppUtils.formatPoints(wallet.balance),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 34,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  const Text('poin tersedia',
                                      style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // In/Out summary
                  Row(
                    children: [
                      Expanded(
                        child: _SumCard(
                          icon: Icons.arrow_downward_rounded,
                          label: 'Poin Masuk',
                          value: '+${AppUtils.formatPoints(wallet.totalIn)}',
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SumCard(
                          icon: Icons.arrow_upward_rounded,
                          label: 'Poin Keluar',
                          value: '-${AppUtils.formatPoints(wallet.totalOut)}',
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Quick action
                  GestureDetector(
                    onTap: () => context.go('/marketplace'),
                    child: GradientCard(
                      colors: const [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
                      child: Row(
                        children: [
                          const Text('🎁', style: TextStyle(fontSize: 40)),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tukar Poin dengan Voucher',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700)),
                                Text('Kunjungi marketplace sekarang',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              color: Colors.white70),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Recent transactions
                  SectionHeader(
                    title: 'Transaksi Terbaru',
                    actionLabel: 'Lihat Semua',
                    onAction: () => context.go('/wallet/history'),
                  ),
                  const SizedBox(height: 14),
                  ...wallet.transactionsForUser(user.id).take(5).map(
                    (tx) => _TxTile(tx: tx),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SumCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _SumCard(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
              Text(value,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: color)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TxTile extends StatelessWidget {
  final tx;
  const _TxTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isIn = tx.amount > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isIn
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIn ? Icons.add_circle_rounded : Icons.remove_circle_rounded,
              color: isIn ? AppColors.success : AppColors.error,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.description,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(AppUtils.timeAgo(tx.createdAt),
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          ),
          Text(
            '${isIn ? '+' : ''}${tx.amount} poin',
            style: TextStyle(
                color: isIn ? AppColors.success : AppColors.error,
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
