import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/voucher_provider.dart';

// User screens
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/home_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/map/waste_bank_detail_screen.dart';
import '../../features/deposit/create_deposit_screen.dart';
import '../../features/deposit/deposit_history_screen.dart';
import '../../features/deposit/deposit_detail_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import '../../features/wallet/point_history_screen.dart';
import '../../features/marketplace/marketplace_screen.dart';
import '../../features/marketplace/voucher_detail_screen.dart';
import '../../features/marketplace/my_vouchers_screen.dart';
import '../../features/marketplace/qr_voucher_screen.dart';
import '../../features/education/education_screen.dart';
import '../../features/education/article_detail_screen.dart';
import '../../features/achievement/achievement_screen.dart';
import '../../features/leaderboard/leaderboard_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/settings/settings_screen.dart';

// Admin screens
import '../../features/admin/admin_shell.dart';
import '../../features/admin/admin_dashboard_screen.dart';
import '../../features/admin/deposit_verification_screen.dart';
import '../../features/admin/admin_deposit_detail_screen.dart';
import '../../features/admin/admin_voucher_screen.dart';
import '../../features/admin/super_admin_banks_screen.dart';
import '../../features/admin/create_voucher_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _userShellKey = GlobalKey<NavigatorState>();
final _adminShellKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final loggedIn = authProvider.isLoggedIn;
      final isAdmin = authProvider.isAdmin;
      final loc = state.matchedLocation;

      final isAuthRoute = loc == '/login' || loc == '/register' || loc == '/onboarding';
      final isSplash = loc == '/splash';

      if (isSplash) return null;
      if (!loggedIn && !isAuthRoute) return '/login';
      if (loggedIn && isAuthRoute) {
        return isAdmin ? '/admin/dashboard' : '/home';
      }
      if (loggedIn && isAdmin && loc.startsWith('/home')) return '/admin/dashboard';
      if (loggedIn && !isAdmin && loc.startsWith('/admin')) return '/home';

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),

      // ── User Shell ──────────────────────────────────────
      ShellRoute(
        navigatorKey: _userShellKey,
        builder: (_, __, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) => const HomeScreen(),
            routes: [
              GoRoute(path: 'achievements', builder: (_, __) => const AchievementScreen()),
              GoRoute(path: 'leaderboard', builder: (_, __) => const LeaderboardScreen()),
            ],
          ),
          GoRoute(
            path: '/map',
            builder: (_, __) => const MapScreen(),
            routes: [
              GoRoute(
                path: 'bank/:id',
                builder: (_, state) => WasteBankDetailScreen(bankId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/deposit',
            builder: (_, __) => const DepositHistoryScreen(),
            routes: [
              GoRoute(path: 'create', builder: (_, __) => const CreateDepositScreen()),
              GoRoute(
                path: 'detail/:id',
                builder: (_, state) => DepositDetailScreen(depositId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/wallet',
            builder: (_, __) => const WalletScreen(),
            routes: [
              GoRoute(path: 'history', builder: (_, __) => const PointHistoryScreen()),
            ],
          ),
          GoRoute(
            path: '/marketplace',
            builder: (_, __) => const MarketplaceScreen(),
            routes: [
              GoRoute(
                path: 'voucher/:id',
                builder: (_, state) => VoucherDetailScreen(voucherId: state.pathParameters['id']!),
              ),
              GoRoute(path: 'my-vouchers', builder: (_, __) => const MyVouchersScreen()),
              GoRoute(
                path: 'qr/:id',
                builder: (_, state) => QrVoucherScreen(redemptionId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/education',
            builder: (_, __) => const EducationScreen(),
            routes: [
              GoRoute(
                path: 'article/:id',
                builder: (_, state) => ArticleDetailScreen(articleId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),

      // ── Admin Shell ─────────────────────────────────────
      ShellRoute(
        navigatorKey: _adminShellKey,
        builder: (_, __, child) => AdminShell(child: child),
        routes: [
          GoRoute(path: '/admin/dashboard', builder: (_, __) => const AdminDashboardScreen()),
          GoRoute(
            path: '/admin/verification',
            builder: (_, __) => const DepositVerificationScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, state) => AdminDepositDetailScreen(depositId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/admin/vouchers',
            builder: (_, __) => const AdminVoucherScreen(),
          ),
          GoRoute(path: '/admin/banks', builder: (_, __) => const SuperAdminBanksScreen()),
          GoRoute(path: '/admin/profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),
      
      // Full screen admin routes
      GoRoute(
        path: '/admin/vouchers/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const CreateVoucherScreen(),
      ),
      GoRoute(
        path: '/admin/vouchers/edit/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) {
          return _EditVoucherWrapper(voucherId: state.pathParameters['id']!);
        },
      ),
    ],
  );
}

// Wrapper to fetch VoucherModel and pass to CreateVoucherScreen in edit mode
class _EditVoucherWrapper extends StatelessWidget {
  final String voucherId;
  const _EditVoucherWrapper({required this.voucherId});

  @override
  Widget build(BuildContext context) {
    final vp = context.read<VoucherProvider>();
    final voucher = vp.getById(voucherId);
    if (voucher == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Voucher tidak ditemukan')),
      );
    }
    return CreateVoucherScreen(editVoucher: voucher);
  }
}
