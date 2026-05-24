import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'home_screen.dart';
import 'scanner_screen.dart';
import 'rewards_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Índice para los tabs NO-scanner en su propio IndexedStack
  // tab 0=Home(0), tab 2=Recompensas(1), tab 3=Perfil(2)
  int get _nonScannerIndex {
    if (_selectedIndex == 2) return 1;
    if (_selectedIndex == 3) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sageBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Home, Recompensas y Perfil: persisten en IndexedStack
          Offstage(
            offstage: _selectedIndex == 1,
            child: IndexedStack(
              index: _nonScannerIndex,
              children: const [HomeScreen(), RewardsScreen(), ProfileScreen()],
            ),
          ),
          // Scanner: solo existe cuando el tab está activo
          // → se crea al entrar (cámara ON) y se destruye al salir (cámara OFF)
          if (_selectedIndex == 1) const ScannerScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: const Color(0xFFB0B8B0),
          backgroundColor: Colors.white,
          elevation: 0,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner_outlined),
              activeIcon: Icon(Icons.qr_code_scanner),
              label: 'Escanear',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard_outlined),
              activeIcon: Icon(Icons.card_giftcard),
              label: 'Recompensas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
