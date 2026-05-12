<?php
// ============================================================
//  POST /api/auth/register.php
//  Body: { "name": "...", "email": "...", "password": "..." }
// ============================================================
require_once __DIR__ . '/../../config/helpers.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    respond(false, 'Método no permitido', [], 405);
}

$body    = getBody();
$name    = trim($body['name']     ?? '');
$email   = trim($body['email']    ?? '');
$password = trim($body['password'] ?? '');

if (empty($name) || empty($email) || empty($password)) {
    respond(false, 'Todos los campos son requeridos', [], 422);
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    respond(false, 'Email inválido', [], 422);
}

if (strlen($password) < 6) {
    respond(false, 'La contraseña debe tener al menos 6 caracteres', [], 422);
}

$db = getDB();

// Verificar email único
$check = $db->prepare('SELECT id FROM users WHERE email = ?');
$check->execute([$email]);
if ($check->fetch()) {
    respond(false, 'El email ya está registrado', [], 409);
}

$id   = 'u' . uniqid('', true);
$hash = password_hash($password, PASSWORD_BCRYPT);

$db->prepare('
    INSERT INTO users (id, name, email, password_hash, total_points, visits, facilities, reward_level_id)
    VALUES (?, ?, ?, ?, 0, 1, 0, 1)
')->execute([$id, $name, $email, $hash]);

// Auto-login: generar token
$token     = bin2hex(random_bytes(32));
$expiresAt = date('Y-m-d H:i:s', strtotime('+30 days'));
$db->prepare('INSERT INTO auth_tokens (token, user_id, expires_at) VALUES (?, ?, ?)')
   ->execute([$token, $id, $expiresAt]);

respond(true, 'Registro exitoso', [
    'token' => $token,
    'user'  => [
        'id'           => $id,
        'name'         => $name,
        'email'        => $email,
        'total_points' => 0,
        'visits'       => 1,
        'facilities'   => 0,
        'level'        => 'Explorador',
        'level_icon'   => 'L1',
        'total_scans'  => 0,
    ],
], 201);
