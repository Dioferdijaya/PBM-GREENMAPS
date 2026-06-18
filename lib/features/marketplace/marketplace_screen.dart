import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/voucher_model.dart';
import '../../providers/voucher_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  VoucherCategory? _selected;

  @override
  Widget build(BuildContext context) {
    final voucherProvider = context.watch<VoucherProvider>();
    final wallet = context.watch<WalletProvider>();
    final featured = voucherProvider.featured;
    final list = voucherProvider.byCategory(_selected);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                image: DecorationImage(
                  image: const AssetImage('assets/images/marketplace_banner.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.card_giftcard_rounded,
                              size: 28, color: Colors.white),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Marketplace',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                              Text('Tukar poin dengan hadiah',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () =>
                                context.go('/marketplace/my-vouchers'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.wallet_rounded,
                                      color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text('Voucherku',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Points balance pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.stars_rounded,
                                size: 18, color: Colors.amber),
                            const SizedBox(width: 8),
                            Text(
                              '${AppUtils.formatPoints(wallet.balance)} poin tersedia',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Featured
          if (featured.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: '🔥 Pilihan Utama'),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: featured.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (_, i) =>
                            _FeaturedCard(voucher: featured[i]),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Category filter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Kategori',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _CatChip(
                            label: 'Semua',
                            icon: Icons.card_giftcard_rounded,
                            selected: _selected == null,
                            onTap: () =>
                                setState(() => _selected = null)),
                        ...VoucherCategory.values.map((c) => _CatChip(
                              label: c.label,
                              icon: c.icon,
                              selected: _selected == c,
                              onTap: () =>
                                  setState(() => _selected = c),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Voucher list
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            sliver: list.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            Icon(Icons.card_giftcard_outlined,
                                size: 64, color: AppColors.textHint),
                            SizedBox(height: 12),
                            Text('Belum ada voucher di kategori ini',
                                style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _VoucherListCard(voucher: list[i]),
                      childCount: list.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CatChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _CatChip(
      {required this.label,
      required this.icon,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
              color: selected ? AppColors.primary : Colors.grey.shade200),
          boxShadow: selected ? AppShadows.button : AppShadows.card,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: selected ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        selected ? Colors.white : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final VoucherModel voucher;
  const _FeaturedCard({required this.voucher});

  static const _gradients = [
    [Color(0xFF7B1FA2), Color(0xFFAB47BC)],
    [Color(0xFF00796B), Color(0xFF26A69A)],
    [Color(0xFF1565C0), Color(0xFF42A5F5)],
    [Color(0xFFE65100), Color(0xFFFF7043)],
  ];

  @override
  Widget build(BuildContext context) {
    final gi = voucher.category.index % _gradients.length;
    final g = _gradients[gi];
    return GestureDetector(
      onTap: () => context.go('/marketplace/voucher/${voucher.id}'),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: g,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: g[0].withOpacity(0.3),
                blurRadius: 14,
                offset: const Offset(0, 6))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(voucher.category.icon, size: 20, color: Colors.white),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text('⭐ Featured',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const Spacer(),
            Text(
              AppUtils.formatCurrency(voucher.value),
              style: const TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(voucher.name,
                style: const TextStyle(
                    color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text(voucher.merchant,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.stars_rounded, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text('${voucher.pointsCost} poin',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VoucherListCard extends StatelessWidget {
  final VoucherModel voucher;
  const _VoucherListCard({required this.voucher});

  static const _catColors = {
    VoucherCategory.coffee: Color(0xFF6D4C41),
    VoucherCategory.food: Color(0xFFE65100),
    VoucherCategory.minimarket: Color(0xFF1565C0),
    VoucherCategory.transport: Color(0xFF00796B),
    VoucherCategory.other: Color(0xFF6A1B9A),
  };

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final canAfford = wallet.balance >= voucher.pointsCost;
    final catColor = _catColors[voucher.category] ?? AppColors.primary;

    return GestureDetector(
      onTap: () => context.go('/marketplace/voucher/${voucher.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            // Left colored panel
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: catColor.withOpacity(0.12),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(voucher.category.icon, color: catColor, size: 28),
                  const SizedBox(height: 6),
                  Text(
                    AppUtils.formatCurrency(voucher.value),
                    style: TextStyle(
                      color: catColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Dashed divider
            CustomPaint(
              painter: _DashPainter(color: Colors.grey.shade200),
              size: const Size(1, 100),
            ),
            // Right content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: catColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            voucher.category.label,
                            style: TextStyle(
                                color: catColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (voucher.isFeatured) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Featured',
                                style: TextStyle(
                                    color: Color(0xFFE65100),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      voucher.name,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      voucher.merchant,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.stars_rounded,
                            size: 14,
                            color: canAfford
                                ? AppColors.primary
                                : AppColors.error),
                        const SizedBox(width: 4),
                        Text(
                          '${voucher.pointsCost} Poin',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: canAfford
                                ? AppColors.primary
                                : AppColors.error,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Stok: ${voucher.stock}',
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Chevron
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.chevron_right_rounded,
                  color: AppColors.textHint, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;
  const _DashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const dashH = 5.0;
    const gapH = 4.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashH), paint);
      y += dashH + gapH;
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => old.color != color;
}
