<?php
// ============================================================
//  GET /api/history/list.php          (requiere auth)
//  Query params: ?limit=20&offset=0
// ============================================================
require_once __DIR__ . '/../../config/helpers.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    respond(false, 'Método no permitido', [], 405);
}

$userId = requireAuth();
$limit  = min((int)($_GET['limit']  ?? 20), 50);
$offset = max((int)($_GET['offset'] ?? 0),  0);

$db = getDB();

$stmt = $db->prepare('
    SELECT
        sh.id,
        sh.scanned_at,
        p.name        AS product_name,
        p.material,
        wt.label      AS waste_label,
        wt.code       AS waste_code,
        wt.bin_color,
        sh.points_earned
    FROM scan_history sh
    JOIN products p     ON sh.product_id   = p.id
    JOIN waste_types wt ON p.waste_type_id = wt.id
    WHERE sh.user_id = ?
    ORDER BY sh.scanned_at DESC
    LIMIT ? OFFSET ?
');
$stmt->execute([$userId, $limit, $offset]);
$rows = $stmt->fetchAll();

// Total
$countStmt = $db->prepare('SELECT COUNT(*) AS total FROM scan_history WHERE user_id = ?');
$countStmt->execute([$userId]);
$total = (int) $countStmt->fetch()['total'];

respond(true, 'OK', [
    'history' => $rows,
    'total'   => $total,
    'limit'   => $limit,
    'offset'  => $offset,
]);
