# cinemapedia

Catálogo de películas de TMDB: cartelera, populares, favoritos y trailers. Hecha con Flutter para Android, iOS, Linux, Windows y macOS.

<div align="center">

| Inicio | Detalle | Populares |
|:---:|:---:|:---:|
| ![Inicio](docs/screenshots/home.webp) | ![Detalle de película](docs/screenshots/movie-details.webp) | ![Películas populares](docs/screenshots/popular.webp) |

| Favoritos | Buscador | Explorar |
|:---:|:---:|:---:|
| ![Favoritos](docs/screenshots/favorites.webp) | ![Buscador](docs/screenshots/search.webp) | ![Explorar géneros](docs/screenshots/genres.webp) |

</div>

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

- **media_kit / media_kit_video:** Reproductor de video embebido en escritorio (con los paquetes `media_kit_libs_*` de cada plataforma).

- **package_info_plus:** Versión y número de build de la app en runtime (diálogo "Acerca de").

- **path_provider:** Directorios del sistema para el caché de imágenes y los datos locales.

- **share_plus:** Compartir enlaces de películas desde la app.

- **shared_preferences:** Historial local de búsquedas recientes.

- **url_launcher:** Abrir YouTube y otros enlaces externos en el navegador del sistema.

- **youtube_explode_dart:** Extrae el stream público de YouTube para reproducir trailers en escritorio.

- **youtube_player_flutter:** Reproductor de los trailers en la pantalla de videos (Android e iOS).

> **Plataformas soportadas:** Android e iOS como experiencia base (player embebido de YouTube). En Linux/Windows/macOS la app funciona completa: los trailers se reproducen **dentro de la app** con `media_kit`, extrayendo el stream público de YouTube con `youtube_explode_dart` (mismo mecanismo que usan reproductores open source como NewPipe o yt-dlp). Es una solución no oficial: si YouTube cambia su backend puede dejar de funcionar, y en ese caso la pantalla ofrece **"Ver en YouTube"** para abrir el video en el navegador del sistema.
>
> **Requisitos para compilar en Linux:** `media_kit` enlaza contra el libmpv del sistema. En Ubuntu/Debian: `sudo apt install libmpv-dev` (ya vienen `libepoxy-dev` y las GTK que usa Flutter).

> **Nota de seguridad:** `.env` se empaqueta dentro del binario para que la app lea la API key de TMDB. Restringí la key desde la consola de TMDB (por referrer/paquete) para evitar usos indebidos.

## 💻2. Variables de entorno

```sh
# Crear el archivo de variables de entorno
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

# Con Dart
dart run build_runner build

# Con Flutter (equivalente)
flutter pub run build_runner build
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
```

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

Los tests de integración viven en `integration_test/` y se ejecutan con `flutter drive` sobre un dispositivo real (no corren en la CI; ver §7.2 para las capturas del README).

---

## 🎨7. Iconos y capturas

### 🖼️7.1 Iconos

La identidad visual de la app vive en `brand/` como fuente única:

- `brand/icon.svg` → tile de la app (fondo `#1E293B` + claqueta en `#B3261E`).
- `brand/mark.svg` → solo la claqueta, con `currentColor` (adaptive icon y monochrome de Android).

Los PNG/ICO de cada plataforma (Android, iOS, macOS, Windows y web) se generan desde esos SVG:

```sh
# Requiere Google Chrome/Chromium + Python 3 con Pillow
./scripts/generate-icons.sh
```

> **Importante:** los archivos generados se commitean, pero **no se editan a mano**. Para cambiar el icono se edita `brand/` y se vuelve a ejecutar el script (es idempotente: dos corridas producen los mismos archivos). Linux queda fuera porque el template de este repo no define icono de ventana (el launcher del `.deb` usa el PNG generado en `web/icons/`).

### 📸7.2 Capturas del README

Las capturas de `docs/screenshots/` (las del inicio de este README) se generan con:

```sh
# Requiere flutter con soporte de escritorio Linux, conexión a Internet
# y Python 3 con Pillow (igual que generate-icons.sh)
./scripts/capture-screenshots.sh
```

El script ejecuta un test de integración (`integration_test/screenshots_test.dart`) que corre la app real en una ventana, la navega con toques (inicio, detalle, populares, favoritos, buscador y géneros) y captura el árbol de render en tamaño de teléfono y tema oscuro, sin importar la ventana ni el tema del sistema. Al final convierte los PNG a WebP para que el README no pese de más.

