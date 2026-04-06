import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        final user = provider.user;
        if (user == null) return const SizedBox();

        return Scaffold(
          appBar: AppBar(title: const Text('Recompensas')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Puntos actuales
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.mintGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.stars_rounded,
                        color: AppColors.amber, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      '${user.totalPoints} puntos',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Niveles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...RewardLevel.levels
                  .map((level) => _RewardLevelCard(
                        level: level,
                        isUnlocked: user.totalPoints >= level.pointsRequired,
                        isCurrent: user.level == level.name,
                      )),
              const SizedBox(height: 24),
              // Tabla de puntos por residuo
              const Text(
                'Puntos por residuo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _PointsRow(
                  icon: Icons.local_drink,
                  label: 'Botella de plástico',
                  points: 15,
                  color: AppColors.binYellow),
              _PointsRow(
                  icon: Icons.circle,
                  label: 'Lata de aluminio',
                  points: 12,
                  color: AppColors.binYellow),
              _PointsRow(
                  icon: Icons.inventory_2_outlined,
                  label: 'Cartón',
                  points: 8,
                  color: AppColors.binYellow),
              _PointsRow(
                  icon: Icons.eco,
                  label: 'Restos de comida',
                  points: 5,
                  color: AppColors.binGreen),
            ],
          ),
        );
      },
    );
  }
}

class _RewardLevelCard extends StatelessWidget {
  final RewardLevel level;
  final bool isUnlocked;
  final bool isCurrent;

  const _RewardLevelCard({
    required this.level,
    required this.isUnlocked,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.primaryGreen
            : isUnlocked
                ? Colors.white
                : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: isCurrent
            ? null
            : Border.all(
                color: isUnlocked ? AppColors.primaryGreen : AppColors.divider),
      ),
      child: Row(
        children: [
          Text(level.icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isCurrent ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  level.reward,
                  style: TextStyle(
                    fontSize: 12,
                    color: isCurrent ? Colors.white70 : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isCurrent
                  ? Colors.white.withValues(alpha: 0.2)
                  : isUnlocked
                      ? AppColors.mintGreen
                      : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${level.pointsRequired} pts',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isCurrent
                    ? Colors.white
                    : isUnlocked
                        ? AppColors.primaryGreen
                        : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int points;
  final Color color;

  const _PointsRow({
    required this.icon,
    required this.label,
    required this.points,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            '+$points pts',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGreen,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
