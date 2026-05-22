import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/user_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/qr_screen.dart';
import 'screens/history_screen.dart';
import 'screens/scan_result_screen.dart';
import 'screens/points_won_screen.dart';
import 'screens/redeem_screen.dart';
import 'screens/rewards_screen.dart';
import 'screens/my_redemptions_screen.dart';
import 'screens/test_codes_screen.dart';
import 'screens/how_it_works_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const EcoScanParkApp(),
    ),
  );
}

class EcoScanParkApp extends StatelessWidget {
  const EcoScanParkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoScanPark',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainScreen(),
        '/qr': (context) => const QrScreen(),
        '/history': (context) => const HistoryScreen(),
        '/scan_result': (context) => const ScanResultScreen(),
        '/points_won': (context) => const PointsWonScreen(),
        '/redeem': (context) => const RedeemScreen(),
        '/rewards': (context) => Scaffold(
          backgroundColor: AppColors.sageBackground,
          body: const RewardsScreen(),
        ),
        '/my_redemptions': (context) => const MyRedemptionsScreen(),
        '/test_codes': (context) => const TestCodesScreen(),
        '/how_it_works': (context) => const HowItWorksScreen(),
      },
    );
  }
}
