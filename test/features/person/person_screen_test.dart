import 'package:cinemapedia/domain/exceptions/fetch_exception.dart';
import 'package:cinemapedia/features/person/screens/person_screen.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:cinemapedia/shared/widgets/movie_poster_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeMovieRepository fakeRepository;

  setUpAll(() => initializeDateFormatting('es', null));

  Widget buildPerson() {
    return ProviderScope(
      overrides: [
        movieRepositoryProvider.overrideWithValue(fakeRepository),
      ],
      child: const MaterialApp(home: PersonScreen(personId: 1)),
    );
  }

  setUp(() {
    fakeRepository = FakeMovieRepository();
  });

  /// Pantalla alta: header, biografía y filmografía entran sin scroll y todos
  /// los slivers perezosos quedan construidos (aserciones de conteo estables).
  void useTallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('renderiza datos, biografía, conocido por y filmografía',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(buildPerson());
    await tester.pump();
    await tester.pump();

    // Datos básicos (el nombre aparece en el appbar y en el encabezado)
    expect(find.text('Persona'), findsWidgets);
    expect(find.text('Acting'), findsOneWidget);
    expect(find.text('Buenos Aires, Argentina'), findsOneWidget);
    expect(find.textContaining('1980'), findsOneWidget);

    // Biografía
    expect(find.text('Biografía'), findsOneWidget);
    expect(find.text('Una biografía de prueba.'), findsOneWidget);

    // Conocido por (2 pósters del reparto, por popularidad) + reparto (2)
    expect(find.text('Conocido por'), findsOneWidget);
    expect(find.text('Filmografía'), findsOneWidget);
    expect(find.byType(MoviePosterLink), findsNWidgets(4));
  });

  testWidgets('los chips cambian la sección de la filmografía', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(buildPerson());
    await tester.pump();
    await tester.pump();

    // Dirección: solo la película dirigida (más los 2 de "conocido por").
    await tester.tap(find.text('Dirección'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Director'), findsOneWidget);
    // El personaje solo figura en "Conocido por" (la grilla muestra dirección).
    expect(find.text('Personaje 1'), findsOneWidget);
    expect(find.byType(MoviePosterLink), findsNWidgets(3));

    // Equipo: solo la de guion (más los 2 de "conocido por").
    await tester.tap(find.text('Equipo'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Guionista'), findsOneWidget);
    expect(find.text('Director'), findsNothing);
    expect(find.byType(MoviePosterLink), findsNWidgets(3));
  });

  testWidgets('si falla la carga muestra el error con reintento',
      (tester) async {
    useTallScreen(tester);
    fakeRepository.personError = const FetchException('Sin conexión');

    await tester.pumpWidget(buildPerson());
    await tester.pump();

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Sin conexión'), findsOneWidget);

    // Reintento con la conexión recuperada.
    fakeRepository.personError = null;
    await tester.tap(find.text('Reintentar'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Una biografía de prueba.'), findsOneWidget);
    expect(find.byType(ErrorView), findsNothing);
  });
}
