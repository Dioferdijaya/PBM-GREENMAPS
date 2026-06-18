import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class PointHistoryScreen extends StatelessWidget {
  const PointHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final user = context.watch<AuthProvider>().currentUser!;
    final txs = wallet.transactionsForUser(user.id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Riwayat Poin'),
      ),
      body: txs.isEmpty
          ? const EmptyState(
              icon: Icons.bar_chart_rounded,
              title: 'Belum ada transaksi',
              subtitle: 'Mulai setor sampah untuk mendapatkan poin!')
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: txs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final tx = txs[i];
                final isIn = tx.amount > 0;
                return Container(
                  padding: const EdgeInsets.all(16),
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
                          color: isIn
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Icon(isIn ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                              size: 22, color: isIn ? AppColors.success : AppColors.error),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tx.description,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text(AppUtils.formatDateTime(tx.createdAt),
                                style: const TextStyle(
                                    fontSize: 11, color: AppColors.textHint)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${isIn ? '+' : ''}${tx.amount} poin',
                        style: TextStyle(
                          color: isIn ? AppColors.success : AppColors.error,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
