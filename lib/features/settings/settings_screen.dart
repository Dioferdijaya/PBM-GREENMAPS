import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../shared/widgets/green_text_field.dart';
import '../../shared/widgets/green_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifDeposit = true;
  bool _notifVoucher = true;
  bool _notifNews = false;
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();

  @override
  void dispose() { _oldPassCtrl.dispose(); _newPassCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => context.pop()),
        title: const Text('Pengaturan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle('Keamanan'),
            const SizedBox(height: 10),
            _Card(child: Column(children: [
              const Padding(padding: EdgeInsets.only(bottom: 14),
                  child: Text('Ubah Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
              GreenTextField(label: 'Password Lama', controller: _oldPassCtrl, isPassword: true, prefixIcon: Icons.lock_outline_rounded),
              const SizedBox(height: 12),
              GreenTextField(label: 'Password Baru', controller: _newPassCtrl, isPassword: true, prefixIcon: Icons.lock_rounded),
              const SizedBox(height: 16),
              GreenButton(label: 'Simpan Password', width: double.infinity, onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password berhasil diubah'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
                _oldPassCtrl.clear(); _newPassCtrl.clear();
              }),
            ])),
            const SizedBox(height: 20),
            _SectionTitle('Notifikasi'),
            const SizedBox(height: 10),
            _Card(child: Column(children: [
              _SwitchTile('Notifikasi Setoran', 'Update status setoran sampah', _notifDeposit, (v) => setState(() => _notifDeposit = v)),
              const Divider(height: 1),
              _SwitchTile('Promo Voucher', 'Info voucher & penawaran baru', _notifVoucher, (v) => setState(() => _notifVoucher = v)),
              const Divider(height: 1),
              _SwitchTile('Berita Lingkungan', 'Artikel & event lingkungan', _notifNews, (v) => setState(() => _notifNews = v)),
            ])),
            const SizedBox(height: 20),
            _SectionTitle('Tentang Aplikasi'),
            const SizedBox(height: 10),
            _Card(child: Column(children: [
              _InfoTile(Icons.info_outline_rounded, 'Versi Aplikasi', '1.0.0'),
              const Divider(height: 1),
              _InfoTile(Icons.description_outlined, 'Syarat & Ketentuan', ''),
              const Divider(height: 1),
              _InfoTile(Icons.privacy_tip_outlined, 'Kebijakan Privasi', ''),
              const Divider(height: 1),
              _InfoTile(Icons.support_agent_rounded, 'Hubungi Kami', 'support@greenmap.id'),
            ])),
            const SizedBox(height: 20),
            _Card(child: InkWell(
              onTap: () async {
                await context.read<AuthProvider>().logout();
                if (context.mounted) context.go('/login');
              },
              borderRadius: BorderRadius.circular(16),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.logout_rounded, color: AppColors.error),
                  SizedBox(width: 10),
                  Text('Keluar dari Akun', style: TextStyle(color: AppColors.error, fontSize: 15, fontWeight: FontWeight.w700)),
                ]),
              ),
            )),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary));
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), boxShadow: AppShadows.card),
    child: child,
  );
}

class _SwitchTile extends StatelessWidget {
  final String title, subtitle; final bool value; final ValueChanged<bool> onChanged;
  const _SwitchTile(this.title, this.subtitle, this.value, this.onChanged);
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
    trailing: Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
  );
}

class _InfoTile extends StatelessWidget {
  final IconData icon; final String title, subtitle;
  const _InfoTile(this.icon, this.title, this.subtitle);
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: AppColors.textSecondary, size: 20),
    title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)) : null,
    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
  );
}
