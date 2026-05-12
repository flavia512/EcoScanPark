import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false;
  ScanRecord? _lastScan;

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  ScanRecord? get lastScan => _lastScan;

  void login(String name, String email) {
    _user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      visits: 1,
      facilities: 0,
    );
    _isLoggedIn = true;
    notifyListeners();
  }

  void register(String name, String email) {
    login(name, email);
  }

  void addScan(ScanRecord record) {
    if (_user != null) {
      _user!.history.insert(0, record);
      _user!.totalPoints += record.points;
      _lastScan = record;
      notifyListeners();
    }
  }

  void redeemReward(AvailableReward reward) {
    if (_user != null && _user!.totalPoints >= reward.pointsCost) {
      _user!.totalPoints -= reward.pointsCost;
      final coupon =
          'ESP-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
      _user!.redeemedRewards.insert(
        0,
        RedeemedReward(
          reward: reward,
          couponCode: coupon,
          redeemedAt: DateTime.now(),
        ),
      );
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    _lastScan = null;
    notifyListeners();
  }

  // Simular un escaneo para demo
  void simulateScan() {
    final products = [
      ('Botella de Agua', WasteType.recyclable, 10, 'Plástico PET'),
      ('Lata de aluminio', WasteType.recyclable, 12, 'Aluminio'),
      ('Cartón de jugo', WasteType.recyclable, 8, 'Tetra Pak'),
      ('Restos de comida', WasteType.organic, 5, 'Orgánico'),
      ('Servilleta usada', WasteType.nonRecyclable, 3, 'Papel mixto'),
      ('Vaso de plástico', WasteType.recyclable, 8, 'Plástico PS'),
      ('Cáscara de fruta', WasteType.organic, 5, 'Orgánico'),
      ('Botella de vidrio', WasteType.recyclable, 15, 'Vidrio'),
    ];
    final pick = products[DateTime.now().millisecond % products.length];
    addScan(ScanRecord(
      productName: pick.$1,
      wasteType: pick.$2,
      points: pick.$3,
      material: pick.$4,
      date: DateTime.now(),
    ));
  }
}
