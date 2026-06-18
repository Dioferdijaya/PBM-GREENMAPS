import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../shared/widgets/green_button.dart';
import '../../shared/widgets/green_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (success) {
      if (auth.currentUser != null) {
        context.read<WalletProvider>().initForUser(
          auth.currentUser!.id,
          auth.currentUser!.totalPoints,
        );
      }
      context.go(auth.isAdmin ? '/admin/dashboard' : '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Login gagal'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: Stack(
        children: [
          // Top gradient header
          Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: AppGradients.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: AppShadows.elevated,
                            ),
                            child: const Center(
                              child: Text('🌿', style: TextStyle(fontSize: 38)),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text('GreenMap',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1)),
                          const SizedBox(height: 4),
                          Text('Selamat datang kembali!',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Form card
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: AppShadows.elevated,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Masuk',
                                    style: Theme.of(context).textTheme.headlineSmall),
                                const SizedBox(height: 4),
                                Text('Masukkan kredensial akun kamu',
                                    style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 24),
                                GreenTextField(
                                  label: 'Email',
                                  hint: 'contoh@email.com',
                                  controller: _emailCtrl,
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'Email wajib diisi';
                                    if (!v.contains('@')) return 'Format email tidak valid';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                GreenTextField(
                                  label: 'Password',
                                  hint: 'Masukkan password',
                                  controller: _passCtrl,
                                  prefixIcon: Icons.lock_outline_rounded,
                                  isPassword: true,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'Password wajib diisi';
                                    if (v.length < 6) return 'Password minimal 6 karakter';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text('Lupa Password?',
                                        style: TextStyle(
                                            color: AppColors.primary, fontSize: 13)),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GreenButton(
                                  label: 'Masuk',
                                  onPressed: _login,
                                  isLoading: auth.isLoading,
                                  width: double.infinity,
                                ),
                                const SizedBox(height: 20),
                                // Divider
                                Row(children: [
                                  const Expanded(child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text('atau',
                                        style: Theme.of(context).textTheme.bodySmall),
                                  ),
                                  const Expanded(child: Divider()),
                                ]),
                                const SizedBox(height: 20),
                                // Google sign in
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Text('G',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF4285F4))),
                                  label: const Text('Masuk dengan Google'),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 52),
                                    side: const BorderSide(color: Color(0xFFE0E0E0)),
                                    foregroundColor: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Register link
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Belum punya akun? ',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                        GestureDetector(
                          onTap: () => context.go('/register'),
                          child: const Text('Daftar Sekarang',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Demo hint
                  _DemoCredentials(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoCredentials extends StatefulWidget {
  @override
  State<_DemoCredentials> createState() => _DemoCredentialsState();
}

class _DemoCredentialsState extends State<_DemoCredentials> {
  bool _expanded = false;

  static const _accounts = [
    _Account(Icons.person_rounded, 'User', 'eja@greenmap.id', 'user123', Color(0xFF1565C0)),
    _Account(Icons.admin_panel_settings_rounded, 'Super Admin', 'superadmin@greenmap.id', 'admin123', Color(0xFF6A1B9A)),
    _Account(Icons.account_balance_rounded, 'Admin Bank Syiah Kuala', 'admin1@greenmap.id', 'admin123', Color(0xFF00796B)),
    _Account(Icons.account_balance_rounded, 'Admin Bank Baiturrahman', 'admin2@greenmap.id', 'admin123', Color(0xFF00796B)),
    _Account(Icons.account_balance_rounded, 'Admin Bank Darussalam', 'admin3@greenmap.id', 'admin123', Color(0xFF00796B)),
    _Account(Icons.account_balance_rounded, 'Admin Bank Peukan Bada', 'admin4@greenmap.id', 'admin123', Color(0xFF00796B)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryLight.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.key_rounded, color: AppColors.primary, size: 16),
                  const SizedBox(width: 8),
                  const Text('Demo Credentials',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                  const Spacer(),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1, color: Color(0xFFB2DFDB)),
            ...List.generate(_accounts.length, (i) {
              final a = _accounts[i];
              return GestureDetector(
                onTap: () {
                  // Auto-fill email when tapped (just show it)
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Email: ${a.email}  •  Pass: ${a.password}'),
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: a.color,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    border: i < _accounts.length - 1
                        ? const Border(
                            bottom: BorderSide(color: Color(0xFFE0F2F1)))
                        : const Border(),
                    borderRadius: i == _accounts.length - 1
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(14),
                            bottomRight: Radius.circular(14),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: a.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(a.icon, size: 14, color: a.color),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.label,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: a.color)),
                            Text(a.email,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: a.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(a.password,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: a.color,
                                fontFamily: 'monospace')),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _Account {
  final IconData icon;
  final String label;
  final String email;
  final String password;
  final Color color;
  const _Account(this.icon, this.label, this.email, this.password, this.color);
}
