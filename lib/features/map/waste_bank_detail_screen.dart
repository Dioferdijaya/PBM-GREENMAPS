import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/waste_bank_provider.dart';
import '../../shared/widgets/green_button.dart';
import '../../shared/widgets/app_widgets.dart';

class WasteBankDetailScreen extends StatelessWidget {
  final String bankId;
  const WasteBankDetailScreen({super.key, required this.bankId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WasteBankProvider>();
    final bank = provider.banks.firstWhere((b) => b.id == bankId,
        orElse: () => provider.banks.first);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.primary, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppGradients.primary,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Icon(Icons.account_balance_rounded, size: 72, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: bank.isOpen
                              ? AppColors.success
                              : AppColors.error,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          bank.isOpen ? '● Sedang Buka' : '● Sedang Tutup',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bank.name,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFD700), size: 18),
                      const SizedBox(width: 4),
                      Text('${bank.rating}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14)),
                      const SizedBox(width: 4),
                      Text('Rating',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Info cards
                  _InfoCard(children: [
                    _InfoRow(Icons.location_on_outlined, 'Alamat', bank.address),
                    const Divider(height: 20),
                    _InfoRow(Icons.access_time_rounded, 'Jam Operasional',
                        '${bank.openHours}\n${bank.operationalDays}'),
                    const Divider(height: 20),
                    _InfoRow(Icons.phone_outlined, 'Kontak', bank.phone),
                  ]),
                  const SizedBox(height: 16),

                  // Accepted waste types
                  const Text('Jenis Sampah Diterima',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: bank.acceptedWasteTypes.map((id) {
                      final wt = provider.wasteTypeById(id);
                      if (wt == null) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: AppColors.primaryLight.withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(wt.icon, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              '${wt.name} • ${wt.pointsPerKg.toInt()} poin/kg',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Estimated points card
                  GradientCard(
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_outline_rounded, size: 36, color: Colors.white),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Estimasi Poin',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12)),
                              const Text(
                                '15 – 50 poin / kg',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                              const Text(
                                'Tergantung jenis & kondisi sampah',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
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
        child: Row(
          children: [
            Expanded(
              child: GreenButton(
                label: 'Navigasi',
                isOutlined: true,
                icon: Icons.directions_rounded,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GreenButton(
                label: 'Setor Sampah',
                icon: Icons.recycling_rounded,
                onPressed: () => context.go('/deposit/create'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
