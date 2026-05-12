# EcoScanPark — Guía de instalación del backend PHP

## Requisitos
- XAMPP con **Apache + MySQL** corriendo
- PHP 8.1+

---

## 1. Importar la base de datos

1. Abre **XAMPP Control Panel** e inicia **Apache** y **MySQL**
2. Abre el navegador en `http://localhost/phpmyadmin`
3. Crea una base de datos llamada `ecoscanpark` (si no existe)
4. Haz click en **Importar** → selecciona el archivo `ecoscanpark.sql` de la raíz del repo
5. Click en **Continuar**

---

## 2. Copiar la API a htdocs

Copia **toda la carpeta `api_php`** a la carpeta htdocs de XAMPP:

```
C:\xampp\htdocs\ecoscanpark\
```

Quedará así:

```
C:\xampp\htdocs\ecoscanpark\
  .htaccess
  config\
    database.php
    helpers.php
  api\
    auth\
      login.php
      register.php
    user\
      profile.php
    scan\
      submit.php
    history\
      list.php
    rewards\
      rewards.php
```

---

## 3. Verificar credenciales de BD

Abre `config/database.php` y revisa:

```php
define('DB_HOST', 'localhost');
define('DB_NAME', 'ecoscanpark');
define('DB_USER', 'root');
define('DB_PASS', '');   // vacío por defecto en XAMPP
```

---

## 4. Probar la API

Abre **Postman** o un navegador y prueba:

```
POST http://localhost/ecoscanpark/api/auth/login.php
Body (JSON):
{
  "email": "david@ecoscanpark.com",
  "password": "password123"
}
```

Deberías recibir:
```json
{
  "success": true,
  "message": "Login exitoso",
  "data": {
    "token": "...",
    "user": { ... }
  }
}
```

---

## 5. Conectar Flutter

En `lib/services/api_service.dart` ajusta la URL según tu caso:

| Plataforma | URL |
|---|---|
| Emulador Android | `http://10.0.2.2/ecoscanpark/api` |
| Dispositivo físico | `http://TU_IP_LOCAL/ecoscanpark/api` |
| Web / Windows | `http://localhost/ecoscanpark/api` |

Para saber tu IP local (Windows): `ipconfig` en CMD

---

## Endpoints disponibles

| Método | URL | Auth | Descripción |
|---|---|---|---|
| POST | `/auth/login.php` | ❌ | Login con email+password |
| POST | `/auth/register.php` | ❌ | Registro de nuevo usuario |
| GET | `/user/profile.php` | ✅ | Perfil del usuario autenticado |
| POST | `/scan/submit.php` | ✅ | Registrar escaneo (barcode) |
| GET | `/history/list.php` | ✅ | Historial de escaneos |
| GET | `/rewards/rewards.php` | ✅ | Catálogo de recompensas |
| POST | `/rewards/rewards.php` | ✅ | Canjear recompensa |

**Auth**: envía el header `Authorization: Bearer <token>` en los endpoints protegidos.

---

## Usuarios de prueba (del SQL)

| Email | Contraseña | Puntos |
|---|---|---|
| david@ecoscanpark.com | password123 | 1250 |
| maria@ecoscanpark.com | password123 | 480 |
| carlos@ecoscanpark.com | password123 | 1050 |
