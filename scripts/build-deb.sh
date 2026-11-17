#!/usr/bin/env bash
set -Eeuo pipefail

trap 'echo "❌ Error en ${BASH_SOURCE[0]} línea $LINENO" >&2' ERR

# Compila la app para Linux y empaqueta el bundle de Flutter como un `.deb`
# instalable con apt (Flutter no genera `.deb` por su cuenta).
#
#   ./scripts/build-deb.sh              # sube el número de build y empaqueta
#   ./scripts/build-deb.sh --no-bump    # empaqueta con la versión actual
#
# Requiere: `flutter` en PATH con soporte de escritorio, `dpkg-deb` (paquete
# `dpkg`) y las dependencias de compilación de media_kit (Ubuntu/Debian:
# `sudo apt install libmpv-dev`).
#
# Salida: dist/cinemapedia_<versión>_<arquitectura>.deb
#
# Instalación / desinstalación:
#   sudo apt install ./dist/cinemapedia_*_*.deb
#   sudo apt remove cinemapedia
#
# El paquete instala:
#   /opt/cinemapedia/                            (binario + librerías + assets)
#   /usr/bin/cinemapedia                         (symlink al binario)
#   /usr/share/applications/com.example.cinemapedia.desktop
#   /usr/share/icons/hicolor/512x512/apps/cinemapedia.png
#
# Las dependencias (Depends del control) se calculan con `readelf` + `dpkg -S`
# sobre las librerías que enlaza el bundle armado, así que reflejan la distro
# donde se compila.

usage() {
  cat <<'EOF'
Uso: scripts/build-deb.sh [--no-bump]

  --no-bump    No incrementa la versión; empaqueta con la actual
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
  echo "❌ Falta el archivo .env (se empaqueta dentro del binario). Ver README §2." >&2
  exit 1
fi

command -v dpkg-deb >/dev/null || {
  echo "❌ No se encontró dpkg-deb (instalar el paquete 'dpkg')" >&2
  exit 1
}

deb_arch="$(dpkg --print-architecture)"
case "$deb_arch" in
  amd64) flutter_arch=x64 ;;
  arm64) flutter_arch=arm64 ;;
  *)
    echo "❌ Arquitectura no soportada por este script: $deb_arch" >&2
    exit 1
    ;;
esac

cd "$REPO_ROOT"

if ((BUMP)); then
  ./scripts/bump-build.sh
fi

version="$(sed -nE 's/^version: *//p' pubspec.yaml)"
bundle="build/linux/$flutter_arch/release/bundle"

flutter build linux --release

if [[ ! -x "$bundle/cinemapedia" ]]; then
  echo "❌ No se encontró el bundle compilado en $bundle" >&2
  exit 1
fi

stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT

# --- Estructura del paquete ------------------------------------------------
mkdir -p "$stage/opt" "$stage/usr/bin" "$stage/usr/share/applications" \
  "$stage/usr/share/icons/hicolor/512x512/apps" "$stage/DEBIAN"

cp -a "$bundle" "$stage/opt/cinemapedia"
ln -s /opt/cinemapedia/cinemapedia "$stage/usr/bin/cinemapedia"

cp web/icons/Icon-512.png \
  "$stage/usr/share/icons/hicolor/512x512/apps/cinemapedia.png"

cat > "$stage/usr/share/applications/com.example.cinemapedia.desktop" <<'EOF'
[Desktop Entry]
Name=Cinemapedia
Comment=Catálogo de películas de TMDB
Exec=/opt/cinemapedia/cinemapedia
Icon=cinemapedia
Terminal=false
Type=Application
Categories=AudioVideo;Video;
StartupWMClass=cinemapedia
EOF

# --- Dependencias de runtime (NEEDED alcanzables → dpkg -S) ----------------
# Solo se listan las dependencias DIRECTAS de los ELF que instala el paquete:
# se recorren las entradas NEEDED alcanzables desde el binario; las librerías
# que viajan en el bundle se incluyen en el paquete y las del sistema pasan a
# Depends (las transitivas las resuelve apt). Las variantes t64 (transición
# de tipos de Ubuntu 24.04+) se listan como alternativas para que el .deb
# instale también en distros sin esa transición.

declare -A seen_soname=()
system_sonames=()
bundle_lib="$stage/opt/cinemapedia/lib"

collect_needed() {
  local elf="$1" dep needed
  needed="$(LC_ALL=C readelf -d "$elf" 2>/dev/null |
    sed -n 's/.*Shared library: \[\(.*\)\]/\1/p')"
  for dep in $needed; do
    [[ -n "${seen_soname[$dep]:-}" ]] && continue
    seen_soname[$dep]=1
    if [[ -f "$bundle_lib/$dep" ]]; then
      # Librería que viaja dentro del paquete: revisar sus propias NEEDED.
      collect_needed "$bundle_lib/$dep"
    else
      # Librería del sistema: tiene que figurar en Depends.
      system_sonames+=("$dep")
    fi
  done
}

collect_needed "$stage/opt/cinemapedia/cinemapedia"

depends="$(
  for dep in "${system_sonames[@]}"; do
    path="$(LC_ALL=C ldconfig -p | awk -v s="$dep" '$1 == s {print $NF; exit}')"
    pkg=""
    if [[ -n "$path" ]]; then
      pkg="$(dpkg -S "$path" 2>/dev/null | head -n1 | cut -d: -f1 || true)"
    fi
    if [[ -z "$pkg" ]]; then
      pkg="$(dpkg -S "*/$dep" 2>/dev/null | head -n1 | cut -d: -f1 || true)"
    fi
    [[ -z "$pkg" ]] && continue
    if [[ "$pkg" == *t64 ]]; then
      echo "$pkg | ${pkg%t64}"
    else
      echo "$pkg | ${pkg}t64"
    fi
  done | sort -u | paste -sd, -
)"
depends_line=""
[[ -n "$depends" ]] && depends_line="Depends: $depends"

maintainer="$(git config user.name 2>/dev/null || true)"
maintainer_email="$(git config user.email 2>/dev/null || true)"
if [[ -n "$maintainer" && -n "$maintainer_email" ]]; then
  maintainer="$maintainer <$maintainer_email>"
else
  maintainer="Cinemapedia developers <cinemapedia@localhost>"
fi

installed_size="$(
  du -sk "$stage/opt" "$stage/usr" | awk '{s += $1} END {print s}'
)"

cat > "$stage/DEBIAN/control" <<EOF
Package: cinemapedia
Version: $version
Section: video
Priority: optional
Architecture: $deb_arch
Maintainer: $maintainer
Installed-Size: $installed_size
$depends_line
Description: Catálogo de películas de TMDB
 Explorá películas, mirá detalles, trailers y favoritos usando la API de
 The Movie Database (TMDB). Aplicación Flutter multiplataforma.
EOF

# --- Construcción ----------------------------------------------------------
mkdir -p dist
out="dist/cinemapedia_${version}_${deb_arch}.deb"
rm -f "$out"
dpkg-deb --build --root-owner-group "$stage" "$out" >/dev/null

echo "✅ Paquete listo: $out"
dpkg-deb --info "$out" | sed 's/^/   /'
echo "   Instalar:    sudo apt install ./$out"
echo "   Desinstalar: sudo apt remove cinemapedia"
