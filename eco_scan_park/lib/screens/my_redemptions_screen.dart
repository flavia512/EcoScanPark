import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class MyRedemptionsScreen extends StatelessWidget {
  const MyRedemptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        final user = provider.user;
        if (user == null) return const Scaffold();

        return Scaffold(
          backgroundColor: AppColors.sageBackground,
          appBar: AppBar(
            title: const Text('Mis canjes'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: user.redeemedRewards.isEmpty
              ? _EmptyState()
              : RefreshIndicator(
                  color: AppColors.primaryGreen,
                  onRefresh: () => provider.loadRedeemedRewards(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                    itemCount: user.redeemedRewards.length,
                    itemBuilder: (context, index) {
                      return _RedemptionCard(
                        redemption: user.redeemedRewards[index],
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.mintGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.confirmation_number_outlined,
                  size: 44, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aún no has realizado canjes',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Acumula puntos y canjéalos\npor recompensas en el parque',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/redeem'),
              icon: const Icon(Icons.card_giftcard, size: 18),
              label: const Text('Ver recompensas disponibles'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Redemption card ──────────────────────────────────────────────────────────

class _RedemptionCard extends StatelessWidget {
  final RedeemedReward redemption;
  const _RedemptionCard({required this.redemption});

  @override
  Widget build(BuildContext context) {
    final r = redemption.reward;
    final dt = redemption.redeemedAt;
    final date =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top: icon + name + category + date
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.mintGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Center(child: Text(r.icon, style: const TextStyle(fontSize: 26))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.mintGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              r.category,
                              style: const TextStyle(
                                color: AppColors.primaryGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 11, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                date,
                                style: const TextStyle(
                                    color: AppColors.textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider with notch effect
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.sageBackground,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (_, constraints) => Row(
                      children: List.generate(
                        (constraints.maxWidth / 8).floor(),
                        (i) => Container(
                          width: 4,
                          height: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          color: AppColors.divider,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 12,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.sageBackground,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          // Bottom: coupon code + usar button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Row(
              children: [
                // Coupon chip
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.sageBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.confirmation_number_outlined,
                            size: 15, color: AppColors.primaryGreen),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            redemption.couponCode,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              letterSpacing: 1.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: redemption.couponCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Código copiado al portapapeles'),
                                duration: Duration(seconds: 2),
                                backgroundColor: AppColors.primaryGreen,
                              ),
                            );
                          },
                          child: const Icon(Icons.copy,
                              size: 15, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Usar button
                ElevatedButton(
                  onPressed: () => _showUseSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Usar',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showUseSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UseCouponSheet(redemption: redemption),
    );
  }
}

// ─── Use coupon bottom sheet ──────────────────────────────────────────────────

class _UseCouponSheet extends StatelessWidget {
  final RedeemedReward redemption;
  const _UseCouponSheet({required this.redemption});

  @override
  Widget build(BuildContext context) {
    final r = redemption.reward;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Icon circle
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              color: AppColors.mintGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
                child: Text(r.icon, style: const TextStyle(fontSize: 42))),
          ),
          const SizedBox(height: 16),
          Text(
            r.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Muestra este código al personal del parque',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 28),
          // Coupon code display — big dark ticket
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.darkGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'CÓDIGO DE CANJE',
                  style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  redemption.couponCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    r.category,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Copy button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: redemption.couponCode));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Código copiado'),
                    backgroundColor: AppColors.primaryGreen,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Copiar código'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryGreen,
                side: const BorderSide(color: AppColors.primaryGreen),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }
}
