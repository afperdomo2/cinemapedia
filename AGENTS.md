# AGENTS.md — Cinemapedia

Catálogo de películas de TMDB (Flutter: Android, iOS, Linux, Windows, macOS).
Este archivo resume lo que un agente necesita saber para trabajar en el repo.
La documentación completa de cara al usuario está en `README.md`.

## Comandos que exige la CI

Ejecutar antes de terminar cualquier cambio (`.github/workflows/ci.yml`):

```sh
flutter analyze                                           # sin issues
dart format --output=none --set-exit-if-changed .         # formato estable
flutter test                                              # tests unitarios y de widgets
```

Los tests de integración (`integration_test/`) **no** corren en la CI.

## Convenciones

- **Comillas simples** obligatorias (`prefer_single_quotes` en `analysis_options.yaml`).
  Corregir con `dart fix --apply` si hace falta.
- **Idioma**: textos de UI y comentarios en español.
- **Isar**: tras cambiar las colecciones, regenerar con
  `dart run build_runner build --delete-conflicting-outputs`.
- **`card_swiper`** está parcheado localmente (`dependency_overrides` →
  `packages/card_swiper`, ver `packages/card_swiper/PATCHES.md`); no actualizar
  a ciegas desde pub.
- **Versiones**: `scripts/bump-build.sh` maneja `version: x.y.z+N` de
  `pubspec.yaml`; los releases lo invocan solos. Usar `--no-bump` para compilar
  sin cambiar la versión (p. ej. para publicar APK y `.deb` con el mismo número
  de build). El bump deja el cambio en `pubspec.yaml` sin commitear: va junto al
  commit del release.

## Scripts del repo

| Script | Para qué |
|---|---|
| `scripts/build-apk.sh` | Compila el APK de Android a `dist/` (bump automático) |
| `scripts/build-deb.sh` | Compila y empaqueta el `.deb` de Linux a `dist/` |
| `scripts/bump-build.sh` | Sube versión/build (`--patch`/`--minor`/`--major`) |
| `scripts/generate-icons.sh` | Regenera iconos desde `brand/` (Chrome + Pillow) |
| `scripts/capture-screenshots.sh` | Regenera las capturas del README (ver abajo) |

## Capturas del README (`docs/screenshots/`)

Las 6 capturas que se muestran al inicio del README se generan con:

```sh
./scripts/capture-screenshots.sh
```

**Requisitos**: `flutter` con escritorio Linux, conexión a Internet (catálogo
de TMDB) y Python 3 con Pillow (`sudo apt install python3-pil`).

### Cómo funciona

1. `flutter drive` ejecuta `integration_test/screenshots_test.dart` sobre la
   app real en una ventana de escritorio.
2. El test navega la UI con toques: inicio → detalle de la película destacada →
   populares → favoritos → buscador ("Dune") → géneros. Los favoritos se siembran
   en Isar de forma **idempotente** (8 películas de "Populares"; Isar persiste
   entre corridas y un `toggle` a secas las borraría).
3. Las capturas se toman del **árbol de render** (no de la ventana) con tamaño
   de teléfono (420×864 lógicos @2x → 840×1728 px) y **tema oscuro forzado**,
   independientemente de la ventana y del tema del sistema. Así las capturas
   muestran la barra de navegación inferior (en ≥600 lógicos la app cambia a
   `NavigationRail`).
4. El script convierte los PNG a WebP (calidad 82) en `docs/screenshots/` y
   borra los PNG.

### Archivos generados (el README los referencia por nombre exacto)

`home.webp`, `movie-details.webp`, `popular.webp`, `favorites.webp`,
`search.webp`, `genres.webp` — **no renombrar** sin actualizar las tablas del
README.

### Gotchas aprendidos al armarlo

- **Imágenes de red**: `TmdbImage` muestra un placeholder GIF mientras carga.
  El test espera a que **no quede ningún placeholder** (`_waitForImages`) antes
  de capturar; confiar en `pumpAndSettle` no basta porque la app renderiza sola
  en bindings live y los pósters pueden quedar a medio cargar.
- **El buscador abre de forma asíncrona** (`RecentSearches.load()` +
  `showSearch`): hay que esperar al `TextField` antes de escribir.
- **`hitTestable()`** hace hit test real desde la raíz: sirve para distinguir la
  pantalla activa de las ramas ocultas del `StatefulShellRoute.indexedStack`.
- El contenido es **catálogo vivo de TMDB**: al regenerar, las películas
  mostradas pueden cambiar; eso es esperado.
- Los archivos se commitean pero **no se editan a mano**: para actualizarlos,
  volver a correr el script.

## Errores comunes

- **Compilar en Linux falla por libmpv**: `sudo apt install libmpv-dev`
  (requerido por `media_kit`).
- **`.env`**: la app necesita `THE_MOVIE_DB_API_KEY` (ver `example.env`); el
  test de capturas también lo carga del bundle.
- **`flutter_inappwebview` / AGP**: el proyecto está en AGP 9.x con un
  workaround de `namespace` en `android/build.gradle` (ver README §8.2).
