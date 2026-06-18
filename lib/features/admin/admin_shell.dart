import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class AdminShell extends StatelessWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  int _selectedIndex(BuildContext context, bool isSuperAdmin) {
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc.startsWith('/admin/dashboard')) return 0;
    if (isSuperAdmin) {
      if (loc.startsWith('/admin/banks')) return 1;
      if (loc.startsWith('/admin/vouchers')) return 2;
      if (loc.startsWith('/admin/profile')) return 3;
    } else {
      if (loc.startsWith('/admin/verification')) return 1;
      if (loc.startsWith('/admin/profile')) return 2;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isSuperAdmin = auth.isSuperAdmin;
    final idx = _selectedIndex(context, isSuperAdmin);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: idx,
          type: BottomNavigationBarType.fixed,
          onTap: (i) {
            if (isSuperAdmin) {
              switch (i) {
                case 0: context.go('/admin/dashboard'); break;
                case 1: context.go('/admin/banks'); break;
                case 2: context.go('/admin/vouchers'); break;
                case 3: context.go('/admin/profile'); break;
              }
            } else {
              switch (i) {
                case 0: context.go('/admin/dashboard'); break;
                case 1: context.go('/admin/verification'); break;
                case 2: context.go('/admin/profile'); break;
              }
            }
          },
          items: isSuperAdmin
              ? [
                  _navItem(Icons.dashboard_rounded, Icons.dashboard_outlined, 'Dashboard', idx == 0),
                  _navItem(Icons.account_balance_rounded, Icons.account_balance_outlined, 'Bank', idx == 1),
                  _navItem(Icons.local_offer_rounded, Icons.local_offer_outlined, 'Voucher', idx == 2),
                  _navItem(Icons.person_rounded, Icons.person_outline_rounded, 'Profil', idx == 3),
                ]
              : [
                  _navItem(Icons.dashboard_rounded, Icons.dashboard_outlined, 'Dashboard', idx == 0),
                  _navItem(Icons.verified_rounded, Icons.verified_outlined, 'Verifikasi', idx == 1),
                  _navItem(Icons.person_rounded, Icons.person_outline_rounded, 'Profil', idx == 2),
                ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(
      IconData active, IconData inactive, String label, bool isSelected) {
    return BottomNavigationBarItem(
      icon: Icon(inactive, size: 24),
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(active, size: 24, color: AppColors.primary),
      ),
      label: label,
    );
  }
}
