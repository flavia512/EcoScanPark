import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        final user = provider.user;
        if (user == null) return const SizedBox();

        return Column(
          children: [
            // Header oscuro
            Container(
              color: AppColors.darkGreen,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Mi perfil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Avatar
                    CircleAvatar(
                      radius: 36,
                      backgroundColor:
                          Colors.white.withValues(alpha: 0.15),
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${user.levelEmoji} ${user.level}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Siguiente nivel: ${user.nextLevelPoints} pts',
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Stats
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                      value: '${user.visits}',
                      label: 'Visitas',
                      icon: Icons.location_on_outlined),
                  _divider(),
                  _StatItem(
                      value: '${user.history.length}',
                      label: 'Escaneos',
                      icon: Icons.qr_code_scanner_outlined),
                  _divider(),
                  _StatItem(
                      value: '${user.facilities}',
                      label: 'Facilidades',
                      icon: Icons.star_outline),
                ],
              ),
            ),

            // Contenido
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  // Canjear puntos
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/redeem'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.card_giftcard,
                              color: Colors.white, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Canjear mis puntos',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Tienes ${user.totalPoints} puntos disponibles',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              color: Colors.white70),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Menu opciones
                  _ProfileOption(
                    icon: Icons.emoji_events_outlined,
                    label: 'Mis recompensas',
                    subtitle: 'Niveles y beneficios',
                    onTap: () => Navigator.pushNamed(context, '/rewards'),
                  ),
                  _ProfileOption(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Mis canjes',
                    subtitle: user.redeemedRewards.isEmpty
                        ? 'No has canjeado nada aún'
                        : '${user.redeemedRewards.length} canje(s) realizados',
                    onTap: () =>
                        Navigator.pushNamed(context, '/my_redemptions'),
                  ),
                  _ProfileOption(
                    icon: Icons.history,
                    label: 'Historial de escaneos',
                    subtitle: 'Actividad reciente',
                    onTap: () => Navigator.pushNamed(context, '/history'),
                  ),
                  _ProfileOption(
                    icon: Icons.qr_code_2,
                    label: 'Mi código QR',
                    subtitle: 'Comparte o accede con tu código',
                    onTap: () => Navigator.pushNamed(context, '/qr'),
                  ),
                  _ProfileOption(
                    icon: Icons.info_outline,
                    label: 'Cómo funciona',
                    subtitle: 'Guía completa de la app',
                    onTap: () => Navigator.pushNamed(context, '/how_it_works'),
                  ),
                  _ProfileOption(
                    icon: Icons.science_outlined,
                    label: 'Códigos de prueba',
                    subtitle: 'QRs para testear el escáner',
                    onTap: () => Navigator.pushNamed(context, '/test_codes'),
                  ),

                  const SizedBox(height: 28),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        provider.logout();
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (_) => false);
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Cerrar sesión',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 36,
        color: AppColors.divider,
      );
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem(
      {required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
              fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.sageBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Icon(icon, color: AppColors.primaryGreen, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
