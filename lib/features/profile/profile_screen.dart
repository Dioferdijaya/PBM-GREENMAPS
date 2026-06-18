import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/green_button.dart';
import '../../shared/widgets/green_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editing = false;
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() { _nameCtrl.dispose(); _phoneCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.primary,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32))),
              child: SafeArea(bottom: false, child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Column(children: [
                  Row(children: [
                    const Text('Profil Saya', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _editing = !_editing),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        child: Icon(_editing ? Icons.close_rounded : Icons.edit_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 88, height: 88,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3),
                            color: Colors.white.withOpacity(0.2)),
                        child: Center(child: Text(user.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800))),
                      ),
                      if (_editing)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt_rounded, color: AppColors.primary, size: 16),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  Text(user.email, style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 13)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(50)),
                    child: Text(user.role == 'admin' ? '🔧 Admin' : '👤 User',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ]),
              )),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                // Stats
                Row(children: [
                  _StatChip('${user.totalPoints}', 'Poin'),
                  const SizedBox(width: 10),
                  _StatChip('${user.totalWasteKg} Kg', 'Sampah'),
                  const SizedBox(width: 10),
                  _StatChip('${user.depositCount}', 'Setoran'),
                ]),
                const SizedBox(height: 24),
                // Edit form or info
                if (_editing) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), boxShadow: AppShadows.card),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Edit Profil', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 16),
                      GreenTextField(label: 'Nama Lengkap', controller: _nameCtrl, prefixIcon: Icons.person_outline_rounded),
                      const SizedBox(height: 14),
                      GreenTextField(label: 'Nomor HP', controller: _phoneCtrl, prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                      const SizedBox(height: 14),
                      GreenTextField(label: 'Email', hint: user.email, prefixIcon: Icons.email_outlined, enabled: false),
                      const SizedBox(height: 20),
                      GreenButton(label: 'Simpan Perubahan', width: double.infinity, onPressed: () async {
                        await auth.updateProfile(_nameCtrl.text, _phoneCtrl.text);
                        setState(() => _editing = false);
                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profil berhasil diperbarui'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
                      }),
                    ]),
                  ),
                ] else ...[
                  _InfoCard(children: [
                    _InfoRow(Icons.person_outline_rounded, 'Nama', user.name),
                    const Divider(height: 20),
                    _InfoRow(Icons.email_outlined, 'Email', user.email),
                    const Divider(height: 20),
                    _InfoRow(Icons.phone_outlined, 'Nomor HP', user.phone),
                    const Divider(height: 20),
                    _InfoRow(Icons.calendar_today_outlined, 'Bergabung', '15 Januari 2024'),
                  ]),
                ],
                const SizedBox(height: 16),
                // Quick links
                _MenuCard(children: [
                  _MenuItem(Icons.history_rounded, 'Riwayat Setoran', () => context.go('/deposit')),
                  _MenuItem(Icons.account_balance_wallet_rounded, 'Dompet Poin', () => context.go('/wallet')),
                  _MenuItem(Icons.local_offer_rounded, 'Voucher Saya', () => context.go('/marketplace/my-vouchers')),
                  _MenuItem(Icons.emoji_events_rounded, 'Achievement', () => context.go('/home/achievements')),
                  _MenuItem(Icons.leaderboard_rounded, 'Leaderboard', () => context.go('/home/leaderboard')),
                ]),
                const SizedBox(height: 16),
                _MenuCard(children: [
                  _MenuItem(Icons.settings_outlined, 'Pengaturan', () => context.go('/settings')),
                  _MenuItem(Icons.logout_rounded, 'Keluar', () => _showLogoutDialog(context), isDestructive: true),
                ]),
                const SizedBox(height: 60),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(context: context, builder: (dialogCtx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Keluar?'),
      content: const Text('Kamu akan keluar dari akun GreenMap.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Batal')),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(dialogCtx);
            await Future.delayed(const Duration(milliseconds: 150));
            if (context.mounted) context.read<AuthProvider>().logout();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Keluar'),
        ),
      ],
    ));
  }
}

class _StatChip extends StatelessWidget {
  final String value, label;
  const _StatChip(this.value, this.label);
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.card),
    child: Column(children: [
      Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
    ]),
  ));
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), boxShadow: AppShadows.card),
    child: Column(children: children),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon; final String label, value;
  const _InfoRow(this.icon, this.label, this.value);
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.primary, size: 18)),
    const SizedBox(width: 12),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
    ]),
  ]);
}

class _MenuCard extends StatelessWidget {
  final List<Widget> children;
  const _MenuCard({required this.children});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), boxShadow: AppShadows.card),
    child: Column(children: children),
  );
}

class _MenuItem extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap; final bool isDestructive;
  const _MenuItem(this.icon, this.label, this.onTap, {this.isDestructive = false});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Icon(icon, color: isDestructive ? AppColors.error : AppColors.textSecondary, size: 20),
        const SizedBox(width: 14),
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDestructive ? AppColors.error : AppColors.textPrimary)),
        const Spacer(),
        Icon(Icons.chevron_right_rounded, color: isDestructive ? AppColors.error.withOpacity(0.5) : AppColors.textHint, size: 20),
      ]),
    ),
  );
}
