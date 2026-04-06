import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        final user = provider.user;
        if (user == null) return const SizedBox();

        return Scaffold(
          appBar: AppBar(title: const Text('Historial')),
          body: user.history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.recycling,
                          size: 64, color: AppColors.divider),
                      const SizedBox(height: 16),
                      Text(
                        'Aún no has escaneado residuos',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Acércate a un kiosco EcoScanPark',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: user.history.length,
                  itemBuilder: (context, index) {
                    final record = user.history[index];
                    return _HistoryTile(record: record);
                  },
                ),
        );
      },
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final ScanRecord record;

  const _HistoryTile({required this.record});

  Color get _binColor {
    switch (record.wasteType) {
      case WasteType.recyclable:
        return AppColors.binYellow;
      case WasteType.organic:
        return AppColors.binGreen;
      case WasteType.nonRecyclable:
        return AppColors.binGray;
    }
  }

  IconData get _icon {
    switch (record.wasteType) {
      case WasteType.recyclable:
        return Icons.local_drink;
      case WasteType.organic:
        return Icons.eco;
      case WasteType.nonRecyclable:
        return Icons.delete_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final time =
        '${record.date.hour.toString().padLeft(2, '0')}:${record.date.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: _binColor, width: 4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _binColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: _binColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${record.wasteType.binColor} · $time',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${record.points}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}
