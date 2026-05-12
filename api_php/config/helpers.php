<?php
// ============================================================
//  EcoScanPark — Helpers globales
// ============================================================

require_once __DIR__ . '/database.php';

// CORS — permite peticiones desde Flutter (emulador y dispositivo físico)
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json; charset=utf-8');

// Preflight OPTIONS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

/** Respuesta JSON unificada */
function respond(bool $success, string $message, array $data = [], int $code = 200): void {
    http_response_code($code);
    echo json_encode([
        'success' => $success,
        'message' => $message,
        'data'    => $data,
    ], JSON_UNESCAPED_UNICODE);
    exit;
}

/** Lee el body JSON de la petición */
function getBody(): array {
    $raw = file_get_contents('php://input');
    return json_decode($raw, true) ?? [];
}

/** Valida el token Bearer y devuelve el user_id */
function requireAuth(): string {
    // Apache puede pasar el header como HTTP_AUTHORIZATION o REDIRECT_HTTP_AUTHORIZATION
    $authHeader = $_SERVER['HTTP_AUTHORIZATION']
        ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION']
        ?? (function_exists('getallheaders') ? (getallheaders()['Authorization'] ?? '') : '')
        ?? '';
    if (!str_starts_with($authHeader, 'Bearer ')) {
        respond(false, 'No autorizado', [], 401);
    }
    $token = substr($authHeader, 7);
    $db = getDB();
    $stmt = $db->prepare('SELECT user_id FROM auth_tokens WHERE token = ? AND expires_at > NOW()');
    $stmt->execute([$token]);
    $row = $stmt->fetch();
    if (!$row) {
        respond(false, 'Token inválido o expirado', [], 401);
    }
    return $row['user_id'];
}
