import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/voucher_provider.dart';
import '../../data/models/voucher_model.dart';
import '../../shared/widgets/app_widgets.dart';

class MyVouchersScreen extends StatefulWidget {
  const MyVouchersScreen({super.key});

  @override
  State<MyVouchersScreen> createState() => _MyVouchersScreenState();
}

class _MyVouchersScreenState extends State<MyVouchersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

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

  @override
  Widget build(BuildContext context) {
    final vp = context.watch<VoucherProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Voucher Saya'),
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [Tab(text: 'Aktif'), Tab(text: 'Digunakan'), Tab(text: 'Kadaluarsa')],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _VoucherList(vouchers: vp.myVouchersByStatus(RedemptionStatus.active), status: RedemptionStatus.active),
          _VoucherList(vouchers: vp.myVouchersByStatus(RedemptionStatus.used), status: RedemptionStatus.used),
          _VoucherList(vouchers: vp.myVouchersByStatus(RedemptionStatus.expired), status: RedemptionStatus.expired),
        ],
      ),
    );
  }
}

class _VoucherList extends StatelessWidget {
  final List<RedemptionModel> vouchers;
  final RedemptionStatus status;
  const _VoucherList({required this.vouchers, required this.status});

  @override
  Widget build(BuildContext context) {
    if (vouchers.isEmpty) {
      return EmptyState(
        icon: status == RedemptionStatus.active ? Icons.card_giftcard_rounded : status == RedemptionStatus.used ? Icons.check_circle_outline_rounded : Icons.schedule_rounded,
        title: 'Tidak ada voucher',
        subtitle: status == RedemptionStatus.active ? 'Tukar poin kamu di marketplace!' : 'Belum ada voucher di kategori ini.',
        actionLabel: status == RedemptionStatus.active ? 'Ke Marketplace' : null,
        onAction: status == RedemptionStatus.active ? () => context.go('/marketplace') : null,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: vouchers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final r = vouchers[i];
        final isActive = r.status == RedemptionStatus.active;
        return GestureDetector(
          onTap: isActive ? () => context.go('/marketplace/qr/${r.id}') : null,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppShadows.card,
            ),
            child: Row(children: [
              Container(width: 56, height: 56,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primarySurface : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(child: Icon(Icons.card_giftcard_rounded, size: 28, color: AppColors.primary))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.voucherName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(r.merchant, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text('${r.status == RedemptionStatus.active ? 'Hingga' : 'Kadaluarsa'}: ${AppUtils.formatDate(r.expiresAt)}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
              ])),
              if (isActive) const Icon(Icons.qr_code_rounded, color: AppColors.primary, size: 28),
            ]),
          ),
        );
      },
    );
  }
}
