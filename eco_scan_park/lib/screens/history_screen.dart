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
          backgroundColor: AppColors.sageBackground,
          appBar: AppBar(
            title: const Text('Mi historial'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: user.history.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.mintGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.recycling,
                            size: 40, color: AppColors.primaryGreen),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Aún no has escaneado residuos',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
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
                    return _HistoryTile(record: user.history[index]);
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

  Color get _color {
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
        return Icons.recycling;
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
    final date =
        '${record.date.day}/${record.date.month}/${record.date.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: _color, width: 4)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_icon, color: _color, size: 20),
          ),
          const SizedBox(width: 12),
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
                  '${record.wasteType.label} · $date $time',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${record.points}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}

