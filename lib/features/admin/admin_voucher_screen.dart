import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/voucher_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/voucher_provider.dart';

class AdminVoucherScreen extends StatefulWidget {
  const AdminVoucherScreen({super.key});

  @override
  State<AdminVoucherScreen> createState() => _AdminVoucherScreenState();
}

class _AdminVoucherScreenState extends State<AdminVoucherScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  static const _catColors = {
    VoucherCategory.coffee: Color(0xFF6D4C41),
    VoucherCategory.food: Color(0xFFE65100),
    VoucherCategory.minimarket: Color(0xFF1565C0),
    VoucherCategory.transport: Color(0xFF00796B),
    VoucherCategory.other: Color(0xFF6A1B9A),
  };

  @override
  Widget build(BuildContext context) {
    final vp = context.watch<VoucherProvider>();
    final auth = context.watch<AuthProvider>();
    final isSuperAdmin = auth.isSuperAdmin;

    final all = vp.allVouchersAdmin;
    final active = all.where((v) => v.isActive && v.stock > 0).toList();
    final soldOut = all.where((v) => v.stock == 0).toList();
    final inactive = all.where((v) => !v.isActive).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Add button
                      Row(children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Manajemen Voucher',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800)),
                            Text('Kelola semua voucher platform',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                        const Spacer(),
                        if (isSuperAdmin)
                          GestureDetector(
                            onTap: () => context.push('/admin/vouchers/create'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 9),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.4)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.add_rounded,
                                      color: Colors.white, size: 16),
                                  SizedBox(width: 5),
                                  Text('Buat Voucher',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ),
                      ]),
                      const SizedBox(height: 18),

                      // Stats row
                      Row(children: [
                        _StatChip(
                          icon: Icons.local_offer_rounded,
                          value: '${all.length}',
                          label: 'Total',
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        _StatChip(
                          icon: Icons.check_circle_rounded,
                          value: '${active.length}',
                          label: 'Aktif',
                          color: const Color(0xFF69F0AE),
                        ),
                        const SizedBox(width: 8),
                        _StatChip(
                          icon: Icons.redeem_rounded,
                          value: '${vp.totalRedeemedAll}',
                          label: 'Terpakai',
                          color: const Color(0xFFFFD54F),
                        ),
                        const SizedBox(width: 8),
                        _StatChip(
                          icon: Icons.block_rounded,
                          value: '${soldOut.length}',
                          label: 'Habis',
                          color: const Color(0xFFFF8A65),
                        ),
                      ]),
                      const SizedBox(height: 16),

                      // Tabs
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: TabBar(
                          controller: _tab,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: Colors.white70,
                          labelStyle: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700),
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          tabs: [
                            Tab(text: 'Semua (${all.length})'),
                            Tab(text: 'Aktif (${active.length})'),
                            Tab(text: 'Habis (${soldOut.length + inactive.length})'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: [
            _VoucherList(
              vouchers: all,
              vp: vp,
              isSuperAdmin: isSuperAdmin,
              catColors: _catColors,
            ),
            _VoucherList(
              vouchers: active,
              vp: vp,
              isSuperAdmin: isSuperAdmin,
              catColors: _catColors,
            ),
            _VoucherList(
              vouchers: [...soldOut, ...inactive],
              vp: vp,
              isSuperAdmin: isSuperAdmin,
              catColors: _catColors,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Voucher List ──────────────────────────────────────────────────────────────

class _VoucherList extends StatelessWidget {
  final List<VoucherModel> vouchers;
  final VoucherProvider vp;
  final bool isSuperAdmin;
  final Map<VoucherCategory, Color> catColors;

  const _VoucherList({
    required this.vouchers,
    required this.vp,
    required this.isSuperAdmin,
    required this.catColors,
  });

  @override
  Widget build(BuildContext context) {
    if (vouchers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 56, color: AppColors.textHint),
            SizedBox(height: 12),
            Text('Tidak ada voucher',
                style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: vouchers.length,
      itemBuilder: (ctx, i) {
        final v = vouchers[i];
        final color = catColors[v.category] ?? AppColors.primary;
        final totalRedeemed = vp.redeemedCount(v.id);
        final activeCount = vp.activeRedemptionCount(v.id);
        final usedCount = vp.usedRedemptionCount(v.id);

        return _VoucherAdminCard(
          voucher: v,
          catColor: color,
          totalRedeemed: totalRedeemed,
          activeCount: activeCount,
          usedCount: usedCount,
          isSuperAdmin: isSuperAdmin,
          onEditStock: () => _showEditStockDialog(ctx, v, vp),
          onEdit: isSuperAdmin
              ? () => context.push('/admin/vouchers/edit/${v.id}')
              : null,
          onDelete: isSuperAdmin ? () => _showDeleteDialog(ctx, v, vp) : null,
        );
      },
    );
  }

  void _showEditStockDialog(BuildContext context, VoucherModel v, VoucherProvider vp) {
    final ctrl = TextEditingController(text: v.stock.toString());
    final color = catColors[v.category] ?? AppColors.primary;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(v.category.icon, color: color, size: 20),
          const SizedBox(width: 8),
          const Text('Ubah Stok',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(v.name,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Row(children: [
              const Text('Stok saat ini: ',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text('${v.stock}',
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700, color: color)),
            ]),
            const SizedBox(height: 14),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Stok Baru',
                suffixText: 'lembar',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: color, width: 1.5)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final newStock = int.tryParse(ctrl.text);
              if (newStock != null && newStock >= 0) {
                vp.updateStock(v.id, newStock);
                Navigator.pop(dialogCtx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Simpan',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, VoucherModel v, VoucherProvider vp) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Voucher?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text('Voucher "${v.name}" akan dihapus permanen.',
            style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              vp.removeVoucher(v.id);
              Navigator.pop(dialogCtx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Hapus',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ── Voucher Admin Card ────────────────────────────────────────────────────────

class _VoucherAdminCard extends StatelessWidget {
  final VoucherModel voucher;
  final Color catColor;
  final int totalRedeemed;
  final int activeCount;
  final int usedCount;
  final bool isSuperAdmin;
  final VoidCallback onEditStock;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _VoucherAdminCard({
    required this.voucher,
    required this.catColor,
    required this.totalRedeemed,
    required this.activeCount,
    required this.usedCount,
    required this.isSuperAdmin,
    required this.onEditStock,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock = voucher.stock <= 5 && voucher.stock > 0;
    final isOutOfStock = voucher.stock == 0;
    final isInactive = !voucher.isActive;

    final borderColor = isOutOfStock || isInactive
        ? AppColors.error.withOpacity(0.35)
        : isLowStock
            ? AppColors.warning.withOpacity(0.4)
            : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.card,
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Column(
        children: [
          // ── Top row ──────────────────────────────────────
          Row(
            children: [
              // Category icon box
              Container(
                width: 56,
                height: 90,
                decoration: BoxDecoration(
                  color: (isInactive ? Colors.grey : catColor).withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(voucher.category.icon,
                        color: isInactive ? Colors.grey : catColor, size: 22),
                    const SizedBox(height: 4),
                    Text(
                      AppUtils.formatCurrency(voucher.value),
                      style: TextStyle(
                          color: isInactive ? Colors.grey : catColor,
                          fontSize: 8,
                          fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + badges
                      Row(children: [
                        Expanded(
                          child: Text(
                            voucher.name,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isInactive
                                    ? AppColors.textSecondary
                                    : AppColors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isInactive)
                          _Badge('Nonaktif', Colors.grey)
                        else if (isOutOfStock)
                          _Badge('Habis', AppColors.error)
                        else if (isLowStock)
                          _Badge('Sedikit', AppColors.warning)
                        else if (voucher.isFeatured)
                          _Badge('⭐ Unggulan', const Color(0xFFFFB300)),
                      ]),
                      Text(voucher.merchant,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary)),

                      const SizedBox(height: 8),

                      // Points + stock
                      Row(children: [
                        Icon(Icons.stars_rounded,
                            size: 13,
                            color: isInactive ? Colors.grey : catColor),
                        const SizedBox(width: 4),
                        Text('${voucher.pointsCost} Poin',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isInactive ? Colors.grey : catColor)),
                        const SizedBox(width: 12),
                        Icon(Icons.inventory_2_outlined,
                            size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          'Stok: ${voucher.stock}',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isOutOfStock
                                  ? AppColors.error
                                  : isLowStock
                                      ? AppColors.warning
                                      : AppColors.textSecondary),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),

              // Action buttons (vertical)
              Column(
                children: [
                  if (isSuperAdmin && onEdit != null)
                    _ActionBtn(Icons.edit_outlined, 'Edit', catColor, onEdit!),
                  _ActionBtn(Icons.add_box_outlined, 'Stok', catColor, onEditStock),
                  if (isSuperAdmin && onDelete != null)
                    _ActionBtn(Icons.delete_outline_rounded, 'Hapus',
                        AppColors.error, onDelete!),
                ],
              ),
              const SizedBox(width: 4),
            ],
          ),

          // ── Stats divider ─────────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _StatPill(
                  icon: Icons.redeem_rounded,
                  label: 'Total Ditukar',
                  value: '$totalRedeemed',
                  color: catColor,
                ),
                _VertDivider(),
                _StatPill(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Aktif',
                  value: '$activeCount',
                  color: AppColors.success,
                ),
                _VertDivider(),
                _StatPill(
                  icon: Icons.done_all_rounded,
                  label: 'Terpakai',
                  value: '$usedCount',
                  color: AppColors.textSecondary,
                ),
                _VertDivider(),
                _StatPill(
                  icon: Icons.calendar_today_rounded,
                  label: 'Kadaluwarsa',
                  value: AppUtils.formatDate(voucher.expiryDate),
                  color: AppColors.textSecondary,
                  small: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Small Widgets ─────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _StatChip(
      {required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(height: 3),
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 9)),
          ]),
        ),
      );
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool small;
  const _StatPill(
      {required this.icon, required this.label, required this.value, required this.color, this.small = false});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  fontSize: small ? 9 : 12, fontWeight: FontWeight.w700, color: color),
              textAlign: TextAlign.center),
          Text(label,
              style: const TextStyle(fontSize: 8, color: AppColors.textHint),
              textAlign: TextAlign.center),
        ]),
      );
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      width: 1, height: 30, color: Colors.grey.shade200, margin: const EdgeInsets.symmetric(horizontal: 4));
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(label,
            style: TextStyle(
                color: color, fontSize: 9, fontWeight: FontWeight.w700)),
      );
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn(this.icon, this.tooltip, this.color, this.onTap);

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(7),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      );
}
