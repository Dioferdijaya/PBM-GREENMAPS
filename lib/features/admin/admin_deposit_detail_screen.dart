import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/deposit_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/deposit_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../shared/widgets/green_button.dart';
import '../../shared/widgets/green_text_field.dart';

class AdminDepositDetailScreen extends StatefulWidget {
  final String depositId;
  const AdminDepositDetailScreen({super.key, required this.depositId});

  @override
  State<AdminDepositDetailScreen> createState() => _AdminDepositDetailScreenState();
}

class _AdminDepositDetailScreenState extends State<AdminDepositDetailScreen> {
  final _actualWeightCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void dispose() { _actualWeightCtrl.dispose(); _noteCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final dp = context.watch<DepositProvider>();
    final deposit = dp.getById(widget.depositId);
    if (deposit == null) return Scaffold(appBar: AppBar(), body: const Center(child: Text('Not found')));

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Verifikasi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.card),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _RowInfo('User ID', deposit.userId),
              const Divider(),
              _RowInfo('Jenis Sampah', deposit.wasteTypeName),
              const Divider(),
              _RowInfo('Bank Tujuan', deposit.wasteBankName),
              const Divider(),
              _RowInfo('Estimasi Berat', '${deposit.estimatedWeight} Kg'),
              const Divider(),
              _RowInfo('Tanggal Dibuat', AppUtils.formatDateTime(deposit.createdAt)),
              const Divider(),
              _RowInfo('Status', deposit.status.label),
            ]),
          ),
          const SizedBox(height: 24),
          
          if (deposit.status == DepositStatus.pending) ...[
            GreenButton(label: 'Proses Setoran', width: double.infinity, onPressed: () async {
              await dp.updateDepositStatus(deposit.id, DepositStatus.processing);
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Status diubah ke diproses')));
            }),
          ] else if (deposit.status == DepositStatus.processing) ...[
            const Text('Verifikasi Final', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            GreenTextField(label: 'Berat Aktual (Kg)', controller: _actualWeightCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            const SizedBox(height: 12),
            GreenTextField(label: 'Catatan Admin (Opsional)', controller: _noteCtrl, maxLines: 3),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(child: GreenButton(label: 'Tolak', color: AppColors.error, onPressed: () async {
                await dp.updateDepositStatus(deposit.id, DepositStatus.rejected, adminNote: _noteCtrl.text.isNotEmpty ? _noteCtrl.text : 'Setoran ditolak.');
                if (context.mounted) context.pop();
              })),
              const SizedBox(width: 12),
              Expanded(child: GreenButton(label: 'Terima & Beri Poin', onPressed: () async {
                final w = double.tryParse(_actualWeightCtrl.text);
                if (w == null || w <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan berat aktual yang valid'), backgroundColor: AppColors.error));
                  return;
                }
                
                await dp.updateDepositStatus(deposit.id, DepositStatus.accepted, actualWeight: w, adminNote: _noteCtrl.text);
                
                if (context.mounted) {
                  // Fetch the updated deposit to get points
                  final updatedDeposit = dp.getById(deposit.id);
                  if (updatedDeposit != null && updatedDeposit.pointsEarned != null) {
                    final points = updatedDeposit.pointsEarned!;
                    
                    // Update Wallet Transaction
                    await context.read<WalletProvider>().earnPoints(
                      points,
                      'Setoran Sampah: ${updatedDeposit.wasteTypeName}',
                      updatedDeposit.id,
                      updatedDeposit.userId,
                    );
                    
                    // Update User's Total Points and Waste
                    context.read<AuthProvider>().addPointsAndWaste(updatedDeposit.userId, points, w);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Setoran diverifikasi dan poin diberikan!'), backgroundColor: AppColors.success));
                  context.pop();
                }
              })),
            ]),
          ] else ...[
            // Finished
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: deposit.status == DepositStatus.accepted ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Selesai', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: deposit.status == DepositStatus.accepted ? AppColors.success : AppColors.error)),
                const SizedBox(height: 8),
                if (deposit.actualWeight != null) Text('Berat Aktual: ${deposit.actualWeight} Kg'),
                if (deposit.pointsEarned != null) Text('Poin Diberikan: ${deposit.pointsEarned}'),
                if (deposit.adminNote != null) Text('Catatan: ${deposit.adminNote}'),
              ]),
            ),
          ],
        ]),
      ),
    );
  }
}

class _RowInfo extends StatelessWidget {
  final String label, value;
  const _RowInfo(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(flex: 2, child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
      Expanded(flex: 3, child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
    ]),
  );
}
