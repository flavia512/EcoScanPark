<div align="center">

# 🌿 EcoScanPark

**App móvil de clasificación de residuos con escaneo de envases, puntos y recompensas para visitantes de parques.**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![PHP](https://img.shields.io/badge/Backend-PHP-777BB4?logo=php&logoColor=white)](https://www.php.net)
[![MySQL](https://img.shields.io/badge/Database-MySQL-4479A1?logo=mysql&logoColor=white)](https://www.mysql.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

---

## 📱 ¿Qué es EcoScanPark?

EcoScanPark es una aplicación móvil diseñada para **Parques Reunidos** que gamifica el reciclaje de los visitantes. Los usuarios escanean sus residuos, aprenden en qué contenedor depositarlos y acumulan **puntos EcoScan** que pueden canjear por recompensas exclusivas dentro del parque.

> 🎯 Objetivo: fomentar el reciclaje responsable de forma divertida, educativa y con incentivos reales.

---

## ✨ Funcionalidades principales

| Feature | Descripción |
|---|---|
| 📷 **Escaneo de envases** | Escanea el código QR del residuo para identificar su tipo y ganar puntos |
| ♻️ **Guía de contenedores** | Indica en qué contenedor depositar cada residuo (Amarillo, Verde, Gris) |
| ⭐ **Sistema de puntos** | Gana puntos por cada residuo correctamente clasificado |
| 🏆 **Niveles y recompensas** | Sube de nivel (Reciclador → Guardabosques → Héroe Verde → Campeón) y canjea premios |
| 🔖 **QR personal** | Cada usuario tiene su QR único para identificarse en las máquinas del parque |
| 📊 **Historial de escaneos** | Registro completo de todos tus reciclajes y puntos ganados |
| 🎁 **Canje de recompensas** | Redime tus puntos por beneficios exclusivos en el parque |

---

## 💰 Puntos por residuo

| Residuo | Tipo | Puntos |
|---|---|---|
| 🍶 Botella de plástico | PET reciclable | +15 pts |
| 🥫 Lata de aluminio | Aluminio reciclable | +20 pts |
| 📦 Cartón | Papel y cartón limpio | +12 pts |
| 🥦 Restos de comida | Orgánico compostable | +10 pts |

---

## 🏅 Sistema de niveles

```
  50 pts → 🌱 Reciclador
 120 pts → 🌲 Guardabosques
 250 pts → ⚡ Héroe Verde
 400 pts → 🏆 Campeón Recycle
```

---

## 🛠️ Tecnologías usadas

### Frontend — App Móvil
- **Flutter / Dart** — UI multiplataforma (Android, iOS, Web)
- **Provider** — gestión de estado
- **QR Flutter** — generación de códigos QR
- **FL Chart** — gráficos y estadísticas
- **Google Fonts** — tipografía personalizada
- **HTTP** — comunicación con la API REST

### Backend — API REST
- **PHP** — servidor de lógica de negocio
- **MySQL** — base de datos relacional
- **REST API** — endpoints para autenticación, escaneos, puntos y recompensas

---

## 📁 Estructura del proyecto

```
EcoScanPark/
├── eco_scan_park/          # App Flutter
│   ├── lib/
│   │   ├── screens/        # Pantallas (home, scanner, rewards, history…)
│   │   ├── models/         # Modelos de datos (usuario, recompensas…)
│   │   ├── providers/      # Gestión de estado con Provider
│   │   ├── services/       # Llamadas a la API REST
│   │   └── core/           # Tema y estilos globales
│   └── pubspec.yaml
├── api_php/                # Backend PHP
│   ├── api/
│   │   ├── auth/           # Login y registro
│   │   ├── scan/           # Lógica de escaneo
│   │   ├── rewards/        # Recompensas y canje
│   │   ├── history/        # Historial de usuario
│   │   └── user/           # Datos de perfil
│   └── config/             # Configuración de base de datos
└── ecoscanpark.sql         # Schema de la base de datos
```

---

## 🚀 Cómo ejecutar el proyecto

### Requisitos previos
- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.7`
- PHP `^8.0` + MySQL
- Un servidor local (XAMPP, Laragon, etc.)

### 1. Clonar el repositorio
```bash
git clone https://github.com/flavia512/EcoScanPark.git
cd EcoScanPark
```

### 2. Configurar la base de datos
```bash
# Importar el schema en MySQL
mysql -u root -p < ecoscanpark.sql
```

### 3. Configurar el backend PHP
```bash
# Copiar la carpeta api_php/ a tu servidor (htdocs, www…)
# Editar api_php/config/ con tus credenciales de base de datos
```

### 4. Lanzar la app Flutter
```bash
cd eco_scan_park
flutter pub get
flutter run
```

---

## 👩‍💻 Autora

**Flavia** — [@flavia512](https://github.com/flavia512)

---

<div align="center">
  <sub>Proyecto desarrollado con 💚 para promover el reciclaje responsable en espacios de ocio.</sub>
</div>
