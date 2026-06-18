import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/voucher_provider.dart';
import '../../data/models/voucher_model.dart';
import '../../shared/widgets/app_widgets.dart';

class QrVoucherScreen extends StatelessWidget {
  final String redemptionId;
  const QrVoucherScreen({super.key, required this.redemptionId});

  @override
  Widget build(BuildContext context) {
    final r = context.watch<VoucherProvider>().getRedemptionById(redemptionId);
    if (r == null) {
      return Scaffold(appBar: AppBar(), body: const EmptyState(icon: Icons.help_outline_rounded, title: 'Voucher tidak ditemukan', subtitle: ''));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.go('/marketplace/my-vouchers'), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text('QR Voucher'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: r.status == RedemptionStatus.active ? AppColors.success.withOpacity(0.1) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: r.status == RedemptionStatus.active ? AppColors.success.withOpacity(0.4) : Colors.grey.shade300),
                  ),
                  child: Text(
                    r.status == RedemptionStatus.active ? '● Voucher Aktif' : r.status == RedemptionStatus.used ? 'Sudah Digunakan' : 'Kadaluarsa',
                    style: TextStyle(
                      color: r.status == RedemptionStatus.active ? AppColors.success : AppColors.textSecondary,
                      fontWeight: FontWeight.w600, fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // QR Card
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppShadows.elevated,
                  ),
                  child: Column(
                    children: [
                      Text(r.voucherName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                      Text(r.merchant, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                      const SizedBox(height: 20),
                      // QR Code
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryLight.withOpacity(0.3)),
                        ),
                        child: QrImageView(
                          data: r.uniqueCode,
                          version: QrVersions.auto,
                          size: 200,
                          foregroundColor: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Code
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          r.uniqueCode,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 2, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Expiry
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text('Berlaku hingga ${AppUtils.formatDate(r.expiresAt)}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryLight.withOpacity(0.3))),
                  child: const Column(children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 18),
                      SizedBox(width: 10),
                      Expanded(child: Text('Tunjukkan QR code ini kepada kasir atau petugas di merchant terkait.',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5))),
                    ]),
                  ]),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => context.go('/marketplace/my-vouchers'),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Kembali ke Voucherku'),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
