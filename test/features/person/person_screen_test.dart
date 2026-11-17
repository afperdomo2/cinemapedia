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

  testWidgets('renderiza datos, biografía y filmografía', (tester) async {
    await tester.pumpWidget(buildPerson());
    await tester.pump();
    await tester.pump();

    // Datos básicos (el nombre aparece en el appbar y en el encabezado)
    expect(find.text('Persona'), findsWidgets);
    expect(find.text('Acting'), findsOneWidget);
    expect(find.text('Buenos Aires, Argentina'), findsOneWidget);
    expect(find.textContaining('1980'), findsOneWidget);

    // Biografía y filmografía
    expect(find.text('Biografía'), findsOneWidget);
    expect(find.text('Una biografía de prueba.'), findsOneWidget);
    expect(find.text('Filmografía'), findsOneWidget);
    expect(find.byType(MoviePosterLink), findsNWidgets(2));
  });

  testWidgets('si falla la carga muestra el error con reintento',
      (tester) async {
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
