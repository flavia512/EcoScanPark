# eco_scan_park

# Manual de Usuario – EcoScanPark

EcoScanPark es una aplicación móvil que incentiva el reciclaje y la conciencia ambiental a través de la recolección de puntos y recompensas por escanear códigos QR en puntos ecológicos.

## Índice
1. [Registro e Inicio de Sesión](#registro-e-inicio-de-sesión)
2. [Pantalla Principal (Home)](#pantalla-principal-home)
3. [Escanear Códigos QR](#escanear-códigos-qr)
4. [Historial de Reciclaje](#historial-de-reciclaje)
5. [Recompensas](#recompensas)
6. [Perfil de Usuario](#perfil-de-usuario)
7. [Preguntas Frecuentes](#preguntas-frecuentes y maual para el usuario )

---
## Guía Técnica de Instalación y Ejecución

### 1. Compilar y ejecutar la app Flutter

1. Instala [Flutter](https://docs.flutter.dev/get-started/install) y asegúrate de tenerlo en tu PATH.
2. Abre una terminal en la carpeta `eco_scan_park`.
3. Ejecuta:
	```sh
	flutter pub get
	flutter run
	```
	Puedes usar `flutter run -d chrome` para web, o conectar un dispositivo/emulador para Android/iOS.

### 2. Configurar la API (backend PHP)

1. Instala [XAMPP](https://www.apachefriends.org/) y asegúrate de que **Apache** y **MySQL** estén corriendo.
2. Copia la carpeta `api_php` a `C:/xampp/htdocs/ecoscanpark/`.
3. Verifica las credenciales de la base de datos en `api_php/config/database.php`:
	- Host: `localhost`
	- Usuario: `root`
	- Contraseña: (vacío por defecto en XAMPP)
	- Base de datos: `ecoscanpark`

### 3. Importar la base de datos

1. Abre `http://localhost/phpmyadmin` en tu navegador.
2. Crea una base de datos llamada `ecoscanpark`.
3. Importa el archivo `ecoscanpark.sql` (está en la raíz del proyecto).

### 4. Probar la API

Puedes probar los endpoints usando Postman o desde la app. Ejemplo:

```
POST http://localhost/ecoscanpark/api/auth/login.php
Body (JSON):
{
  "email": "usuario@correo.com",
  "password": "tu_contraseña"
}
```

---

## 1. Registro e Inicio de Sesión
Al abrir la app, puedes registrarte con tu nombre, correo y contraseña y te redirigira directo al home, o iniciar sesión si ya tienes una cuenta. Completa los campos requeridos y pulsa el botón correspondiente.

## 2. Pantalla Principal (Home)
Aquí verás tu nombre, puntos acumulados y accesos rápidos para escanear, ver recompensas, historial y perfil. También puedes ver acciones rápidas y tu progreso.

## 3. Escanear Códigos QR
Pulsa el botón de escanear para activar la cámara. Apunta al código QR de un punto ecológico. Si el escaneo es exitoso, sumarás puntos y verás un resumen del reciclaje realizado.

## 4. Historial de Reciclaje
En la sección "Mi historial" puedes consultar todos tus escaneos previos, con detalles de fecha, tipo de residuo y puntos obtenidos.

## 5. Recompensas
Accede a "Mis recompensas" para ver los premios disponibles y los que ya has canjeado. Canjea tus puntos por recompensas ecológicas desde esta sección.

## 6. Perfil de Usuario
En "Mi perfil" puedes ver y editar tu información personal, como nombre y correo. También puedes consultar tu código QR personal para que puedas compartir la app al segundo.

## 7. Ayuda al usuario
Dentro de perfil hay un opcion donde encontraras toda la ayuda para que puedas navegar perfectamente sin lios dentro de la app 
---

