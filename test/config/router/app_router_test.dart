import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../helpers/fakes.dart';

void main() {
  setUpAll(() => initializeDateFormatting('es', null));
  Future<void> pumpRouter(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movieRepositoryProvider.overrideWithValue(FakeMovieRepository())
        ],
        child: MaterialApp.router(routerConfig: appRouter),
      ),
    );
    await tester.pump();
  }

  testWidgets('un id de película inválido muestra la pantalla de error',
      (tester) async {
    await pumpRouter(tester);

    appRouter.go('/movie/abc');
    await tester.pumpAndSettle();

    expect(find.text('No encontramos lo que buscabas'), findsOneWidget);
    expect(find.text('Ir al inicio'), findsOneWidget);
  });

  testWidgets('una ruta desconocida muestra la pantalla de error',
      (tester) async {
    await pumpRouter(tester);

    appRouter.go('/ruta-que-no-existe');
    await tester.pumpAndSettle();

    expect(find.text('No encontramos lo que buscabas'), findsOneWidget);
  });

  testWidgets('de la pantalla de error se puede volver al inicio',
      (tester) async {
    await pumpRouter(tester);

    appRouter.go('/movie/abc');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ir al inicio'));
    await tester.pumpAndSettle();

    expect(find.text('No encontramos lo que buscabas'), findsNothing);
  });
}
