// Genera las capturas de la app para el README.
//
// Normalmente se usa el script (que además convierte los PNG a WebP):
//
//   ./scripts/capture-screenshots.sh
//
// La app se ejecuta en una ventana real de escritorio, se navega con toques
// y los PNG se toman del árbol de render en tamaño de teléfono
// (420×864 lógicos @2x) y tema oscuro, sin importar la ventana ni el tema
// del sistema. Necesita conexión a Internet para cargar el catálogo de TMDB.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/features/home/providers/movies_provider.dart';
import 'package:cinemapedia/features/home/widgets/movie_card.dart';
import 'package:cinemapedia/features/home/widgets/movie_slide.dart';
import 'package:cinemapedia/features/movie_details/widgets/movie_resume.dart';
import 'package:cinemapedia/main.dart';
import 'package:cinemapedia/providers/repositories/local_storage_repository_provider.dart';
import 'package:cinemapedia/shared/widgets/movies_grid.dart';
import 'package:cinemapedia/shared/widgets/tmdb_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Dónde guardar los PNG (lo define scripts/capture-screenshots.sh).
const _outDir = String.fromEnvironment(
  'SCREENSHOT_DIR',
  defaultValue: 'docs/screenshots',
);

/// Resolución de exportación: el doble del tamaño lógico.
const _pixelRatio = 2.0;

/// Tamaño lógico de un teléfono. Por debajo de 600 de ancho la app muestra la
/// barra de navegación inferior (más arriba cambia al NavigationRail).
const _phoneSize = Size(420, 864);

final _captureKey = GlobalKey();

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capturas para el README', (tester) async {
    // Móvil + tema oscuro, independiente de la máquina donde se ejecute.
    tester.view.physicalSize = _phoneSize * _pixelRatio;
    tester.view.devicePixelRatio = _pixelRatio;
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    await dotenv.load(fileName: '.env');
    await initializeDateFormatting('es', null);
    Directory(_outDir).createSync(recursive: true);

    await tester.pumpWidget(
      ProviderScope(
        child: RepaintBoundary(key: _captureKey, child: const MainApp()),
      ),
    );

    // 1) Inicio: destacadas + cartelera, valoradas y próximamente.
    await _waitFor(tester, find.text('En cartelera'));
    await _capture(tester, 'home');

    // 2) Detalle: los datos de la película destacada del inicio.
    await _openMovieDetails(tester);
    await _capture(tester, 'movie-details');

    await tester.tap(find.byType(BackButton).hitTestable().first);
    await tester.pumpAndSettle();

    // 3) Populares: grilla de pósters.
    await tester.tap(find.text('Populares').hitTestable().first);
    await _waitFor(tester, find.byType(MoviesGrid).hitTestable());
    await _capture(tester, 'popular');

    // 4) Favoritos: agrega películas a la lista local (Isar) y las muestra.
    await _addSomeFavorites(tester);
    await tester.tap(find.text('Favoritos').hitTestable().first);
    await _waitFor(tester, find.byType(MoviesGrid).hitTestable());
    await _capture(tester, 'favorites');

    // 5) Buscador (la búsqueda se abre de forma asíncrona, se espera al campo).
    await tester.tap(find.byTooltip('Buscar películas').hitTestable().first);
    await _waitFor(tester, find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Dune');
    await _waitFor(tester, find.byType(TmdbImage).hitTestable());
    await _capture(tester, 'search');

    // 6) Explorar: géneros del catálogo.
    await tester.tap(find.byTooltip('Cerrar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Explorar').hitTestable().first);
    await _waitFor(tester, find.text('Acción'));
    await _capture(tester, 'genres');
  });
}

/// Abre los detalles de una película tocando la destacada del inicio.
Future<void> _openMovieDetails(WidgetTester tester) async {
  final slide = find.byType(MovieSlide).hitTestable();
  final card = find.byType(MovieCard).hitTestable();
  await tester.tap(slide.evaluate().isNotEmpty ? slide.first : card.first);
  await _waitFor(tester, find.byType(MovieResume));
}

/// Guarda en favoritos las primeras películas de "Populares" (almacén Isar).
/// Es idempotente: Isar persiste entre corridas y el toggle quitaría las
/// películas si ya fueran favoritas.
Future<void> _addSomeFavorites(WidgetTester tester) async {
  final container =
      ProviderScope.containerOf(tester.element(find.byKey(_captureKey)));
  final repository = container.read(localStorageRepositoryProvider);
  final List<Movie> movies = container.read(popularMoviesProvider).movies;

  for (final movie in movies.take(8)) {
    if (!await repository.isFavoriteMovie(movie.id)) {
      await repository.toggleFavoriteMovie(movie);
    }
  }
}

/// Espera (en tiempo real) a que [finder] encuentre algo en pantalla.
Future<void> _waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final limit = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(limit)) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 200));
  }
  fail('No apareció $finder después de $timeout');
}

/// Captura el árbol de render en `$_outDir/<nombre>.png`.
Future<void> _capture(WidgetTester tester, String name) async {
  // Espera las imágenes de red y deja la pantalla en reposo (p. ej. el
  // autoplay del carrusel) para capturarla quieta y sin placeholders.
  await _waitForImages(tester);
  await tester.pumpAndSettle();

  final boundary =
      tester.renderObject<RenderRepaintBoundary>(find.byKey(_captureKey));
  final ui.Image image = await boundary.toImage(pixelRatio: _pixelRatio);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

  final file = File('$_outDir/$name.png');
  await file.writeAsBytes(bytes!.buffer.asUint8List());
  debugPrint('Captura guardada: ${file.path} (${image.width}×${image.height})');
  image.dispose();
}

/// Espera a que las imágenes visibles terminen de cargar.
///
/// Mientras una imagen de red carga, `TmdbImage` muestra su placeholder
/// local (el GIF de la botella). Cuando en el árbol no queda ninguno, todo
/// lo que se va a capturar ya está dibujado.
Future<void> _waitForImages(WidgetTester tester) async {
  final limit = DateTime.now().add(const Duration(seconds: 45));
  var cleanPasses = 0;

  while (DateTime.now().isBefore(limit) && cleanPasses < 2) {
    final isLoading = tester
        .widgetList<Image>(find.byType(Image))
        .any((image) => image.image is AssetImage);
    cleanPasses = isLoading ? 0 : cleanPasses + 1;
    await tester.pump(const Duration(milliseconds: 300));
  }
}
