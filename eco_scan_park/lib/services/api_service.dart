import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
//  ApiService — Comunicación con la API PHP en XAMPP
//
//  XAMPP htdocs path: C:\xampp\htdocs\api_php
//  Web / Windows Desktop : http://localhost/api_php/api
//  Emulador Android      : http://10.0.2.2/api_php/api
//  Dispositivo físico    : http://<TU_IP_LOCAL>/api_php/api
// ============================================================

class ApiService {
  /// URL base detectada automáticamente según la plataforma.
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost/api_php/api';
    if (Platform.isAndroid) return 'http://10.0.2.2/api_php/api';
    // Windows, Linux, macOS, iOS simulator
    return 'http://localhost/api_php/api';
  }

  static const String _tokenKey = 'auth_token';

  // ── Token ──────────────────────────────────────────────

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ── Headers ────────────────────────────────────────────

  static Future<Map<String, String>> _headers({bool auth = false}) async {
    final h = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await getToken();
      if (token != null) h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  // ── Respuesta genérica ─────────────────────────────────

  static Map<String, dynamic> _parse(http.Response res) {
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return body;
  }

  // ══════════════════════════════════════════════════════
  //  AUTH
  // ══════════════════════════════════════════════════════

  /// Login — devuelve el map completo de la respuesta
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login.php'),
      headers: await _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = _parse(res);
    if (data['success'] == true) {
      await saveToken(data['data']['token'] as String);
    }
    return data;
  }

  /// Registro
  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register.php'),
      headers: await _headers(),
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    final data = _parse(res);
    if (data['success'] == true) {
      await saveToken(data['data']['token'] as String);
    }
    return data;
  }

  /// Logout — sólo limpia el token local
  static Future<void> logout() async => clearToken();

  // ══════════════════════════════════════════════════════
  //  USUARIO
  // ══════════════════════════════════════════════════════

  /// Obtener perfil del usuario autenticado
  static Future<Map<String, dynamic>> getProfile() async {
    final res = await http.get(
      Uri.parse('$baseUrl/user/profile.php'),
      headers: await _headers(auth: true),
    );
    return _parse(res);
  }

  // ══════════════════════════════════════════════════════
  //  ESCANEO
  // ══════════════════════════════════════════════════════

  /// Enviar código de barras escaneado
  static Future<Map<String, dynamic>> submitScan(String barcode) async {
    final res = await http.post(
      Uri.parse('$baseUrl/scan/submit.php'),
      headers: await _headers(auth: true),
      body: jsonEncode({'barcode': barcode}),
    );
    return _parse(res);
  }

  // ══════════════════════════════════════════════════════
  //  HISTORIAL
  // ══════════════════════════════════════════════════════

  /// Obtener historial de escaneos paginado
  static Future<Map<String, dynamic>> getHistory({
    int limit = 20,
    int offset = 0,
  }) async {
    final res = await http.get(
      Uri.parse('$baseUrl/history/list.php?limit=$limit&offset=$offset'),
      headers: await _headers(auth: true),
    );
    return _parse(res);
  }

  // ══════════════════════════════════════════════════════
  //  RECOMPENSAS
  // ══════════════════════════════════════════════════════

  /// Listar catálogo de recompensas + historial de canjes del usuario
  static Future<Map<String, dynamic>> getRewards() async {
    final res = await http.get(
      Uri.parse('$baseUrl/rewards/rewards.php'),
      headers: await _headers(auth: true),
    );
    return _parse(res);
  }

  /// Canjear una recompensa por su ID
  static Future<Map<String, dynamic>> redeemReward(int rewardId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/rewards/rewards.php'),
      headers: await _headers(auth: true),
      body: jsonEncode({'reward_id': rewardId}),
    );
    return _parse(res);
  }
}
