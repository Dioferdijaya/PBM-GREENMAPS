import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/voucher_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/voucher_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../shared/widgets/green_button.dart';

class VoucherDetailScreen extends StatelessWidget {
  final String voucherId;
  const VoucherDetailScreen({super.key, required this.voucherId});

  static const _catColors = {
    VoucherCategory.coffee: [Color(0xFF6D4C41), Color(0xFFA1887F)],
    VoucherCategory.food: [Color(0xFFE65100), Color(0xFFFF7043)],
    VoucherCategory.minimarket: [Color(0xFF1565C0), Color(0xFF42A5F5)],
    VoucherCategory.transport: [Color(0xFF00796B), Color(0xFF26A69A)],
    VoucherCategory.other: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
  };

  @override
  Widget build(BuildContext context) {
    final voucher = context.watch<VoucherProvider>().getById(voucherId);
    final wallet = context.watch<WalletProvider>();

    if (voucher == null) {
      return Scaffold(
          appBar: AppBar(),
          body: const EmptyState(
              icon: Icons.help_outline_rounded,
              title: 'Voucher tidak ditemukan',
              subtitle: ''));
    }

    final canAfford = wallet.balance >= voucher.pointsCost;
    final colors = _catColors[voucher.category] ??
        [const Color(0xFF6A1B9A), const Color(0xFFAB47BC)];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with category-colored hero
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: colors[0],
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle),
                child:
                    Icon(Icons.arrow_back_ios_new_rounded, color: colors[0], size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Decorative circles
                  Positioned(
                    right: -40,
                    top: -40,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    bottom: 10,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                  // Content
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Icon in white circle
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(voucher.category.icon,
                              size: 40, color: Colors.white),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          AppUtils.formatCurrency(voucher.value),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          voucher.name,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Voucher ticket-style top connector
                Container(
                  color: AppColors.background,
                  child: Stack(
                    children: [
                      Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: colors[0],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                      ),
                      Container(
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: colors[0].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(voucher.category.icon,
                                    color: colors[0], size: 12),
                                const SizedBox(width: 5),
                                Text(voucher.category.label,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: colors[0])),
                              ],
                            ),
                          ),
                          if (voucher.isFeatured) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Text('🔥 Featured',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFE65100))),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(voucher.name,
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text(voucher.merchant,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 14)),
                      const SizedBox(height: 20),

                      // Info card
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppShadows.card,
                        ),
                        child: Column(
                          children: [
                            _InfoTile(Icons.store_rounded, 'Merchant',
                                voucher.merchant, colors[0]),
                            _Divider(),
                            _InfoTile(Icons.info_outline_rounded, 'Deskripsi',
                                voucher.description, colors[0]),
                            _Divider(),
                            _InfoTile(Icons.calendar_today_rounded,
                                'Berlaku hingga',
                                AppUtils.formatDate(voucher.expiryDate), colors[0]),
                            _Divider(),
                            _InfoTile(Icons.inventory_2_outlined, 'Stok tersisa',
                                '${voucher.stock} voucher', colors[0]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Cost card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppShadows.card,
                          border: Border.all(
                            color: canAfford
                                ? colors[0].withOpacity(0.2)
                                : AppColors.error.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: canAfford
                                    ? colors[0].withOpacity(0.1)
                                    : AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(Icons.stars_rounded,
                                  color: canAfford ? colors[0] : AppColors.error,
                                  size: 28),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Biaya Penukaran',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary)),
                                Text('${voucher.pointsCost} Poin',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: canAfford
                                            ? colors[0]
                                            : AppColors.error)),
                                if (!canAfford)
                                  Text(
                                    'Kurang ${voucher.pointsCost - wallet.balance} poin',
                                    style: const TextStyle(
                                        fontSize: 11, color: AppColors.error),
                                  ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Poin kamu',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary)),
                                Text('${wallet.balance}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: canAfford
                                            ? AppColors.primary
                                            : AppColors.error)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: AppShadows.elevated,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: canAfford
            ? ElevatedButton.icon(
                onPressed: () => _showConfirmDialog(context, voucher, colors[0]),
                icon: const Icon(Icons.redeem_rounded, color: Colors.white),
                label: const Text('Tukar Voucher',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors[0],
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              )
            : OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.lock_outline_rounded),
                label: const Text('Poin Tidak Cukup'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
      ),
    );
  }

  void _showConfirmDialog(
      BuildContext context, VoucherModel voucher, Color catColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28), topRight: Radius.circular(28)),
          boxShadow: AppShadows.elevated,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            // Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: catColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(voucher.category.icon, size: 36, color: catColor),
            ),
            const SizedBox(height: 16),
            Text('Tukar ${voucher.name}?',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
                'Kamu akan menggunakan ${voucher.pointsCost} poin untuk mendapatkan voucher ini.',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 14),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            // Summary box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: catColor.withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: catColor.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Voucher', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    Text(AppUtils.formatCurrency(voucher.value),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800, color: catColor)),
                  ]),
                  Icon(Icons.arrow_forward_rounded, color: catColor, size: 18),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    const Text('Poin terpakai', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    Text('-${voucher.pointsCost} Poin',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.error)),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(sheetCtx),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: Colors.grey.shade300),
                    foregroundColor: AppColors.textSecondary,
                  ),
                  child: const Text('Batal',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(sheetCtx);
                    final user = context.read<AuthProvider>().currentUser!;
                    final vp = context.read<VoucherProvider>();
                    final walletP = context.read<WalletProvider>();
                    final redemption =
                        await vp.redeemVoucher(voucher, user.id);
                    if (redemption != null) {
                      await walletP.spendPoints(voucher.pointsCost,
                          'Voucher ${voucher.name}', redemption.id, user.id);
                      if (context.mounted) {
                        context.go('/marketplace/qr/${redemption.id}');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: catColor,
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Tukar!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, indent: 16, endIndent: 16);
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _InfoTile(this.icon, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(value,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ]),
        ),
      ]),
    );
  }
}
