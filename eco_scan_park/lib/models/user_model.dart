class UserModel {
  final String id;
  final String name;
  final String email;
  int totalPoints;
  int visits;
  int facilities;
  List<ScanRecord> history;
  List<RedeemedReward> redeemedRewards;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.totalPoints = 0,
    this.visits = 1,
    this.facilities = 0,
    List<ScanRecord>? history,
    List<RedeemedReward>? redeemedRewards,
  })  : history = history ?? [],
        redeemedRewards = redeemedRewards ?? [];

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
  final String material;
  final DateTime date;

  ScanRecord({
    required this.productName,
    required this.wasteType,
    required this.points,
    this.material = 'Desconocido',
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

class AvailableReward {
  final int id;
  final String name;
  final String description;
  final int pointsCost;
  final String category;
  final double rating;
  final String icon;

  const AvailableReward({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsCost,
    required this.category,
    required this.rating,
    required this.icon,
  });

  static const List<AvailableReward> catalog = [
    AvailableReward(
      id: 1,
      name: 'Acceso rápido a dos atracciones',
      description: 'Salta la fila en cualquier dos atracciones del parque',
      pointsCost: 280,
      category: 'Atracciones',
      rating: 4.8,
      icon: '🎢',
    ),
    AvailableReward(
      id: 2,
      name: 'Bebida gratis en el parque',
      description: 'Una bebida de hasta 500ml gratis en cualquier puesto',
      pointsCost: 120,
      category: 'Comida',
      rating: 4.5,
      icon: '🥤',
    ),
    AvailableReward(
      id: 3,
      name: '10% descuento en tiendas',
      description: 'Descuento en compras de souvenir y tiendas locales',
      pointsCost: 50,
      category: 'Descuento',
      rating: 4.2,
      icon: '🏷️',
    ),
    AvailableReward(
      id: 4,
      name: 'Foto recuerdo impresa',
      description: 'Una foto impresa como recuerdo de tu visita',
      pointsCost: 150,
      category: 'Experiencia',
      rating: 4.6,
      icon: '📸',
    ),
    AvailableReward(
      id: 5,
      name: 'Pack merchandising eco',
      description: 'Bolsa reutilizable + termo ecológico de EcoScanPark',
      pointsCost: 400,
      category: 'Mercancía',
      rating: 4.9,
      icon: '🎁',
    ),
    AvailableReward(
      id: 6,
      name: 'Cupón Tiendas Locales 10% OFF',
      description: 'Cupón de descuento para tiendas locales asociadas',
      pointsCost: 500,
      category: 'Descuento',
      rating: 4.0,
      icon: '🎟️',
    ),
  ];
}

class RedeemedReward {
  final AvailableReward reward;
  final String couponCode;
  final DateTime redeemedAt;

  RedeemedReward({
    required this.reward,
    required this.couponCode,
    required this.redeemedAt,
  });
}
