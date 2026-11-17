# cinemapedia

## 📚1. Documentación

Esta aplicación permite a los usuarios explorar una amplia variedad de películas, ver detalles específicos de cada una, y mantenerse actualizados con las últimas novedades en el mundo del cine.

### 1.1 Descripción de la Aplicación

Cinemapedia es una aplicación móvil que ofrece una interfaz intuitiva y atractiva para que los usuarios puedan descubrir y explorar películas. La aplicación utiliza diversas APIs para obtener información actualizada sobre películas, incluyendo detalles como sinopsis, elenco, fechas de lanzamiento, y más. Además, la aplicación está diseñada para ser rápida y eficiente, proporcionando una experiencia de usuario fluida y agradable.

### 1.2 Bibliotecas y Dependencias Utilizadas

- **cached_network_image:** Caché en disco y memoria para las imágenes de TMDB y YouTube.

- **card_swiper:** Utilizada para crear carruseles de tarjetas.

- **dio:** Dio es una biblioteca de cliente HTTP que se utiliza para realizar solicitudes a las APIs (con timeouts y mapeo de errores a dominio).

- **flutter_dotenv:** Esta biblioteca permite cargar variables de entorno desde un archivo .env.

- **flutter_localizations:** Localización de los widgets de Material al español.

- **flutter_riverpod:** Riverpod es una biblioteca de gestión de estado que facilita la creación de aplicaciones escalables y mantenibles.

- **go_router:** Go Router es una biblioteca de enrutamiento para Flutter que simplifica la navegación dentro de la aplicación. Permite definir rutas de manera declarativa y manejar la navegación de manera eficiente.

- **intl:** La biblioteca intl se utiliza para la internacionalización y formateo de fechas y números.

- **isar / isar_flutter_libs:** Base de datos local para las películas favoritas.

- **shared_preferences:** Historial local de búsquedas recientes.

- **youtube_player_flutter:** Reproductor de los trailers en la pantalla de videos.

> **Plataformas soportadas:** Android e iOS como experiencia base (player embebido de YouTube). En Linux/Windows/macOS la app funciona completa: los trailers se reproducen **dentro de la app** con `media_kit`, extrayendo el stream público de YouTube con `youtube_explode_dart` (mismo mecanismo que usan reproductores open source como NewPipe o yt-dlp). Es una solución no oficial: si YouTube cambia su backend puede dejar de funcionar, y en ese caso la pantalla ofrece **"Ver en YouTube"** para abrir el video en el navegador del sistema.
>
> **Requisitos para compilar en Linux:** `media_kit` enlaza contra el libmpv del sistema. En Ubuntu/Debian: `sudo apt install libmpv-dev` (ya vienen `libepoxy-dev` y las GTK que usa Flutter).

> **Nota de seguridad:** `.env` se empaqueta dentro del binario para que la app lea la API key de TMDB. Restringí la key desde la consola de TMDB (por referrer/paquete) para evitar usos indebidos.

## 💻2. Variables de entorno

```sh
# Crear el archivo de variables de entono
touch .env
```

En el archivo `.env`, tomar como base el archivo de `example.env`, para crear las variables

---

## 💾3. Isar Database

Base de datos con Isar (NoSQL)

<https://isar.dev/es/>

<https://isar.dev/es/tutorials/quickstart.html>

```sh
# Ejecutar el generador de código

# Con Flutter
flutter pub run build_runner build

# Con Dart
dart run build_runner build
```

## 📀4. API - The Movie DB

- Iniciar sesión en la página
- Ir al menú de **ajustes**
- Ir a la sección de **API**
- Crear o generar una **API KEY**
- Copiar esa API KEY en las **variables de entorno**

URL de la API: <https://www.themoviedb.org/>

Documentación de desarrollo: <https://developer.themoviedb.org/docs/getting-started>

Endpoints: <https://developer.themoviedb.org/reference/authentication-how-do-i-generate-a-session-id>

---

## ⛑️5. Ayuda

### 🗺️5.1 Guías

**Comillas simples en vez de dobles:**

Abrir el archivo de `analysis_options.yaml` y establecer la siguiente configuración:

```sh
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_single_quotes: true # Aquí se habilita
```

```sh
# Analizar el código y ver los problemas encontrados por el linter
flutter analyze

# Corregir automáticamente las correcciones sugeridas (ej: Comillas simples por dobles)
dart fix --apply
````

---

### ⌨️5.2 Comandos

```sh
# Instalar los paquetes o dependencias
flutter pub get

# Compilar y ejecutar la aplicación en un dispositivo conectado o emulador
flutter run
```

```sh
# Limpiar temporales
flutter clean

# Ejecutar el doctor para validar si todo está correcto
flutter doctor
```

---

## 🧪6. Tests y CI

```sh
# Ejecutar todos los tests (unitarios y de widgets)
flutter test

# Regenerar el código de Isar tras cambiar las colecciones
dart run build_runner build --delete-conflicting-outputs
```

El workflow de GitHub Actions (`.github/workflows/ci.yml`) corre `flutter analyze`, `flutter test` y el chequeo de formato en cada push y pull request.

---

## 🎨7. Iconos

La identidad visual de la app vive en `brand/` como fuente única:

- `brand/icon.svg` → tile de la app (fondo `#1E293B` + claqueta en `#B3261E`).
- `brand/mark.svg` → solo la claqueta, con `currentColor` (adaptive icon y monochrome de Android).

Los PNG/ICO de cada plataforma (Android, iOS, macOS, Windows y web) se generan desde esos SVG:

```sh
# Requiere Google Chrome/Chromium + Python 3 con Pillow
./scripts/generate-icons.sh
```

> **Importante:** los archivos generados se commitean, pero **no se editan a mano**. Para cambiar el icono se edita `brand/` y se vuelve a ejecutar el script (es idempotente: dos corridas producen los mismos archivos). Linux queda fuera porque el template de este repo no define icono de ventana.
