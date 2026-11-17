import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/data/repositories/local_storage_repository_impl.dart';
import 'package:cinemapedia/providers/repositories/local_storage_repository_provider.dart';
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
          movieRepositoryProvider.overrideWithValue(FakeMovieRepository()),
          localStorageRepositoryProvider.overrideWithValue(
            LocalStorageRepositoryImpl(FakeLocalStorageDataSource()),
          ),
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

  testWidgets('un id de persona inválido muestra la pantalla de error',
      (tester) async {
    await pumpRouter(tester);

    appRouter.go('/person/abc');
    await tester.pumpAndSettle();

    expect(find.text('No encontramos lo que buscabas'), findsOneWidget);
  });

  testWidgets('un deep link cinemapedia://movie/1 abre los detalles',
      (tester) async {
    await pumpRouter(tester);

    // Con esquema propio, la ruta viaja como host y el router la normaliza.
    appRouter.go('cinemapedia://movie/1');
    await tester.pump(); // inicia la transición
    await tester
        .pump(const Duration(milliseconds: 400)); // termina la animación
    await tester.pump(); // retira la página anterior del árbol
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(find.text('Película 1'), findsOneWidget);
    expect(find.text('No encontramos lo que buscabas'), findsNothing);
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
