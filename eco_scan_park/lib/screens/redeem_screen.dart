import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class RedeemScreen extends StatefulWidget {
  const RedeemScreen({super.key});
  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        final user = provider.user;
        if (user == null) return const SizedBox();
        final catalog = _selectedTab == 1
            ? AvailableReward.catalog.where((r) => r.rating >= 4.6).toList()
            : AvailableReward.catalog;
        return Scaffold(
          backgroundColor: AppColors.sageBackground,
          appBar: AppBar(
            title: const Text('Canjear Recompensas'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            children: [
              _PointsCard(user: user),
              const SizedBox(height: 24),
              _SectionHeader(
                count: catalog.length,
                selectedTab: _selectedTab,
                onTab: (i) => setState(() => _selectedTab = i),
              ),
              const SizedBox(height: 16),
              ...catalog.map((r) => _RewardCard(
                    reward: r,
                    userPoints: user.totalPoints,
                    onRedeem: () => _confirmRedeem(context, provider, user, r),
                  )),
            ],
          ),
        );
      },
    );
  }

  void _confirmRedeem(BuildContext ctx, UserProvider provider, UserModel user,
      AvailableReward reward) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (c) => _ConfirmSheet(
        reward: reward,
        userPoints: user.totalPoints,
        onConfirm: () async {
          Navigator.pop(c);
          final err = await provider.redeemReward(reward);
          if (!ctx.mounted) return;
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(err ?? '¡Canje exitoso! ${reward.name}'),
            backgroundColor:
                err == null ? AppColors.primaryGreen : Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ));
        },
      ),
    );
  }
}

// ── Points Card ────────────────────────────────────────────────────────────────
class _PointsCard extends StatelessWidget {
  final UserModel user;
  const _PointsCard({required this.user});

  String _fmt(int n) =>
      n >= 1000 ? '${n ~/ 1000},${(n % 1000).toString().padLeft(3, '0')}' : '$n';

  @override
  Widget build(BuildContext context) {
    final nextLevel = RewardLevel.levels.firstWhere(
      (l) => user.totalPoints < l.pointsRequired,
      orElse: () => RewardLevel.levels.last,
    );
    final progress = user.levelProgress.clamp(0.0, 1.0);
    final pct = (progress * 100).toInt();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: const [
                Icon(Icons.eco, color: AppColors.lightGreen, size: 16),
                SizedBox(width: 6),
                Text('PUNTOS ECOSCAN',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0)),
              ]),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  Text('Nivel Eco',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                  SizedBox(width: 4),
                  Icon(Icons.eco, color: AppColors.lightGreen, size: 13),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 14),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: _fmt(user.totalPoints),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      height: 1)),
              const TextSpan(
                  text: ' pts',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
            ]),
          ),
          const SizedBox(height: 4),
          const Text('Disponibles para canjear',
              style: TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 18),
          Row(children: [
            Text('Próximo nivel: ${nextLevel.pointsRequired} pts',
                style:
                    const TextStyle(color: Colors.white60, fontSize: 12)),
            const Spacer(),
            Text('$pct%',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.lightGreen),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final int count;
  final int selectedTab;
  final ValueChanged<int> onTab;
  const _SectionHeader(
      {required this.count,
      required this.selectedTab,
      required this.onTab});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Recompensas',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            Text('$count recompensas disponibles',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
          ]),
        ),
        const SizedBox(width: 12),
        Row(children: [
          _Tab(
              label: 'Todas',
              active: selectedTab == 0,
              onTap: () => onTab(0)),
          const SizedBox(width: 8),
          _Tab(
              label: 'Populares',
              active: selectedTab == 1,
              onTap: () => onTab(1)),
        ]),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: active ? AppColors.primaryGreen : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color:
                    active ? AppColors.primaryGreen : AppColors.divider),
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color:
                      active ? Colors.white : AppColors.textSecondary)),
        ),
      );
}

// ── Category Style ─────────────────────────────────────────────────────────────
class _CStyle {
  final String emoji;
  final String label;
  final Color badgeBg;
  final List<Color> gradient;
  const _CStyle(this.emoji, this.label, this.badgeBg, this.gradient);
}

