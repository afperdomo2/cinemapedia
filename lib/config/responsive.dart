import 'package:flutter/material.dart';

/// Breakpoints basados en las window size classes de Material 3:
/// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
class Breakpoints {
  /// Teléfonos y ventanas estrechas (<600).
  static const double compact = 600;

  /// Tablets en retrato y ventanas medianas (600–840).
  static const double medium = 840;

  /// Tablets en landscape / escritorio (840–1200).
  static const double expanded = 1200;

  /// Pantallas grandes (≥1200).
  static const double large = 1200;
}

/// Cálculos responsive compartidos por los widgets de la app.
class Responsive {
  Responsive._();

  static double widthOf(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  /// Columnas del masonry de pósters (Favoritos / Populares) según el ancho.
  static int posterColumns(double width) {
    if (width < Breakpoints.compact) return 3;
    if (width < Breakpoints.medium) return 4;
    if (width < Breakpoints.expanded) return 5;
    if (width < 1600) return 6;
    return 7;
  }

  /// Ancho de las tarjetas de póster (MovieCard / MovieActors) según el ancho.
  /// Mantiene la proporción original de 135 de ancho.
  static double posterCardWidth(double width) {
    if (width < Breakpoints.medium) return 135;
    if (width < Breakpoints.expanded) return 165;
    return 195;
  }

  /// Altura del slideshow de destacadas del home.
  static double slideshowHeight(double width) {
    if (width < Breakpoints.compact) return 210;
    if (width < Breakpoints.expanded) return 280;
    return 340;
  }
}
