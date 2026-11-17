#!/usr/bin/env bash
set -Eeuo pipefail

trap 'echo "❌ Error en ${BASH_SOURCE[0]} línea $LINENO" >&2' ERR

# Incrementa la versión de `pubspec.yaml` (formato Flutter `x.y.z+número de
# build`, ej: `0.2.0+1`).
#
#   ./scripts/bump-build.sh            # 0.2.0+1 -> 0.2.0+2 (solo build +1)
#   ./scripts/bump-build.sh --patch    # 0.2.0+2 -> 0.2.1+1
#   ./scripts/bump-build.sh --minor    # 0.2.1+1 -> 0.3.0+1
#   ./scripts/bump-build.sh --major    # 0.3.0+1 -> 1.0.0+1
#
# Por defecto solo sube el número de build (lo estándar en Flutter/Android:
# `versionName` = x.y.z, `versionCode` = número de build). Los flags --patch /
# --minor / --major son para marcar cambios visibles al usuario y reinician el
# número de build en 1.
#
# Los scripts de release (build-apk.sh / build-deb.sh) lo invocan
# automáticamente antes de compilar; usan `--no-bump` para compilar sin tocar
# la versión. El cambio queda en el working tree: commitealo junto al release.

usage() {
  cat <<'EOF'
Uso: scripts/bump-build.sh [--patch | --minor | --major]

  (sin flags)  Sube el número de build:  x.y.z+N -> x.y.z+N+1
  --patch      Sube el parche:           x.y.z+N -> x.y.(z+1)+1
  --minor      Sube el minor:            x.y.z+N -> x.(y+1).0+1
  --major      Sube el major:            x.y.z+N -> (x+1).0.0+1
EOF
}

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBSPEC="$REPO_ROOT/pubspec.yaml"

case "${1:-}" in
  '' | --patch | --minor | --major) ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac

current="$(sed -nE 's/^version: *//p' "$PUBSPEC")"

if [[ ! "$current" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)(\+([0-9]+))?$ ]]; then
  echo "❌ Versión inválida en pubspec.yaml: '$current' (se espera x.y.z+N)" >&2
  exit 1
fi

major="${BASH_REMATCH[1]}"
minor="${BASH_REMATCH[2]}"
patch="${BASH_REMATCH[3]}"
build="${BASH_REMATCH[5]:-0}"

case "${1:-}" in
  --major)
    major=$((major + 1))
    minor=0
    patch=0
    build=1
    ;;
  --minor)
    minor=$((minor + 1))
    patch=0
    build=1
    ;;
  --patch)
    patch=$((patch + 1))
    build=1
    ;;
  *)
    build=$((build + 1))
    ;;
esac

new="$major.$minor.$patch+$build"
sed -i -E "s/^version: .*/version: $new/" "$PUBSPEC"
echo "🔢 Versión: $current -> $new"
