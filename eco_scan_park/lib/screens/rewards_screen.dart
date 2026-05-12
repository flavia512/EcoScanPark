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

        return Column(
          children: [
            // Header estilo Figma
            Container(
              color: AppColors.darkGreen,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                  child: const Text(
                    'Mis recompensas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Contenido
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                children: [
                  _buildBalanceCard(user),
                  const SizedBox(height: 24),
                  _buildLevelsSection(context, user),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBalanceCard(UserModel user) {
    final nextLevel = RewardLevel.levels.firstWhere(
      (l) => user.totalPoints < l.pointsRequired,
      orElse: () => RewardLevel.levels.last,
    );
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SALDO DE PUNTOS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${user.totalPoints} puntos',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            user.totalPoints == 0
                ? 'Empieza a reciclar y gana tus primeros puntos!'
                : '¡Sigue reciclando para ganar más puntos!',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          // Progreso nivel actual
          Row(
            children: [
              Text(
                '${user.levelEmoji} Nivel: ',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                user.level,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen),
              ),
              const Spacer(),
              Text(
                '${user.totalPoints}/${nextLevel.pointsRequired} pts',
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: user.levelProgress.clamp(0.0, 1.0),
              backgroundColor: AppColors.divider,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelsSection(BuildContext context, UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Niveles de Recompensa',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/redeem'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: const Text(
                'Canjear →',
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...RewardLevel.levels.map((level) {
          final isUnlocked = user.totalPoints >= level.pointsRequired;
          final isCurrent = user.level == level.name;
          return _LevelCard(
            level: level,
            isUnlocked: isUnlocked,
            isCurrent: isCurrent,
          );
        }),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  final RewardLevel level;
  final bool isUnlocked;
  final bool isCurrent;

  const _LevelCard({
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
        color: isCurrent ? AppColors.darkGreen : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCurrent
            ? null
            : Border.all(
                color:
                    isUnlocked ? AppColors.primaryGreen : AppColors.divider),
      ),
      child: Row(
        children: [
          Text(level.icon, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isCurrent ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  level.reward,
                  style: TextStyle(
                    fontSize: 12,
                    color: isCurrent
                        ? Colors.white70
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: isCurrent
                  ? Colors.white.withValues(alpha: 0.18)
                  : isUnlocked
                      ? AppColors.mintGreen
                      : AppColors.divider,
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
