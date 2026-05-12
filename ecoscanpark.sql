-- ============================================================
--  EcoScanPark — Base de datos para XAMPP / MySQL
--  Importar en phpMyAdmin o ejecutar:
--  mysql -u root -p < ecoscanpark.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS ecoscanpark
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE ecoscanpark;

-- ============================================================
-- TABLA: waste_types  (tipos de residuo)
-- ============================================================
CREATE TABLE IF NOT EXISTS waste_types (
    id         TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    code       VARCHAR(20)  NOT NULL UNIQUE,
    label      VARCHAR(50)  NOT NULL,
    bin_color  VARCHAR(30)  NOT NULL,
    icon       VARCHAR(10)  NOT NULL,
    points_multiplier DECIMAL(3,2) NOT NULL DEFAULT 1.00,
    is_recyclable BOOLEAN NOT NULL DEFAULT TRUE
);

INSERT INTO waste_types (code, label, bin_color, icon, points_multiplier, is_recyclable) VALUES
('recyclable',     'Reciclable',    'Amarillo', 'R', 1.00, TRUE),
('organic',        'Organico',      'Verde',    'O', 0.80, FALSE),
('non_recyclable', 'No Reciclable', 'Gris',     'N', 0.50, FALSE);

-- ============================================================
-- TABLA: reward_levels  (niveles de usuario)
-- ============================================================
CREATE TABLE IF NOT EXISTS reward_levels (
    id               TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name             VARCHAR(30) NOT NULL,
    icon             VARCHAR(10) NOT NULL,
    points_required  SMALLINT UNSIGNED NOT NULL,
    description      VARCHAR(100)
);

INSERT INTO reward_levels (name, icon, points_required, description) VALUES
('Explorador',    'L1', 0,    'Nivel inicial - empieza tu aventura ecologica'),
('Guardabosques', 'L2', 200,  'Has demostrado tu compromiso con la naturaleza'),
('Ecologista',    'L3', 500,  'Eres un verdadero defensor del medio ambiente'),
('Guardian Eco',  'L4', 1000, 'El nivel mas alto - leyenda viviente del parque');

-- ============================================================
-- TABLA: users
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id               CHAR(36)     PRIMARY KEY DEFAULT (UUID()),
    name             VARCHAR(80)  NOT NULL,
    email            VARCHAR(120) NOT NULL UNIQUE,
    password_hash    VARCHAR(255) NOT NULL,
    total_points     SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    visits           SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    facilities       TINYINT UNSIGNED NOT NULL DEFAULT 0,
    reward_level_id  TINYINT UNSIGNED NOT NULL DEFAULT 1,
    created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reward_level_id) REFERENCES reward_levels(id)
);

