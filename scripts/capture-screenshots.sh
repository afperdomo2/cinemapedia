#!/usr/bin/env bash
# Genera las capturas de la app para el README en docs/screenshots/.
#
# La app se ejecuta en una ventana real y las capturas se toman del árbol de
# render en tamaño de teléfono (420x864 @2x) y tema oscuro. Requiere:
#   - flutter en el PATH con soporte de escritorio Linux,
#   - conexión a Internet (catálogo de TMDB),
#   - Python 3 con Pillow (igual que generate-icons.sh) para crear el WebP.
set -euo pipefail

cd "$(dirname "$0")/.."

OUT_DIR="docs/screenshots"

if ! python3 -c 'import PIL' 2>/dev/null; then
  echo "error: se necesita Python 3 con Pillow (sudo apt install python3-pil)" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"

flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/screenshots_test.dart \
  --device-id=linux \
  --dart-define=SCREENSHOT_DIR="$(cd "$OUT_DIR" && pwd)"

# Comprime a WebP para que el README no pese de más.
python3 - "$OUT_DIR" <<'PY'
import pathlib
import sys

from PIL import Image

out_dir = pathlib.Path(sys.argv[1])
for png in sorted(out_dir.glob('*.png')):
    webp = png.with_suffix('.webp')
    with Image.open(png) as image:
        image.save(webp, 'WEBP', quality=82, method=6)
    png.unlink()
    print(f'{png.name} -> {webp.name} ({webp.stat().st_size // 1024} KB)')
PY

echo "Listo: $OUT_DIR/"
