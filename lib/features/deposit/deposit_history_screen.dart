import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/deposit_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/deposit_provider.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../shared/widgets/green_button.dart';

class DepositHistoryScreen extends StatefulWidget {
  const DepositHistoryScreen({super.key});

  @override
  State<DepositHistoryScreen> createState() => _DepositHistoryScreenState();
}

class _DepositHistoryScreenState extends State<DepositHistoryScreen> {
  DepositStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    final all = context.watch<DepositProvider>().depositsForUser(user.id);
    final filtered = _filter == null ? all : all.where((d) => d.status == _filter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Setoran'),
        actions: [
          IconButton(
            onPressed: () => context.go('/deposit/create'),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                _FilterChip(label: 'Semua', selected: _filter == null,
                    onTap: () => setState(() => _filter = null)),
                ...DepositStatus.values.map((s) => _FilterChip(
                      label: s.label,
                      selected: _filter == s,
                      onTap: () => setState(() => _filter = s),
                      color: _statusColor(s),
                    )),
              ],
            ),
          ),
          // List
          Expanded(
            child: filtered.isEmpty
                ? EmptyState(
                    icon: Icons.recycling_rounded,
                    title: 'Belum ada setoran',
                    subtitle: 'Mulai setorkan sampah kamu dan dapatkan poin menarik!',
                    actionLabel: 'Setor Sekarang',
                    onAction: () => context.go('/deposit/create'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _DepositCard(deposit: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(DepositStatus s) {
    switch (s) {
      case DepositStatus.pending: return AppColors.warning;
      case DepositStatus.processing: return AppColors.info;
      case DepositStatus.accepted: return AppColors.success;
      case DepositStatus.rejected: return AppColors.error;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({required this.label, required this.selected,
      required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? c : AppColors.surface,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: selected ? c : Colors.grey.shade200),
          boxShadow: selected ? [BoxShadow(color: c.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))] : null,
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }
}

class _DepositCard extends StatelessWidget {
  final DepositModel deposit;
  const _DepositCard({required this.deposit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/deposit/detail/${deposit.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(child: Icon(Icons.recycling_rounded, size: 26, color: AppColors.primary)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(deposit.wasteTypeName,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      StatusBadge(status: deposit.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${deposit.estimatedWeight} Kg • ${deposit.wasteBankName}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 11, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(AppUtils.formatDate(deposit.createdAt),
                          style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                      if (deposit.pointsEarned != null) ...[
                        const Spacer(),
                        Text('+${deposit.pointsEarned} poin',
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
