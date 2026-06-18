import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/deposit_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/deposit_provider.dart';
import '../../shared/widgets/app_widgets.dart';

class DepositVerificationScreen extends StatefulWidget {
  const DepositVerificationScreen({super.key});

  @override
  State<DepositVerificationScreen> createState() => _DepositVerificationScreenState();
}

class _DepositVerificationScreenState extends State<DepositVerificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final dp = context.watch<DepositProvider>();
    
    var allDeposits = dp.deposits;
    if (auth.isAdminBank) {
      allDeposits = allDeposits.where((d) => d.wasteBankId == auth.currentUser?.wasteBankId).toList();
    }
    
    final pending = allDeposits.where((d) => d.status == DepositStatus.pending).toList();
    final processing = allDeposits.where((d) => d.status == DepositStatus.processing).toList();
    final completed = allDeposits.where((d) => d.status == DepositStatus.accepted || d.status == DepositStatus.rejected).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Setoran'),
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: 'Menunggu (${pending.length})'),
            Tab(text: 'Diproses (${processing.length})'),
            const Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _DepositList(deposits: pending, emptyMsg: 'Tidak ada setoran baru'),
          _DepositList(deposits: processing, emptyMsg: 'Tidak ada setoran diproses'),
          _DepositList(deposits: completed, emptyMsg: 'Belum ada riwayat'),
        ],
      ),
    );
  }
}

class _DepositList extends StatelessWidget {
  final List<DepositModel> deposits;
  final String emptyMsg;
  const _DepositList({required this.deposits, required this.emptyMsg});

  @override
  Widget build(BuildContext context) {
    if (deposits.isEmpty) return Center(child: Text(emptyMsg, style: const TextStyle(color: AppColors.textSecondary)));
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: deposits.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final d = deposits[i];
        return GestureDetector(
          onTap: () => context.go('/admin/verification/${d.id}'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.card),
            child: Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Icon(Icons.recycling_rounded, size: 22, color: AppColors.primary))),
            const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(d.wasteTypeName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                Text('${d.estimatedWeight} Kg • Bank: ${d.wasteBankName}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(AppUtils.formatDateTime(d.createdAt), style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
              ])),
              StatusBadge(status: d.status),
            ]),
          ),
        );
      },
    );
  }
}
