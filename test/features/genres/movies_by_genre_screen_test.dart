import 'package:cinemapedia/features/genres/screens/movies_by_genre_screen.dart';
import 'package:cinemapedia/providers/repositories/movie_repository_provider.dart';
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
      child: const MaterialApp(
        home: MoviesByGenreScreen(genreId: 28, genreName: 'Acción'),
      ),
    );
  }

  setUp(() {
    fakeRepository = FakeMovieRepository();
  });

  testWidgets('cambiar el orden recarga la lista con el nuevo filtro',
      (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pump();
    await tester.pump();

    expect(fakeRepository.calls, contains('discover:28:populares:null:1'));

    await tester.tap(find.text('Más recientes'));
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(fakeRepository.calls, contains('discover:28:recientes:null:1'));
  });

  testWidgets('el filtro de año se suma a la consulta', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pump();
    await tester.pump();

    // Abre el dropdown de años y elige uno.
    await tester.tap(find.text('Cualquier año'));
    await tester.pump();
    await tester.pump();
    final nextYear = '${DateTime.now().year - 1}';
    await tester.tap(find.text(nextYear).last);
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(fakeRepository.calls, contains('discover:28:populares:$nextYear:1'));
  });
}
