import 'package:cinemapedia/features/random/screens/random_movie_screen.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeMovieRepository fakeRepository;

  Widget buildScreen() {
    return ProviderScope(
      overrides: [
        movieRepositoryProvider.overrideWithValue(fakeRepository),
      ],
      child: const MaterialApp(home: RandomMovieScreen()),
    );
  }

  setUp(() {
    fakeRepository = FakeMovieRepository();
  });

  testWidgets('muestra la sugerencia con datos y acciones', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pump();
    await tester.pump();

    expect(find.text('Sugerencia 1'), findsOneWidget);
    expect(find.text('7.5'), findsOneWidget); // nota
    expect(find.text('2026 · Acción'), findsOneWidget); // año y género
    expect(find.text('Otra sugerencia'), findsOneWidget);
    expect(find.text('Ver detalles'), findsOneWidget);
  });

  testWidgets('pedir otra sugerencia cambia la película', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Otra sugerencia'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Sugerencia 2'), findsOneWidget);
    expect(find.text('Sugerencia 1'), findsNothing);
  });

  testWidgets('el filtro de nota mínima llega a la consulta', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('8+'));
    await tester.pump();
    await tester.pump();

    expect(fakeRepository.calls, contains('random:null:8.0'));
  });

  testWidgets('si falla muestra el error con reintento', (tester) async {
    fakeRepository.randomError = Exception('Sin conexión');

    await tester.pumpWidget(buildScreen());
    await tester.pump();
    await tester.pump();

    expect(find.byType(ErrorView), findsOneWidget);

    fakeRepository.randomError = null;
    await tester.tap(find.text('Reintentar'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Sugerencia 1'), findsOneWidget);
  });
}