_CStyle _cStyle(String category) {
  switch (category) {
    case 'Atracciones':
      return const _CStyle('⚡', 'Atracciones', Color(0xFF2E7D32),
          [Color(0xFF1B5E20), Color(0xFF43A047)]);
    case 'Comida':
      return const _CStyle('🍹', 'Comida', Color(0xFFE65100),
          [Color(0xFFBF360C), Color(0xFFFF7043)]);
    case 'Descuento':
      return const _CStyle('🏷️', 'Descuento', Color(0xFF1565C0),
          [Color(0xFF0D47A1), Color(0xFF1E88E5)]);
    case 'Experiencia':
      return const _CStyle('📸', 'Foto', Color(0xFF00695C),
          [Color(0xFF004D40), Color(0xFF00897B)]);
    case 'Mercancía':
      return const _CStyle('👑', 'VIP', Color(0xFF6A1B9A),
          [Color(0xFF4A148C), Color(0xFF9C27B0)]);
    default:
      return const _CStyle('🎁', 'Premio', Color(0xFF455A64),
          [Color(0xFF263238), Color(0xFF546E7A)]);
  }
}

// ── Reward Card ────────────────────────────────────────────────────────────────
class _RewardCard extends StatelessWidget {
  final AvailableReward reward;
  final int userPoints;
  final VoidCallback onRedeem;
  const _RewardCard(
      {required this.reward,
      required this.userPoints,
      required this.onRedeem});

  @override
  Widget build(BuildContext context) {
    final cs = _cStyle(reward.category);
    final canAfford = userPoints >= reward.pointsCost;
    final fullStars = reward.rating.floor();
    final hasHalf = (reward.rating - fullStars) >= 0.3;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Gradient Image Area ──────────────────────────────────────────
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: cs.gradient,
                    ),
                  ),
                ),
                // Decorative circles
                Positioned(
                  top: -50,
                  right: -40,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  left: -30,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 40,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 60,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.09),
                    ),
                  ),
                ),
                // Centered emoji icon
                Center(
                  child: Text(
                    reward.icon,
                    style: const TextStyle(fontSize: 76),
                  ),
                ),
                // Category badge — top left
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: cs.badgeBg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      '${cs.emoji}  ${cs.label}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Points badge — top right
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${reward.pointsCost} pts',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Info Area ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  reward.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Star rating
                    Row(
                      children: List.generate(5, (i) {
                        if (i < fullStars) {
                          return const Icon(Icons.star_rounded,
                              color: AppColors.amber, size: 20);
                        } else if (i == fullStars && hasHalf) {
                          return const Icon(Icons.star_half_rounded,
                              color: AppColors.amber, size: 20);
                        }
                        return const Icon(Icons.star_outline_rounded,
                            color: AppColors.amber, size: 20);
                      }),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${reward.rating}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    // Canjear button
                    GestureDetector(
                      onTap: canAfford ? onRedeem : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 12),
                        decoration: BoxDecoration(
                          color: canAfford
                              ? AppColors.primaryGreen
                              : const Color(0xFFDDE8D8),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.card_giftcard_rounded,
                              color: canAfford
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              size: 17,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              'Canjear',
                              style: TextStyle(
                                color: canAfford
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Confirm Sheet ──────────────────────────────────────────────────────────────
class _ConfirmSheet extends StatelessWidget {
  final AvailableReward reward;
  final int userPoints;
  final VoidCallback onConfirm;
  const _ConfirmSheet(
      {required this.reward,
      required this.userPoints,
      required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final remaining = userPoints - reward.pointsCost;
    final cs = _cStyle(reward.category);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(28)),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 5,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(3)),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: cs.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              shape: BoxShape.circle,
            ),
            child: Center(
                child: Text(reward.icon,
                    style: const TextStyle(fontSize: 36))),
          ),
          const SizedBox(height: 16),
          const Text('¿Confirmar canje?',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(
            'Estás a punto de canjear ${reward.pointsCost} puntos por:',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppColors.sageBackground,
                borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              Row(children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: Text(reward.icon,
                          style: const TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(reward.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textPrimary))),
              ]),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 12),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.stars_rounded,
                          color: AppColors.amber, size: 17),
                      Text(' ${reward.pointsCost} pts',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.textPrimary)),
                    ]),
                    const Icon(Icons.arrow_forward,
                        size: 16, color: AppColors.textSecondary),
                    Text('Saldo: $remaining pts',
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary)),
                  ]),
              const SizedBox(height: 10),
              const Row(children: [
                Icon(Icons.check_circle_outline,
                    color: AppColors.primaryGreen, size: 14),
                SizedBox(width: 6),
                Expanded(
                    child: Text(
                        'El cupón se enviará a tu correo registrado.',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary))),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onConfirm,
              icon: const Icon(Icons.check_rounded, size: 20),
              label: const Text('Confirmar Canje',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, size: 16),
            label: const Text('Cancelar'),
            style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
