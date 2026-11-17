import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regresión: el loop infinito de `card_swiper` lanzaba un FlutterError de
/// precisión de coma flotante al redimensionar la ventana en desktop:
///
/// RenderSliverFixedExtentBoxAdaptor.computeMaxScrollOffset() returned a value
/// that is not an even multiple of its itemExtent.
///
/// Causa: lista virtual de 2 000 000 000 páginas × itemExtent fraccionario.
/// Ver packages/card_swiper/PATCHES.md
void main() {
  testWidgets('Swiper en loop no lanza error al redimensionar la ventana',
      (WidgetTester tester) async {
    Widget buildSwiper() => MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                height: 210,
                child: Swiper(
                  viewportFraction: 0.8,
                  scale: 0.9,
                  autoplay: false,
                  itemCount: 20,
                  itemBuilder: (context, index) => ColoredBox(
                    key: ValueKey(index),
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        );

    // Tamaño inicial equivalente a la ventana de escritorio.
    await tester.binding.setSurfaceSize(const Size(1280, 720));
    await tester.pumpWidget(buildSwiper());
    await tester.pumpAndSettle();

    // Redimensionados con anchos no enteros tras aplicar viewportFraction 0.8
    // (p. ej. 1279 × 0.8 = 1023.2, el caso exacto del error original).
    for (final width in <double>[1279, 999.5, 1023.2, 2560, 777.7, 1333.3]) {
      await tester.binding.setSurfaceSize(Size(width, 720));
      await tester.pumpAndSettle();
    }

    expect(tester.takeException(), isNull);
  });
}
