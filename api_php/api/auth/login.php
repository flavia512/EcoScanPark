<?php
// ============================================================
//  POST /api/auth/login.php
//  Body: { "email": "...", "password": "..." }
//  Response: { success, message, data: { token, user } }
// ============================================================
require_once __DIR__ . '/../../config/helpers.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    respond(false, 'Método no permitido', [], 405);
}

$body = getBody();
$email    = trim($body['email']    ?? '');
$password = trim($body['password'] ?? '');

if (empty($email) || empty($password)) {
    respond(false, 'Email y contraseña son requeridos', [], 422);
}

$db = getDB();

// Buscar usuario
$stmt = $db->prepare('
    SELECT u.*, rl.name AS level_name, rl.icon AS level_icon, rl.points_required
    FROM users u
    JOIN reward_levels rl ON u.reward_level_id = rl.id
    WHERE u.email = ?
');
$stmt->execute([$email]);
$user = $stmt->fetch();

if (!$user || !password_verify($password, $user['password_hash'])) {
    respond(false, 'Credenciales incorrectas', [], 401);
}

// Generar token
$token = bin2hex(random_bytes(32));
$expiresAt = date('Y-m-d H:i:s', strtotime('+30 days'));

// Eliminar tokens anteriores del usuario
$db->prepare('DELETE FROM auth_tokens WHERE user_id = ?')->execute([$user['id']]);

// Insertar nuevo token
$db->prepare('INSERT INTO auth_tokens (token, user_id, expires_at) VALUES (?, ?, ?)')
   ->execute([$token, $user['id'], $expiresAt]);

// Contar escaneos
$scanStmt = $db->prepare('SELECT COUNT(*) as total FROM scan_history WHERE user_id = ?');
$scanStmt->execute([$user['id']]);
$scanCount = $scanStmt->fetch()['total'];

respond(true, 'Login exitoso', [
    'token' => $token,
    'user'  => [
        'id'           => $user['id'],
        'name'         => $user['name'],
        'email'        => $user['email'],
        'total_points' => (int) $user['total_points'],
        'visits'       => (int) $user['visits'],
        'facilities'   => (int) $user['facilities'],
        'level'        => $user['level_name'],
        'level_icon'   => $user['level_icon'],
        'total_scans'  => (int) $scanCount,
    ],
]);
