import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/deposit_provider.dart';
import 'providers/voucher_provider.dart';
import 'providers/wallet_provider.dart';
import 'providers/waste_bank_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const GreenMapApp());
}

class GreenMapApp extends StatelessWidget {
  const GreenMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => DepositProvider()),
        ChangeNotifierProvider(create: (_) => VoucherProvider()),
        // WalletProvider auto-syncs with AuthProvider via ProxyProvider
        ChangeNotifierProxyProvider<AuthProvider, WalletProvider>(
          create: (_) => WalletProvider(),
          update: (_, auth, wallet) {
            final walletInstance = wallet ?? WalletProvider();
            final user = auth.currentUser;
            // Defer to avoid calling notifyListeners() during build phase
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (user != null) {
                walletInstance.initForUser(user.id, user.totalPoints);
              } else {
                walletInstance.initForUser('', 0);
              }
            });
            return walletInstance;
          },
        ),
        ChangeNotifierProvider(create: (_) => WasteBankProvider()),
      ],
      child: Builder(
        builder: (context) {
          final authProvider = context.watch<AuthProvider>();
          final router = createRouter(authProvider);
          return MaterialApp.router(
            title: 'GreenMap',
            theme: AppTheme.lightTheme,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
