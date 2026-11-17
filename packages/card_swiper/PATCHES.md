# Parches locales sobre `card_swiper` 3.0.1

Copia local de [`card_swiper`](https://pub.dev/packages/card_swiper) 3.0.1 usada vía
`dependency_overrides` en `pubspec.yaml`. Motivo y detalle del cambio:

## Problema

Al redimensionar la ventana en desktop (Linux/Windows/macOS) aparecía esta excepción
en modo debug:

```
FlutterError (RenderSliverFixedExtentBoxAdaptor.computeMaxScrollOffset() returned a
value that is not an even multiple of its itemExtent. The itemExtent was 1023.2, but
the scrollExtent was 2046400002093.979. ...)
```

## Causa raíz

- `card_swiper` simula el loop infinito creando un `PageView` virtual con
  `itemCount + kMaxValue` páginas (`kMaxValue = 2 000 000 000`) centrado en
  `kMiddleValue = 1 000 000 000` (`transformer_page_view.dart`, `getRealItemCount()`).
- Al redimensionar, `viewportFraction` (0.8 / 0.84 en la app) produce un `itemExtent`
  fraccionario (p. ej. 1279 × 0.8 = 1023.2 px).
- Con ~2×10⁹ elementos, la estimación del scroll total (~2×10¹² px) acumula error de
  coma flotante y el `assert` de precisión de Flutter
  (`rendering/sliver_fixed_extent_list.dart`, `debugAssertDoesMeetConstraints`) falla.
- Es un fallo **solo de debug** (el `assert` se elimina en release), pero interrumpe
  el desarrollo.

## Cambio aplicado

`lib/src/swiper.dart` y `lib/src/transformer_page_view/transformer_page_view.dart`:

| Constante | Original | Parchada |
|---|---|---|
| `kMaxValue` | 2 000 000 000 | 2 000 |
| `kMiddleValue` | 1 000 000 000 | 1 000 |

Valor elegido con un barrido empírico (`PageView` + `viewportFraction` 0.8 redimensionado
a 6 anchos distintos): con ≥ 4 000 páginas virtuales el `assert` sigue fallando; con
2 000 pasa en todos los anchos probados.

El loop sigue funcionando igual: con autoplay (5 s por slide) hacen falta ~83 minutos de
reproducción continua para llegar al final de la lista virtual, y el swipe manual nunca
lo alcanza. Si se agotara, el carrusel se detiene en la última slide (no hay crash).

## Actualizaciones

Si se actualiza `card_swiper`, hay que reaplicar este parche (o comprobar si upstream
lo corrige). Regresión cubierta por `test/swiper_resize_test.dart` en la raíz del proyecto.
