<?php
// ============================================================
//  GET  /api/rewards/list.php         (requiere auth)
//  POST /api/rewards/redeem.php       (requiere auth)
// ============================================================
require_once __DIR__ . '/../../config/helpers.php';

$userId = requireAuth();

// ── GET: listar catálogo ──────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $db = getDB();
    $stmt = $db->query('SELECT * FROM rewards WHERE is_active = TRUE ORDER BY points_cost ASC');
    $rewards = $stmt->fetchAll();

    // Marcar cuáles ya canjeó el usuario
    $redeemedStmt = $db->prepare('
        SELECT r.name, rr.coupon_code, rr.redeemed_at
        FROM reward_redemptions rr
        JOIN rewards r ON rr.reward_id = r.id
        WHERE rr.user_id = ?
        ORDER BY rr.redeemed_at DESC
    ');
    $redeemedStmt->execute([$userId]);
    $redeemed = $redeemedStmt->fetchAll();

    respond(true, 'OK', [
        'rewards'  => $rewards,
        'redeemed' => $redeemed,
    ]);
}

// ── POST: canjear recompensa ──────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $body     = getBody();
    $rewardId = (int)($body['reward_id'] ?? 0);

    if (!$rewardId) {
        respond(false, 'reward_id requerido', [], 422);
    }

    $db = getDB();

    // Obtener recompensa
    $rwStmt = $db->prepare('SELECT * FROM rewards WHERE id = ? AND is_active = TRUE');
    $rwStmt->execute([$rewardId]);
    $reward = $rwStmt->fetch();
    if (!$reward) {
        respond(false, 'Recompensa no encontrada', [], 404);
    }

    // Verificar puntos suficientes
    $userStmt = $db->prepare('SELECT total_points FROM users WHERE id = ?');
    $userStmt->execute([$userId]);
    $user = $userStmt->fetch();
    if ((int)$user['total_points'] < (int)$reward['points_cost']) {
        respond(false, 'Puntos insuficientes', [], 409);
    }

    // Generar cupón único
    $coupon = 'ECO-' . strtoupper(substr(bin2hex(random_bytes(4)), 0, 8));

    // Registrar canje
    $db->prepare('
        INSERT INTO reward_redemptions (user_id, reward_id, coupon_code, points_used)
        VALUES (?, ?, ?, ?)
    ')->execute([$userId, $rewardId, $coupon, $reward['points_cost']]);

    // Descontar puntos
    $db->prepare('
        UPDATE users SET total_points = total_points - ?, updated_at = NOW()
        WHERE id = ?
    ')->execute([$reward['points_cost'], $userId]);

    // Transacción negativa
    $db->prepare('
        INSERT INTO points_transactions (user_id, amount, type, description)
        VALUES (?, ?, "redeemed", ?)
    ')->execute([$userId, -$reward['points_cost'], 'Canje: ' . $reward['name']]);

    // Puntos restantes
    $userStmt->execute([$userId]);
    $remaining = (int)$userStmt->fetch()['total_points'];

    respond(true, 'Canje exitoso', [
        'coupon_code'   => $coupon,
        'reward_name'   => $reward['name'],
        'points_used'   => (int)$reward['points_cost'],
        'points_remaining' => $remaining,
    ], 201);
}

respond(false, 'Método no permitido', [], 405);
