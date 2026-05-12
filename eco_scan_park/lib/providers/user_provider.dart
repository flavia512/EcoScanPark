import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoggedIn = false;
  ScanRecord? _lastScan;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  ScanRecord? get lastScan => _lastScan;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ── Auth ──────────────────────────────────────────────

  /// Login via API. Devuelve null si OK, o mensaje de error.
  Future<String?> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await ApiService.login(email, password);
      if (res['success'] == true) {
        _applyUserFromMap(res['data']['user'] as Map<String, dynamic>);
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        // Cargar historial y canjes desde la BD (en background)
        Future.wait([loadHistory(), loadRedeemedRewards()]);
        return null;
      }
      return res['message'] as String? ?? 'Error desconocido';
    } catch (_) {
      return 'No se pudo conectar con el servidor';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registro via API.
  Future<String?> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await ApiService.register(name, email, password);
      if (res['success'] == true) {
        _applyUserFromMap(res['data']['user'] as Map<String, dynamic>);
        _isLoggedIn = true;
        return null;
      }
      return res['message'] as String? ?? 'Error desconocido';
    } catch (_) {
      return 'No se pudo conectar con el servidor';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await ApiService.logout();
    _user = null;
    _isLoggedIn = false;
    _lastScan = null;
    notifyListeners();
  }

  // ── Perfil ────────────────────────────────────────────

  Future<void> loadProfile() async {
    try {
      final res = await ApiService.getProfile();
      if (res['success'] == true) {
        _applyUserFromMap(res['data']['user'] as Map<String, dynamic>);
        notifyListeners();
        // Cargar historial y canjes desde la BD
        await Future.wait([loadHistory(), loadRedeemedRewards()]);
      }
    } catch (_) {
      // Silencioso: se mantiene la versión local cacheada
    }
  }

  /// Carga historial de escaneos desde la API y actualiza el estado.
  Future<void> loadHistory() async {
    if (_user == null) return;
    try {
      final res = await ApiService.getHistory();
      if (res['success'] == true) {
        final items = (res['data']['history'] as List<dynamic>);
        _user!.history = items.map((h) => ScanRecord(
          productName: h['product_name'] as String,
          wasteType: _parseWasteType(h['waste_code'] as String? ?? ''),
          points: (h['points_earned'] as num).toInt(),
          material: h['material'] as String? ?? '',
          date: DateTime.tryParse(h['scanned_at'] as String? ?? '') ?? DateTime.now(),
        )).toList();
        notifyListeners();
      }
    } catch (_) {}
  }

  /// Carga canjes realizados desde la API y actualiza el estado.
  Future<void> loadRedeemedRewards() async {
    if (_user == null) return;
    try {
      final res = await ApiService.getRewards();
      if (res['success'] == true) {
        final redeemed = (res['data']['redeemed'] as List<dynamic>);
        _user!.redeemedRewards = redeemed.map((r) {
          final rewardName = r['name'] as String;
          AvailableReward? match;
          try {
            match = AvailableReward.catalog
                .firstWhere((a) => a.name == rewardName);
          } catch (_) {}
          final reward = match ??
              AvailableReward(
                id: 0,
                name: rewardName,
                description: '',
                pointsCost: 0,
                category: 'Otro',
                rating: 0,
                icon: '🎁',
              );
          return RedeemedReward(
            reward: reward,
            couponCode: r['coupon_code'] as String,
            redeemedAt:
                DateTime.tryParse(r['redeemed_at'] as String? ?? '') ??
                    DateTime.now(),
          );
        }).toList();
        notifyListeners();
      }
    } catch (_) {}
  }

  // ── Escaneo ───────────────────────────────────────────

  /// Envía el código de barras a la API y actualiza el estado.
  /// En modo demo (sin servidor), usa [simulateScan].
  Future<String?> submitScan(String barcode) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await ApiService.submitScan(barcode);
      if (res['success'] == true) {
        final scan = res['data']['scan'] as Map<String, dynamic>;
        final record = ScanRecord(
          productName: scan['product_name'] as String,
          wasteType: _parseWasteType(scan['waste_code'] as String? ?? ''),
          points: (scan['points_earned'] as num).toInt(),
          material: scan['material'] as String? ?? '',
          date: DateTime.now(),
        );
        _user?.history.insert(0, record);
        _user?.totalPoints = (scan['total_points'] as num).toInt();
        _lastScan = record;
        notifyListeners();
        return null;
      }
      return res['message'] as String? ?? 'Error en el escaneo';
    } catch (_) {
      return 'No se pudo conectar con el servidor';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Modo demo — sin API (mantiene compatibilidad con ScannerScreen)
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
    final record = ScanRecord(
      productName: pick.$1,
      wasteType: pick.$2,
      points: pick.$3,
      material: pick.$4,
      date: DateTime.now(),
    );
    _user?.history.insert(0, record);
    _user?.totalPoints += pick.$3;
    _lastScan = record;
    notifyListeners();
  }

  // ── Recompensas ───────────────────────────────────────

  Future<String?> redeemReward(AvailableReward reward) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await ApiService.redeemReward(reward.id);
      if (res['success'] == true) {
        final d = res['data'] as Map<String, dynamic>;
        _user?.totalPoints = (d['points_remaining'] as num).toInt();
        _user?.redeemedRewards.insert(
          0,
          RedeemedReward(
            reward: reward,
            couponCode: d['coupon_code'] as String,
            redeemedAt: DateTime.now(),
          ),
        );
        notifyListeners();
        return null;
      }
      return res['message'] as String? ?? 'No se pudo realizar el canje';
    } catch (_) {
      // Fallback local si no hay API
      if (_user != null && _user!.totalPoints >= reward.pointsCost) {
        _user!.totalPoints -= reward.pointsCost;
        final coupon =
            'ECO-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
        _user!.redeemedRewards.insert(
          0,
          RedeemedReward(
            reward: reward,
            couponCode: coupon,
            redeemedAt: DateTime.now(),
          ),
        );
        notifyListeners();
        return null;
      }
      return 'Puntos insuficientes';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Helpers privados ──────────────────────────────────

  void _applyUserFromMap(Map<String, dynamic> map) {
    _user = UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      totalPoints: (map['total_points'] as num?)?.toInt() ?? 0,
      visits: (map['visits'] as num?)?.toInt() ?? 1,
      facilities: (map['facilities'] as num?)?.toInt() ?? 0,
    );
  }

  WasteType _parseWasteType(String code) {
    switch (code.toLowerCase()) {
      case 'recyclable':
        return WasteType.recyclable;
      case 'organic':
        return WasteType.organic;
      default:
        return WasteType.nonRecyclable;
    }
  }
}
