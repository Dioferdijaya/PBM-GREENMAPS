import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/deposit_model.dart';
import '../../providers/deposit_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class DepositDetailScreen extends StatelessWidget {
  final String depositId;
  const DepositDetailScreen({super.key, required this.depositId});

  @override
  Widget build(BuildContext context) {
    final deposit = context.watch<DepositProvider>().getById(depositId);
    if (deposit == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Setoran')),
        body: const EmptyState(
            icon: Icons.help_outline_rounded, title: 'Setoran tidak ditemukan', subtitle: ''),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Detail Setoran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner
            GradientCard(
              colors: _gradientColors(deposit.status),
              child: Row(
                children: [
                  const Icon(Icons.recycling_rounded, size: 40, color: Colors.white),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Status Setoran',
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text(deposit.status.label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                      if (deposit.pointsEarned != null)
                        Text('+${deposit.pointsEarned} poin diperoleh',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stepper
            _buildStepper(deposit),
            const SizedBox(height: 20),

            // Details
            _SectionCard(title: 'Informasi Setoran', children: [
              _DetailRow('Jenis Sampah', deposit.wasteTypeName),
              _DetailRow('Bank Sampah', deposit.wasteBankName),
              _DetailRow('Estimasi Berat', '${deposit.estimatedWeight} Kg'),
              if (deposit.actualWeight != null)
                _DetailRow('Berat Aktual', '${deposit.actualWeight} Kg'),
              _DetailRow('Tanggal Setor', AppUtils.formatDateTime(deposit.createdAt)),
              if (deposit.processedAt != null)
                _DetailRow('Tanggal Diproses',
                    AppUtils.formatDateTime(deposit.processedAt!)),
            ]),

            if (deposit.pointsEarned != null) ...[
              const SizedBox(height: 16),
              _SectionCard(title: 'Poin Diperoleh', children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('⭐', style: TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Text(
                      '+${deposit.pointsEarned} Poin',
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary),
                    ),
                  ],
                ),
              ]),
            ],

            if (deposit.adminNote != null && deposit.adminNote!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _SectionCard(title: 'Catatan Admin', children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.sticky_note_2_outlined,
                        color: AppColors.textSecondary, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(deposit.adminNote!,
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
                    ),
                  ],
                ),
              ]),
            ],
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  List<Color> _gradientColors(DepositStatus status) {
    switch (status.toString()) {
      case 'DepositStatus.accepted':
        return [const Color(0xFF2E7D32), const Color(0xFF43A047)];
      case 'DepositStatus.rejected':
        return [const Color(0xFFC62828), const Color(0xFFE53935)];
      case 'DepositStatus.processing':
        return [const Color(0xFF1565C0), const Color(0xFF1E88E5)];
      default:
        return [const Color(0xFFE65100), const Color(0xFFEF6C00)];
    }
  }

  Widget _buildStepper(DepositModel deposit) {
    final steps = [
      {'label': 'Terkirim', 'icon': Icons.send_rounded, 'done': true},
      {'label': 'Diproses', 'icon': Icons.hourglass_empty_rounded,
        'done': deposit.status != DepositStatus.pending},
      {'label': deposit.status == DepositStatus.rejected ? 'Ditolak' : 'Diterima',
        'icon': deposit.status == DepositStatus.rejected
            ? Icons.cancel_rounded
            : Icons.check_circle_rounded,
        'done': deposit.status == DepositStatus.accepted ||
            deposit.status == DepositStatus.rejected},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: steps.asMap().entries.expand((e) {
          final step = e.value;
          final widgets = <Widget>[
            Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: (step['done'] as bool)
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(step['icon'] as IconData,
                      size: 18,
                      color: (step['done'] as bool)
                          ? Colors.white
                          : AppColors.textHint),
                ),
                const SizedBox(height: 6),
                Text(step['label'] as String,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: (step['done'] as bool)
                            ? AppColors.primary
                            : AppColors.textHint)),
              ],
            ),
          ];
          if (e.key < steps.length - 1) {
            widgets.add(Expanded(
              child: Container(
                  height: 2,
                  margin: const EdgeInsets.only(bottom: 18),
                  color: (step['done'] as bool)
                      ? AppColors.primary
                      : AppColors.surfaceVariant),
            ));
          }
          return widgets;
        }).toList(),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2,
              child: Text(label,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
          Expanded(flex: 3,
              child: Text(value,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
