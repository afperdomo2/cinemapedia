#!/usr/bin/env bash
set -Eeuo pipefail

trap 'echo "❌ Error en ${BASH_SOURCE[0]} línea $LINENO" >&2' ERR

# Compila el APK de release de Android y deja el instalador en `dist/`.
#
#   ./scripts/build-apk.sh              # sube el número de build y compila
#   ./scripts/build-apk.sh --no-bump    # compila con la versión actual
#
# Requiere: `flutter` en PATH y el Android SDK configurado (`flutter doctor`).
# Salida: dist/cinemapedia-<versión>-android.apk
#
# Instalación en un dispositivo/emulador:
#   adb install dist/cinemapedia-*-android.apk
# o copiar el APK al teléfono y abrirlo (habilitando "orígenes desconocidos").
#
# Nota: la release está firmada con las llaves de debug (ver
# android/app/build.gradle). Alcanza para instalar manualmente; para Play
# Store hace falta un keystore propio.

usage() {
  cat <<'EOF'
Uso: scripts/build-apk.sh [--no-bump]

  --no-bump    No incrementa la versión; compila con la actual
EOF
}

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUMP=1

for arg in "$@"; do
  case "$arg" in
    --no-bump) BUMP=0 ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
done

if [[ ! -f "$REPO_ROOT/.env" ]]; then
  echo "❌ Falta el archivo .env (se empaqueta dentro del APK). Ver README §2." >&2
  exit 1
fi

cd "$REPO_ROOT"

if ((BUMP)); then
  ./scripts/bump-build.sh
fi

version="$(sed -nE 's/^version: *//p' pubspec.yaml)"

flutter build apk --release

mkdir -p dist
cp build/app/outputs/flutter-apk/app-release.apk \
  "dist/cinemapedia-$version-android.apk"

echo "✅ APK listo: dist/cinemapedia-$version-android.apk"
echo "   Instalar: adb install dist/cinemapedia-$version-android.apk"
