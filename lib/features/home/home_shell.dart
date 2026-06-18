import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class HomeShell extends StatelessWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  int _selectedIndex(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc.startsWith('/home')) return 0;
    if (loc.startsWith('/map')) return 1;
    if (loc.startsWith('/deposit')) return 2;
    if (loc.startsWith('/wallet')) return 3;
    if (loc.startsWith('/marketplace')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _selectedIndex(context);
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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: idx,
            onTap: (i) {
              switch (i) {
                case 0: context.go('/home'); break;
                case 1: context.go('/map'); break;
                case 2: context.go('/deposit'); break;
                case 3: context.go('/wallet'); break;
                case 4: context.go('/marketplace'); break;
              }
            },
            items: [
              _navItem(Icons.home_rounded, Icons.home_outlined, 'Beranda', idx == 0),
              _navItem(Icons.map_rounded, Icons.map_outlined, 'Peta', idx == 1),
              _navItem(Icons.recycling_rounded, Icons.recycling_outlined, 'Setor', idx == 2),
              _navItem(Icons.account_balance_wallet_rounded,
                  Icons.account_balance_wallet_outlined, 'Dompet', idx == 3),
              _navItem(Icons.local_offer_rounded, Icons.local_offer_outlined,
                  'Voucher', idx == 4),
            ],
          ),
        ),
      ),
      // Floating center setor button
      floatingActionButton: idx == 2
          ? null
          : FloatingActionButton(
              onPressed: () => context.go('/deposit/create'),
              backgroundColor: AppColors.primary,
              elevation: 6,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.button,
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
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
