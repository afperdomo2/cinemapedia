#!/usr/bin/env bash
set -Eeuo pipefail

trap 'echo "❌ Error en ${BASH_SOURCE[0]} línea $LINENO" >&2' ERR

# Genera los iconos de todas las plataformas Flutter a partir de los másters
# de `brand/`.
#
#   brand/icon.svg  → tile redondeado (macOS, favicon)
#   brand/mark.svg  → glifo suelto (Android adaptive/monochrome)
#   full-bleed = glifo sobre color de marca (iOS, Windows, web PWA, launcher
#                legacy de Android)
#
# Salidas:
#   android/app/src/main/res/mipmap-*/ic_launcher.png            (legacy)
#   android/app/src/main/res/mipmap-*/ic_launcher_foreground.png (adaptive)
#   android/app/src/main/res/mipmap-*/ic_launcher_monochrome.png (temático)
#   android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml
#   android/app/src/main/res/values/ic_launcher_background.xml
#   ios/Runner/Assets.xcassets/AppIcon.appiconset/*
#   macos/Runner/Assets.xcassets/AppIcon.appiconset/*
#   windows/runner/resources/app_icon.ico
#   web/{favicon.svg,favicon.png,icons/*}
#   (Linux queda fuera: el template de este repo no define icono de ventana)
#
# Requiere Google Chrome/Chromium (render de SVG) y Python 3 + Pillow
# (downscale LANCZOS, ICO y normalización). Los resultados se commitean:
# este script es de uso manual, no corre en CI ni en los git hooks.
# No editar los PNG/ICO generados a mano: la fuente única es `brand/`.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BRAND_DIR="$ROOT_DIR/brand"
ANDROID_RES="$ROOT_DIR/android/app/src/main/res"
IOS_APPICON="$ROOT_DIR/ios/Runner/Assets.xcassets/AppIcon.appiconset"
MACOS_APPICON="$ROOT_DIR/macos/Runner/Assets.xcassets/AppIcon.appiconset"
WIN_RES="$ROOT_DIR/windows/runner/resources"
WEB_DIR="$ROOT_DIR/web"

BRAND_BG="#1E293B"
BRAND_FG="#B3261E"

die() {
  echo "❌ $*" >&2
  exit 1
}

find_chrome() {
  local bin
  for bin in \
    google-chrome \
    google-chrome-stable \
    chromium \
    chromium-browser \
    "/c/Program Files/Google/Chrome/Application/chrome.exe" \
    "/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"; do
    if command -v "$bin" >/dev/null 2>&1; then
      command -v "$bin"
      return 0
    fi
  done
  return 1
}

find_python() {
  local bin
  for bin in python3 python; do
    if command -v "$bin" >/dev/null 2>&1; then
      command -v "$bin"
      return 0
    fi
  done
  return 1
}

[[ -f "$BRAND_DIR/icon.svg" ]] || die "No existe $BRAND_DIR/icon.svg"
[[ -f "$BRAND_DIR/mark.svg" ]] || die "No existe $BRAND_DIR/mark.svg"

CHROME_BIN="$(find_chrome)" \
  || die "No encontré Chrome/Chromium. Instalalo o generá los PNG con rsvg-convert/ImageMagick."

PYTHON_BIN="$(find_python)" || die "Falta python3/python."
"$PYTHON_BIN" -c 'import PIL' 2>/dev/null || die "Falta Pillow: python3 -m pip install pillow"

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

ICON_SVG="$(cat "$BRAND_DIR/icon.svg")"
MARK_SVG="$(cat "$BRAND_DIR/mark.svg")"

