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
            // Header
            Container(
              color: AppColors.darkGreen,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                  child: Row(
                    children: [
                      if (Navigator.canPop(context))
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Padding(
                            padding: EdgeInsets.only(right: 14),
                            child: Icon(Icons.arrow_back_ios_new,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      const Text(
                        'Mis recompensas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                children: [
                  _BalanceCard(user: user),
                  const SizedBox(height: 28),
                  _LevelsSection(
                    user: user,
                    onRedeem: () => Navigator.pushNamed(context, '/redeem'),
                  ),
                  const SizedBox(height: 28),
                  const _GainPointsSection(),
                  const SizedBox(height: 16),
                  const _TipCard(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// Balance Card
class _BalanceCard extends StatelessWidget {
  final UserModel user;
  const _BalanceCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final nextLevel = RewardLevel.levels.firstWhere(
      (l) => user.totalPoints < l.pointsRequired,
      orElse: () => RewardLevel.levels.last,
    );
    final progress = user.levelProgress.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.star_rounded, color: AppColors.amber, size: 16),
              SizedBox(width: 6),
              Text(
                'SALDO DE PUNTOS',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${user.totalPoints}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                const TextSpan(
                  text: ' puntos',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            user.totalPoints == 0
                ? '!Empieza a reciclar y gana tus primeros puntos!'
                : '!Sigue reciclando para ganar mas puntos!',
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.eco, color: AppColors.lightGreen, size: 14),
              const SizedBox(width: 6),
              Text(
                'Proximo nivel: ${nextLevel.name}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const Spacer(),
              Text(
                '${user.totalPoints} / ${nextLevel.pointsRequired} pts',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.lightGreen),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

// Levels Section
class _LevelsSection extends StatelessWidget {
  final UserModel user;
  final VoidCallback onRedeem;
  const _LevelsSection({required this.user, required this.onRedeem});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Niveles de Recompensa',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            _Chip('${RewardLevel.levels.length} niveles'),
          ],
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.05,
          ),
          itemCount: RewardLevel.levels.length,
          itemBuilder: (_, i) {
            final level = RewardLevel.levels[i];
            final isUnlocked = user.totalPoints >= level.pointsRequired;
            return _LevelCard(level: level, isUnlocked: isUnlocked, index: i);
          },
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onRedeem,
            icon: const Icon(Icons.card_giftcard, size: 18),
            label: const Text('Canjear recompensas'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
              side: const BorderSide(color: AppColors.primaryGreen),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  final RewardLevel level;
  final bool isUnlocked;
  final int index;
  const _LevelCard({required this.level, required this.isUnlocked, required this.index});

  static const _iconBgs = [
    Color(0xFFDCF5DC), // Reciclador
    Color(0xFFD0EEE8), // Guardabosques
    Color(0xFFEDE0F5), // Heroe Verde
    Color(0xFFFFF3CC), // Campeon Recycle
  ];

  static const _iconColors = [
    Color(0xFF3A8A3A),
    Color(0xFF2E8B70),
    Color(0xFF7B2FBE),
    Color(0xFFD4A000),
  ];

  static const _icons = [
    Icons.eco,
    Icons.park,
    Icons.bolt,
    Icons.emoji_events,
  ];

  Color get _iconBg => index < _iconBgs.length ? _iconBgs[index] : AppColors.mintGreen;
  Color get _iconColor => index < _iconColors.length ? _iconColors[index] : AppColors.primaryGreen;
  IconData get _icon => index < _icons.length ? _icons[index] : Icons.star;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(_icon, color: _iconColor, size: 24),
              ),
              Icon(
                isUnlocked ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                color: isUnlocked ? AppColors.primaryGreen : Colors.grey.shade400,
                size: 17,
              ),
            ],
          ),
          const Spacer(),
          Text(
            level.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            level.reward,
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.amber, size: 14),
              const SizedBox(width: 3),
              Text(
                '${level.pointsRequired} pts',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Gana Puntos Section
class _GainPointsSection extends StatelessWidget {
  const _GainPointsSection();

  static const _items = [
    _GainItem('Botella de plastico', 'Plastico PET reciclable', 15,
        Color(0xFF4A90D9), Icons.water_drop),
    _GainItem('Lata de aluminio', 'Aluminio 100% reciclable', 20,
        Color(0xFF9E9E9E), Icons.local_drink),
    _GainItem('Carton', 'Papel y carton limpio', 12,
        Color(0xFFF5A623), Icons.inventory_2),
    _GainItem('Restos de comida', 'Organico compostable', 10,
        Color(0xFF4CAF50), Icons.eco),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Gana Puntos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            _Chip('por residuo'),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: item.color.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(item.icon, color: item.color, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.mintGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '+ ${item.pts} pts',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < _items.length - 1)
                    const Divider(height: 1, indent: 76, endIndent: 16, color: AppColors.divider),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _GainItem {
  final String name;
  final String subtitle;
  final int pts;
  final Color color;
  final IconData icon;
  const _GainItem(this.name, this.subtitle, this.pts, this.color, this.icon);
}

// Tip Card
class _TipCard extends StatelessWidget {
  const _TipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.mintGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.lightbulb_outline, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consejo EcoScanPark!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Recicla mas seguido para subir de nivel y desbloquear recompensas exclusivas.',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Shared Chip
class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.mintGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}