> **Importante:** las capturas se commitean, pero **no se editan a mano**. Para actualizarlas se vuelve a ejecutar el script (el contenido depende del catálogo vigente de TMDB).

---

## 🚀8. Compilación y distribución

### 🔢8.1 Versionamiento

La versión vive en `pubspec.yaml` con el formato de Flutter `x.y.z+número de build` (ej: `0.2.0+3`):

- **`x.y.z`** → versión visible para el usuario. Se cambia con los flags del script cuando hay cambios importantes.
- **`+N`** → número de build (`versionCode` en Android). Se incrementa automáticamente en cada release.

```sh
# Subir el número de build (0.2.0+3 -> 0.2.0+4)
./scripts/bump-build.sh

# Cambios visibles para el usuario (reinician el número de build en 1)
./scripts/bump-build.sh --patch   # 0.2.0+3 -> 0.2.1+1
./scripts/bump-build.sh --minor   # 0.2.1+1 -> 0.3.0+1
./scripts/bump-build.sh --major   # 0.3.0+1 -> 1.0.0+1
```

La versión se propaga sola a cada plataforma: Android la usa como `versionName`/`versionCode`, y en escritorio Flutter escribe un `version.json` dentro del bundle. La app la muestra en el diálogo **"Acerca de"** (ícono ⓘ en la barra superior), lo que ayuda a saber qué build tiene instalada cada persona.

Los scripts de release (`build-apk.sh` / `build-deb.sh`) invocan el bump automáticamente antes de compilar. Si querés publicar el APK y el `.deb` con **el mismo** número de build, compilá el segundo con `--no-bump`. El bump modifica `pubspec.yaml`: commiteá el cambio junto al release (opcionalmente con un tag `git tag v0.2.0`).

### 🤖8.2 Android — APK

**Requisitos:** `flutter` en el PATH y el Android SDK configurado (`flutter doctor`).

```sh
# Compilar el instalador (incrementa el número de build y compila en release)
./scripts/build-apk.sh

# Variante: compilar sin cambiar la versión
./scripts/build-apk.sh --no-bump
```

El instalador queda en `dist/cinemapedia-<versión>-android.apk` (un solo APK con todas las arquitecturas).

```sh
# Instalar en un dispositivo/emulador conectado
adb install dist/cinemapedia-*-android.apk
```

También se puede copiar el APK al teléfono y abrirlo desde el gestor de archivos (habilitando la instalación de "orígenes desconocidos").

> **Firma:** por ahora la release se firma con las llaves de debug (ver `android/app/build.gradle`), lo que alcanza para instalar manualmente. Para publicar en Google Play hace falta un keystore propio y configurar `key.properties`.

> **Toolchain Android:** el proyecto usa AGP 9.1 + Gradle 9.3.1 (los del template de Flutter 3.47), compatibles con Java 21. `android/build.gradle` completa automáticamente el `namespace` de los plugins viejos que no lo declaran (p. ej. `isar_flutter_libs` 3.x), que AGP 8+ exige.

### 🐧8.3 Linux — `.deb`

**Requisitos:** `flutter` con soporte de escritorio, el paquete `dpkg` (aporta `dpkg-deb`) y las dependencias de compilación de `media_kit` (Ubuntu/Debian: `sudo apt install libmpv-dev`).

```sh
# Compilar y empaquetar (incrementa el número de build, compila y genera el .deb)
./scripts/build-deb.sh

# Variante: empaquetar sin cambiar la versión
./scripts/build-deb.sh --no-bump
```

El paquete queda en `dist/cinemapedia_<versión>_<arquitectura>.deb`.

```sh
# Instalar (apt resuelve las dependencias de runtime)
sudo apt install ./dist/cinemapedia_*_*.deb

# Desinstalar
sudo apt remove cinemapedia
```

El paquete instala el binario y sus librerías en `/opt/cinemapedia/`, un symlink en `/usr/bin/cinemapedia`, el acceso del menú de aplicaciones (`com.example.cinemapedia.desktop`) y el icono del launcher (el PNG de `web/icons/`). Las dependencias del `control` se calculan automáticamente con `readelf` + `dpkg -S` sobre las librerías que enlaza el bundle, por lo que reflejan la distro donde se compila.
