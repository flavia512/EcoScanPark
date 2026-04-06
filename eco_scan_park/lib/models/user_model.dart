class UserModel {
  final String id;
  final String name;
  final String email;
  int totalPoints;
  List<ScanRecord> history;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.totalPoints = 0,
    List<ScanRecord>? history,
  }) : history = history ?? [];

  String get level {
    if (totalPoints >= 400) return 'Campeón Recycle';
    if (totalPoints >= 250) return 'Héroe Verde';
    if (totalPoints >= 120) return 'Guardabosques';
    if (totalPoints >= 50) return 'Reciclador';
    return 'Novato';
  }

  String get levelEmoji {
    if (totalPoints >= 400) return '🏆';
    if (totalPoints >= 250) return '🦸';
    if (totalPoints >= 120) return '🌲';
    if (totalPoints >= 50) return '♻️';
    return '🌱';
  }

  int get nextLevelPoints {
    if (totalPoints >= 400) return 400;
    if (totalPoints >= 250) return 400;
    if (totalPoints >= 120) return 250;
    if (totalPoints >= 50) return 120;
    return 50;
  }

  double get levelProgress {
    final next = nextLevelPoints;
    int prev;
    if (totalPoints >= 400) return 1.0;
    if (totalPoints >= 250) {
      prev = 250;
    } else if (totalPoints >= 120) {
      prev = 120;
    } else if (totalPoints >= 50) {
      prev = 50;
    } else {
      prev = 0;
    }
    return (totalPoints - prev) / (next - prev);
  }
}

class ScanRecord {
  final String productName;
  final WasteType wasteType;
  final int points;
  final DateTime date;

  ScanRecord({
    required this.productName,
    required this.wasteType,
    required this.points,
    required this.date,
  });
}

enum WasteType {
  organic('Orgánico', 'Verde'),
  recyclable('Reciclable', 'Amarillo'),
  nonRecyclable('No reciclable', 'Gris');

  final String label;
  final String binColor;
  const WasteType(this.label, this.binColor);
}

class RewardLevel {
  final String name;
  final int pointsRequired;
  final String reward;
  final String icon;

  const RewardLevel({
    required this.name,
    required this.pointsRequired,
    required this.reward,
    required this.icon,
  });

  static const List<RewardLevel> levels = [
    RewardLevel(
      name: 'Reciclador',
      pointsRequired: 50,
      reward: '5% descuento en puntos de venta',
      icon: '♻️',
    ),
    RewardLevel(
      name: 'Guardabosques',
      pointsRequired: 120,
      reward: 'Bebida gratis o postre',
      icon: '🌲',
    ),
    RewardLevel(
      name: 'Héroe Verde',
      pointsRequired: 250,
      reward: 'Prioridad en cola de atracción',
      icon: '🦸',
    ),
    RewardLevel(
      name: 'Campeón Recycle',
      pointsRequired: 400,
      reward: 'Pack merchandising sostenible',
      icon: '🏆',
    ),
  ];
}
