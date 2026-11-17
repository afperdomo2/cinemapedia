import 'package:cinemapedia/features/home/screens/home_screen.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:cinemapedia/shared/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeMovieRepository fakeRepository;

  setUpAll(() => initializeDateFormatting('es', null));

  Widget buildHome() {
    return ProviderScope(
      overrides: [movieRepositoryProvider.overrideWithValue(fakeRepository)],
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  setUp(() {
    fakeRepository = FakeMovieRepository();
  });

  testWidgets('mientras carga muestra el skeleton del inicio', (tester) async {
    await tester.pumpWidget(buildHome());

    expect(find.byType(HomeSkeleton), findsOneWidget);
  });

  testWidgets('si todo falla muestra el error con botón de reintento',
      (tester) async {
    fakeRepository.pageError = Exception('sin red');

    await tester.pumpWidget(buildHome());
    await tester.pump();

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.byType(HomeSkeleton), findsNothing);
  });

  testWidgets('el reintento vuelve a pedir los datos y muestra las secciones',
      (tester) async {
    fakeRepository.pageError = Exception('sin red');

    await tester.pumpWidget(buildHome());
    await tester.pump();

    // Se recupera la conexión y se reintenta.
    fakeRepository.pageError = null;
    await tester.tap(find.text('Reintentar'));
    await tester.pump();

    expect(find.text('En cartelera'), findsOneWidget);
    expect(find.byType(ErrorView), findsNothing);

    // El primer Scrollable del árbol es el vertical del CustomScrollView.
    final verticalScroll = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(find.text('Próximamente'), 250,
        scrollable: verticalScroll);
    expect(find.text('Próximamente'), findsOneWidget);
  });

  testWidgets('muestra las secciones cuando las listas responden',
      (tester) async {
    await tester.pumpWidget(buildHome());
    await tester.pump();

    expect(find.text('En cartelera'), findsOneWidget);
    expect(find.text('Película página 1'), findsWidgets);

    // Las secciones inferiores se construyen al entrar en el viewport.
    // El primer Scrollable del árbol es el vertical del CustomScrollView.
    final verticalScroll = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(find.text('Mejor valoradas'), 250,
        scrollable: verticalScroll);
    await tester.scrollUntilVisible(find.text('Próximamente'), 250,
        scrollable: verticalScroll);
    expect(find.byType(ErrorView), findsNothing);
  });
}
