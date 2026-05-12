<?php
// ============================================================
//  POST /api/scan/submit.php          (requiere auth)
//  Body: { "barcode": "7501031311309" }
//  Simula el escaneo: busca el producto, suma puntos al usuario
// ============================================================
require_once __DIR__ . '/../../config/helpers.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    respond(false, 'Método no permitido', [], 405);
}

$userId = requireAuth();
$body   = getBody();
$barcode = trim($body['barcode'] ?? '');

if (empty($barcode)) {
    respond(false, 'Código de barras requerido', [], 422);
}

$db = getDB();

// Buscar producto
$stmt = $db->prepare('
    SELECT p.*, wt.label AS waste_label, wt.code AS waste_code, wt.bin_color, wt.is_recyclable
    FROM products p
    JOIN waste_types wt ON p.waste_type_id = wt.id
    WHERE p.barcode = ? AND p.is_active = TRUE
');
$stmt->execute([$barcode]);
$product = $stmt->fetch();

if (!$product) {
    respond(false, 'Producto no encontrado', [], 404);
}

// Registrar escaneo
$db->prepare('
    INSERT INTO scan_history (user_id, product_id, points_earned)
    VALUES (?, ?, ?)
')->execute([$userId, $product['id'], $product['points_value']]);

// Sumar puntos al usuario
$db->prepare('
    UPDATE users SET total_points = total_points + ?, updated_at = NOW()
    WHERE id = ?
')->execute([$product['points_value'], $userId]);

// Registrar transacción
$db->prepare('
    INSERT INTO points_transactions (user_id, amount, type, description)
    VALUES (?, ?, "earned", ?)
')->execute([$userId, $product['points_value'], 'Escaneo: ' . $product['name']]);

// Actualizar nivel si corresponde
$userStmt = $db->prepare('SELECT total_points FROM users WHERE id = ?');
$userStmt->execute([$userId]);
$newPoints = (int) $userStmt->fetch()['total_points'];

$levelStmt = $db->prepare('
    SELECT id FROM reward_levels
    WHERE points_required <= ?
    ORDER BY points_required DESC
    LIMIT 1
');
$levelStmt->execute([$newPoints]);
$newLevel = $levelStmt->fetch();
if ($newLevel) {
    $db->prepare('UPDATE users SET reward_level_id = ? WHERE id = ?')
       ->execute([$newLevel['id'], $userId]);
}

respond(true, 'Escaneo registrado', [
    'scan' => [
        'product_name'  => $product['name'],
        'material'      => $product['material'],
        'waste_type'    => $product['waste_code'],
        'waste_label'   => $product['waste_label'],
        'bin_color'     => $product['bin_color'],
        'is_recyclable' => (bool) $product['is_recyclable'],
        'points_earned' => (int) $product['points_value'],
        'total_points'  => $newPoints,
    ],
]);
