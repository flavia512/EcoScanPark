<?php
// ============================================================
//  GET /api/user/profile.php          (requiere auth)
// ============================================================
require_once __DIR__ . '/../../config/helpers.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    respond(false, 'Método no permitido', [], 405);
}

$userId = requireAuth();
$db = getDB();

$stmt = $db->prepare('
    SELECT
        u.id, u.name, u.email, u.total_points, u.visits, u.facilities,
        rl.name  AS level_name,
        rl.icon  AS level_icon,
        rl.points_required,
        (SELECT MIN(points_required) FROM reward_levels
         WHERE points_required > u.total_points) AS next_level_points,
        (SELECT COUNT(*) FROM scan_history sh WHERE sh.user_id = u.id) AS total_scans
    FROM users u
    JOIN reward_levels rl ON u.reward_level_id = rl.id
    WHERE u.id = ?
');
$stmt->execute([$userId]);
$user = $stmt->fetch();

if (!$user) {
    respond(false, 'Usuario no encontrado', [], 404);
}

respond(true, 'OK', ['user' => $user]);