# Renderiza un SVG a PNG cuadrado con Chrome headless.
#
#   render <modo> <px> <salida>
#
# Modos:
#   tile       tile redondeado, esquinas transparentes
#   full       glifo sobre fondo de marca (opaco, full-bleed)
#   full-safe  igual que full, pero con margen para iconos maskable
#   safe       glifo transparente con margen (adaptive icon Android)
#   mono       glifo blanco transparente con margen (icono temático Android)
render() {
  local mode="$1"
  local size="$2"
  local out="$3"
  local svg bg scale color

  case "$mode" in
    tile)
      svg="$ICON_SVG"
      bg="transparent"
      scale="1"
      color="$BRAND_FG"
      ;;
    full)
      svg="$MARK_SVG"
      bg="$BRAND_BG"
      scale="1"
      color="$BRAND_FG"
      ;;
    full-safe)
      svg="$MARK_SVG"
      bg="$BRAND_BG"
      # Zona segura maskable: círculo del 80% del ancho.
      scale="0.95"
      color="$BRAND_FG"
      ;;
    safe)
      svg="$MARK_SVG"
      bg="transparent"
      # Zona segura Android: círculo de 66dp sobre un lienzo de 108dp.
      scale="0.77"
      color="$BRAND_FG"
      ;;
    mono)
      svg="$MARK_SVG"
      bg="transparent"
      scale="0.77"
      color="#FFFFFF"
      ;;
    *)
      die "Modo de render desconocido: $mode"
      ;;
  esac

  local html="$TMP_DIR/render-${mode}-${size}.html"
  cat >"$html" <<HTML
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<style>
html, body { margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; background: ${bg}; }
.wrap { position: fixed; inset: 0; display: grid; place-items: center; color: ${color}; }
svg { width: 100%; height: 100%; display: block; transform: scale(${scale}); transform-origin: center; }
</style>
</head>
<body>
<div class="wrap">${svg}</div>
</body>
</html>
HTML

  "$CHROME_BIN" \
    --headless \
    --disable-gpu \
    --disable-dev-shm-usage \
    --hide-scrollbars \
    --force-device-scale-factor=1 \
    --default-background-color=00000000 \
    --window-size="${size},${size}" \
    --screenshot="$out" \
    "file://$html" >/dev/null 2>&1 \
    || die "Chrome falló al renderizar $mode a ${size}px"

  [[ -s "$out" ]] || die "Chrome no generó la imagen $out"
}

echo "🎨 Renderizando iconos desde brand/…"

# Un solo render maestro por modo; los tamaños finales salen por downscale
# LANCZOS con Pillow (más nítido que renderizar cada tamaño por separado).
render tile 1024 "$TMP_DIR/master-tile.png"
render full 1024 "$TMP_DIR/master-full.png"
render full-safe 1024 "$TMP_DIR/master-full-safe.png"
render safe 1024 "$TMP_DIR/master-safe.png"
render mono 1024 "$TMP_DIR/master-mono.png"

# Genera todos los assets de plataforma y normaliza los PNG (quita metadatos
# de Chrome para que el script sea idempotente).
"$PYTHON_BIN" - "$TMP_DIR" "$ANDROID_RES" "$IOS_APPICON" "$MACOS_APPICON" "$WIN_RES" "$WEB_DIR" <<'PY'
import sys
from pathlib import Path

from PIL import Image

tmp, android, ios, macos, win, web = (Path(p) for p in sys.argv[1:7])

masters = {}
for name in ("tile", "full", "full-safe", "safe", "mono"):
    with Image.open(tmp / f"master-{name}.png") as img:
        img.load()
        masters[name] = img.copy().convert("RGBA")


def scaled(master, size):
    return masters[master].resize((size, size), Image.LANCZOS)


def save(img, path, rgb=False):
    path.parent.mkdir(parents=True, exist_ok=True)
    img.convert("RGB" if rgb else "RGBA").save(path, format="PNG", optimize=True)


# --- Android -------------------------------------------------------------
# Launcher legacy (full-bleed) y adaptive icon (foreground con zona segura
# sobre lienzo de 108dp + monochrome para iconos temáticos de Android 13+).
density_dirs = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
for density, launcher_px in density_dirs.items():
    save(scaled("full", launcher_px), android / f"mipmap-{density}/ic_launcher.png")
    fg_px = launcher_px * 108 // 48  # lienzo 108dp * densidad
    save(scaled("safe", fg_px), android / f"mipmap-{density}/ic_launcher_foreground.png")
    save(scaled("mono", fg_px), android / f"mipmap-{density}/ic_launcher_monochrome.png")