INSERT INTO users (id, name, email, password_hash, total_points, visits, facilities, reward_level_id) VALUES
-- Contraseña de todos: password123
-- Hash generado con password_hash('password123', PASSWORD_BCRYPT)
('u001-0000-0000-0000-000000000001', 'David Garcia',   'david@ecoscanpark.com',  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1250, 8, 2, 3),
('u002-0000-0000-0000-000000000002', 'Maria Lopez',    'maria@ecoscanpark.com',  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 480,  5, 1, 2),
('u003-0000-0000-0000-000000000003', 'Carlos Ruiz',    'carlos@ecoscanpark.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1050, 12,3, 4),
('u004-0000-0000-0000-000000000004', 'Ana Martinez',   'ana@ecoscanpark.com',    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 320,  3, 0, 2),
('u005-0000-0000-0000-000000000005', 'Luis Fernandez', 'luis@ecoscanpark.com',   '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 90,   1, 0, 1);

-- ============================================================
-- TABLA: park_zones  (zonas del parque)
-- ============================================================
CREATE TABLE IF NOT EXISTS park_zones (
    id          TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(60) NOT NULL,
    description VARCHAR(120)
);

INSERT INTO park_zones (name, description) VALUES
('Entrada Principal', 'Zona de bienvenida y taquillas'),
('Zona Fauna',        'Area de observacion de animales'),
('Zona Flora',        'Jardines botanicos y senderos'),
('Area de Descanso',  'Restaurantes y zonas de picnic'),
('Zona Aventura',     'Actividades y atracciones');

-- ============================================================
-- TABLA: kiosks  (kioscos de reciclaje)
-- ============================================================
CREATE TABLE IF NOT EXISTS kiosks (
    id                   TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    code                 VARCHAR(20) NOT NULL UNIQUE,
    zone_id              TINYINT UNSIGNED NOT NULL,
    location_description VARCHAR(100),
    is_active            BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (zone_id) REFERENCES park_zones(id)
);

INSERT INTO kiosks (code, zone_id, location_description) VALUES
('KIOSK-01', 1, 'Junto a la entrada principal derecha'),
('KIOSK-02', 2, 'Frente al aviario'),
('KIOSK-03', 3, 'Al inicio del sendero de orquideas'),
('KIOSK-04', 4, 'Area de mesas de picnic norte'),
('KIOSK-05', 5, 'Cerca de las atracciones de aventura');

-- ============================================================
-- TABLA: products  (productos registrados)
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
    id            SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    barcode       VARCHAR(30) UNIQUE,
    name          VARCHAR(100) NOT NULL,
    material      VARCHAR(60)  NOT NULL,
    waste_type_id TINYINT UNSIGNED NOT NULL,
    points_value  TINYINT UNSIGNED NOT NULL DEFAULT 10,
    is_active     BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (waste_type_id) REFERENCES waste_types(id)
);

INSERT INTO products (barcode, name, material, waste_type_id, points_value) VALUES
('7501031311309', 'Botella de Agua PET',   'PET / Plastico',   1, 15),
('6111244040396', 'Lata de Refresco',       'Aluminio',         1, 20),
('8410076486250', 'Caja de Carton',         'Carton',           1, 12),
('4006381333931', 'Periodico / Papel',      'Papel',            1,  8),
('5449000000996', 'Botella de Vidrio',      'Vidrio',           1, 18),
('0012000001086', 'Envase Plastico HDPE',   'HDPE / Plastico',  1, 13),
('ORG-001',       'Restos de Fruta',        'Materia organica', 2, 10),
('ORG-002',       'Cascara de Huevo',       'Materia organica', 2, 10),
('ORG-003',       'Restos de Comida',       'Materia organica', 2,  8),
('NR-001',        'Bolsa Plastica Sucia',   'Plastico sucio',   3,  5),
('NR-002',        'Unicel / Poliestireno',  'Poliestireno',     3,  5);

-- ============================================================
-- TABLA: scan_history
-- ============================================================
CREATE TABLE IF NOT EXISTS scan_history (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id       CHAR(36) NOT NULL,
    product_id    SMALLINT UNSIGNED NOT NULL,
    kiosk_id      TINYINT UNSIGNED,
    points_earned TINYINT UNSIGNED NOT NULL,
    scanned_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)    REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (kiosk_id)   REFERENCES kiosks(id)
);

INSERT INTO scan_history (user_id, product_id, kiosk_id, points_earned, scanned_at) VALUES
('u001-0000-0000-0000-000000000001', 1, 1, 15, '2025-05-01 09:12:00'),
('u001-0000-0000-0000-000000000001', 2, 1, 20, '2025-05-01 09:14:00'),
('u001-0000-0000-0000-000000000001', 3, 2, 12, '2025-05-03 10:30:00'),
('u001-0000-0000-0000-000000000001', 5, 3, 18, '2025-05-05 11:05:00'),
('u001-0000-0000-0000-000000000001', 6, 4, 13, '2025-05-07 14:22:00'),
('u001-0000-0000-0000-000000000001', 1, 2, 15, '2025-05-10 08:55:00'),
('u002-0000-0000-0000-000000000002', 7, 3, 10, '2025-05-02 12:00:00'),
('u002-0000-0000-0000-000000000002', 4, 1,  8, '2025-05-04 13:45:00'),
('u003-0000-0000-0000-000000000003', 2, 5, 20, '2025-05-01 10:00:00'),
('u003-0000-0000-0000-000000000003', 3, 5, 12, '2025-05-06 09:30:00'),
('u004-0000-0000-0000-000000000004', 8, 4, 10, '2025-05-09 16:00:00'),
('u005-0000-0000-0000-000000000005', 9, 3,  8, '2025-05-11 10:20:00');

