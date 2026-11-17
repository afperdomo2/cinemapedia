import 'package:cinemapedia/data/repositories/local_storage_repository_impl.dart';
import 'package:cinemapedia/domain/exceptions/fetch_exception.dart';
import 'package:cinemapedia/features/movie_details/screens/movie_details_screen.dart';
import 'package:cinemapedia/providers/repositories/local_storage_repository_provider.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeMovieRepository fakeRepository;
  late FakeLocalStorageDataSource fakeLocalStorage;

  setUpAll(() => initializeDateFormatting('es', null));

  Widget buildDetails() {
    return ProviderScope(
      overrides: [
        movieRepositoryProvider.overrideWithValue(fakeRepository),
        localStorageRepositoryProvider.overrideWithValue(
          LocalStorageRepositoryImpl(fakeLocalStorage),
        ),
      ],
      child: const MaterialApp(home: MovieDetailsScreen(movieId: 1)),
    );
  }

  setUp(() {
    fakeRepository = FakeMovieRepository();
    fakeLocalStorage = FakeLocalStorageDataSource();
  });

  testWidgets(
      'renderiza título, sinopsis, géneros, actores, videos y recomendaciones',
      (tester) async {
    await tester.pumpWidget(buildDetails());
    await tester.pump();

    // Título y sinopsis
    expect(find.text('Película 1'), findsOneWidget);
    expect(find.text('Una película de prueba.'), findsOneWidget);

    // Géneros
    expect(find.text('28'), findsOneWidget);

    // Actores
    expect(find.text('Actor'), findsOneWidget);
    expect(find.text('Personaje'), findsOneWidget);

    // Videos
    expect(find.text('Videos'), findsOneWidget);
    expect(find.text('Trailer'), findsOneWidget);

    // Recomendaciones
    expect(find.text('Recomendaciones'), findsOneWidget);
    expect(find.text('Similar 1'), findsOneWidget);
  });

  testWidgets('si falla la carga muestra el error con reintento',
      (tester) async {
    fakeRepository.detailsError = const FetchException('Sin conexión');

    await tester.pumpWidget(buildDetails());
    await tester.pump();

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Sin conexión'), findsOneWidget);

    // Reintento con la conexión recuperada.
    fakeRepository.detailsError = null;
    await tester.tap(find.text('Reintentar'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Película 1'), findsOneWidget);
    expect(find.byType(ErrorView), findsNothing);
  });

  testWidgets('el botón de favorito alterna sin errores', (tester) async {
    await tester.pumpWidget(buildDetails());
    await tester.pump();

    await tester.tap(find.byTooltip('Agregar a favoritos'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.takeException(), isNull);
  });
}