# --- iOS -----------------------------------------------------------------
# Los iconos de iOS no deben tener canal alfa: se guardan como RGB.
ios_sizes = {
    "Icon-App-20x20@1x.png": 20,
    "Icon-App-20x20@2x.png": 40,
    "Icon-App-20x20@3x.png": 60,
    "Icon-App-29x29@1x.png": 29,
    "Icon-App-29x29@2x.png": 58,
    "Icon-App-29x29@3x.png": 87,
    "Icon-App-40x40@1x.png": 40,
    "Icon-App-40x40@2x.png": 80,
    "Icon-App-40x40@3x.png": 120,
    "Icon-App-60x60@2x.png": 120,
    "Icon-App-60x60@3x.png": 180,
    "Icon-App-76x76@1x.png": 76,
    "Icon-App-76x76@2x.png": 152,
    "Icon-App-83.5x83.5@2x.png": 167,
    "Icon-App-1024x1024@1x.png": 1024,
}
for filename, px in ios_sizes.items():
    save(scaled("full", px), ios / filename, rgb=True)

# --- macOS ---------------------------------------------------------------
for px in (16, 32, 64, 128, 256, 512, 1024):
    save(scaled("tile", px), macos / f"app_icon_{px}.png")

# --- Windows -------------------------------------------------------------
win.mkdir(parents=True, exist_ok=True)
scaled("full", 256).save(
    win / "app_icon.ico",
    format="ICO",
    sizes=[(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)],
)

# --- Web -----------------------------------------------------------------
save(scaled("tile", 256), web / "favicon.png")
save(scaled("full", 192), web / "icons/Icon-192.png", rgb=True)
save(scaled("full", 512), web / "icons/Icon-512.png", rgb=True)
save(scaled("full-safe", 192), web / "icons/Icon-maskable-192.png")
save(scaled("full-safe", 512), web / "icons/Icon-maskable-512.png")

# Normaliza los PNG/ICO de salida para que dos corridas sean idénticas.
for path in [*android.glob("mipmap-*/ic_launcher*.png"), *ios.glob("*.png"),
             *macos.glob("*.png"), *web.glob("*.png"), *web.glob("icons/*.png")]:
    with Image.open(path) as img:
        img.load()
        normalized = img.copy()
    normalized.save(path, format="PNG", optimize=True)
PY

# Fuentes estáticas derivadas de brand/ (determinísticas, se reescriben siempre).
cp "$BRAND_DIR/icon.svg" "$WEB_DIR/favicon.svg"

mkdir -p "$ANDROID_RES/mipmap-anydpi-v26"
cat >"$ANDROID_RES/mipmap-anydpi-v26/ic_launcher.xml" <<'XML'
<?xml version="1.0" encoding="utf-8"?>
<!-- Generado por scripts/generate-icons.sh — no editar a mano. -->
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background" />
    <foreground android:drawable="@mipmap/ic_launcher_foreground" />
    <monochrome android:drawable="@mipmap/ic_launcher_monochrome" />
</adaptive-icon>
XML

cat >"$ANDROID_RES/values/ic_launcher_background.xml" <<XML
<?xml version="1.0" encoding="utf-8"?>
<!-- Generado por scripts/generate-icons.sh — no editar a mano. -->
<resources>
    <color name="ic_launcher_background">$BRAND_BG</color>
</resources>
XML

echo "✅ Android → android/app/src/main/res/{mipmap-*,mipmap-anydpi-v26,values}/"
echo "✅ iOS     → ios/Runner/Assets.xcassets/AppIcon.appiconset/"
echo "✅ macOS   → macos/Runner/Assets.xcassets/AppIcon.appiconset/"
echo "✅ Windows → windows/runner/resources/app_icon.ico"
echo "✅ Web     → web/{favicon.svg,favicon.png,icons/}"