-- ============================================================
-- TABLA: points_transactions
-- ============================================================
CREATE TABLE IF NOT EXISTS points_transactions (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     CHAR(36) NOT NULL,
    amount      SMALLINT NOT NULL,
    type        ENUM('earned','redeemed') NOT NULL,
    description VARCHAR(120),
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO points_transactions (user_id, amount, type, description) VALUES
('u001-0000-0000-0000-000000000001',  15,  'earned',   'Escaneo: Botella de Agua PET'),
('u001-0000-0000-0000-000000000001',  20,  'earned',   'Escaneo: Lata de Refresco'),
('u001-0000-0000-0000-000000000001',  12,  'earned',   'Escaneo: Caja de Carton'),
('u001-0000-0000-0000-000000000001', -120, 'redeemed', 'Canje: Bebida Refrescante'),
('u002-0000-0000-0000-000000000002',  10,  'earned',   'Escaneo: Restos de Fruta'),
('u002-0000-0000-0000-000000000002',   8,  'earned',   'Escaneo: Periodico / Papel'),
('u003-0000-0000-0000-000000000003',  20,  'earned',   'Escaneo: Lata de Refresco'),
('u003-0000-0000-0000-000000000003', -280, 'redeemed', 'Canje: Acceso a atracciones');

-- ============================================================
-- TABLA: rewards  (catalogo de recompensas)
-- ============================================================
CREATE TABLE IF NOT EXISTS rewards (
    id           TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    icon         VARCHAR(10)  NOT NULL,
    name         VARCHAR(80)  NOT NULL,
    description  VARCHAR(200),
    points_cost  SMALLINT UNSIGNED NOT NULL,
    category     VARCHAR(40)  NOT NULL,
    rating       DECIMAL(2,1) NOT NULL DEFAULT 4.5,
    stock        SMALLINT UNSIGNED NOT NULL DEFAULT 100,
    is_active    BOOLEAN NOT NULL DEFAULT TRUE
);

INSERT INTO rewards (icon, name, description, points_cost, category, rating) VALUES
('[A]', 'Acceso a atracciones', 'Acceso gratuito a una atraccion del parque',            280, 'Experiencias', 4.8),
('[B]', 'Bebida Refrescante',   'Bebida natural o agua en los puntos de venta',           120, 'Alimentos',    4.6),
('[D]', 'Descuento 10%',        '10% de descuento en cualquier tienda del parque',         50, 'Descuentos',   4.4),
('[F]', 'Foto Recuerdo',        'Sesion fotografica profesional en el parque',            150, 'Experiencias', 4.7),
('[P]', 'Pack Eco Familiar',    'Kit de productos ecologicos para llevar a casa',          400, 'Especiales',   4.9),
('[C]', 'Cupon Tiendas',        'Cupon de $50 en cualquier tienda oficial del parque',     500, 'Especiales',   4.8);

-- ============================================================
-- TABLA: reward_redemptions  (historial de canjes)
-- ============================================================
CREATE TABLE IF NOT EXISTS reward_redemptions (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     CHAR(36) NOT NULL,
    reward_id   TINYINT UNSIGNED NOT NULL,
    coupon_code VARCHAR(20) NOT NULL,
    points_used SMALLINT UNSIGNED NOT NULL,
    redeemed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    used_at     DATETIME,
    FOREIGN KEY (user_id)   REFERENCES users(id),
    FOREIGN KEY (reward_id) REFERENCES rewards(id)
);

INSERT INTO reward_redemptions (user_id, reward_id, coupon_code, points_used, redeemed_at) VALUES
('u001-0000-0000-0000-000000000001', 2, 'ECO-BEB-2025-A1B2', 120, '2025-05-08 15:30:00'),
('u003-0000-0000-0000-000000000003', 1, 'ECO-ATR-2025-C3D4', 280, '2025-05-07 11:00:00');

-- ============================================================
-- VISTAS utiles
-- ============================================================

CREATE OR REPLACE VIEW v_user_ranking AS
SELECT
    u.id,
    u.name,
    u.email,
    u.total_points,
    rl.name  AS level_name,
    u.visits,
    (SELECT COUNT(*) FROM scan_history sh WHERE sh.user_id = u.id) AS total_scans,
    RANK() OVER (ORDER BY u.total_points DESC) AS ranking
FROM users u
JOIN reward_levels rl ON u.reward_level_id = rl.id;

CREATE OR REPLACE VIEW v_scan_history_detail AS
SELECT
    sh.id,
    sh.scanned_at,
    u.name        AS user_name,
    p.name        AS product_name,
    p.material,
    wt.label      AS waste_type,
    wt.bin_color,
    sh.points_earned,
    k.code        AS kiosk_code,
    pz.name       AS zone_name
FROM scan_history sh
JOIN users u        ON sh.user_id      = u.id
JOIN products p     ON sh.product_id   = p.id
JOIN waste_types wt ON p.waste_type_id = wt.id
LEFT JOIN kiosks k  ON sh.kiosk_id     = k.id
LEFT JOIN park_zones pz ON k.zone_id   = pz.id
ORDER BY sh.scanned_at DESC;

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================

-- ============================================================
-- TABLA: auth_tokens  (tokens de sesión para la API PHP)
-- ============================================================
CREATE TABLE IF NOT EXISTS auth_tokens (
    id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    token      CHAR(64) NOT NULL UNIQUE,
    user_id    CHAR(36) NOT NULL,
    expires_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
