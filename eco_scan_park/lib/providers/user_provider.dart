import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  void login(String name, String email) {
    _user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
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
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // Simular un escaneo para demo
  void simulateScan() {
    final products = [
      ('Botella de plástico', WasteType.recyclable, 15),
      ('Lata de aluminio', WasteType.recyclable, 12),
      ('Cartón de pizza', WasteType.recyclable, 8),
      ('Restos de comida', WasteType.organic, 5),
      ('Servilleta usada', WasteType.nonRecyclable, 3),
      ('Vaso de plástico', WasteType.recyclable, 10),
      ('Cáscara de fruta', WasteType.organic, 5),
    ];
    final random = products[(DateTime.now().millisecond % products.length)];
    addScan(ScanRecord(
      productName: random.$1,
      wasteType: random.$2,
      points: random.$3,
      date: DateTime.now(),
    ));
  }
}
