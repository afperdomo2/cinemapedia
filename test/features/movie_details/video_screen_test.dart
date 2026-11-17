import 'dart:async';

import 'package:cinemapedia/config/helpers/youtube_links.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/features/movie_details/screens/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  final video = Video(
    id: 'v1',
    name: 'Trailer oficial',
    youtubeKey: 'abc123',
    publishedAt: DateTime(2026),
  );

  /// Resolver que falla: deja la pantalla en el estado de respaldo.
  Future<Uri> failingResolver(String youtubeKey) =>
      Future.error(StateError('sin conexión con YouTube'));

  /// Resolver que nunca completa: deja la pantalla en el estado de carga.
  Future<Uri> pendingResolver(String youtubeKey) => Completer<Uri>().future;

  Widget buildScreen({StreamResolver? resolveStream}) {
    return MaterialApp(
      home: VideoScreen(
          video: video, resolveStream: resolveStream ?? failingResolver),
    );
  }

  group('YoutubeLinks', () {
    test('construye la página para ver el video', () {
      expect(YoutubeLinks.watchUrl('abc123').toString(),
          'https://www.youtube.com/watch?v=abc123');
    });

    test('construye la miniatura con el tamaño pedido', () {
      expect(YoutubeLinks.thumbnailUrl('abc123'),
          'https://img.youtube.com/vi/abc123/mqdefault.jpg');
      expect(YoutubeLinks.thumbnailUrl('abc123', size: 'maxresdefault'),
          'https://img.youtube.com/vi/abc123/maxresdefault.jpg');
    });
  });

  group('VideoScreen en escritorio', () {
    // Los tests corren en Linux: la variante de escritorio es la que se usa.

    testWidgets('mientras resuelve el stream muestra la carga', (tester) async {
      await tester.pumpWidget(buildScreen(resolveStream: pendingResolver));

      expect(find.text('Preparando el video…'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('si no se puede reproducir ofrece abrir en YouTube',
        (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();
      await tester.pump();

      expect(find.text('Ver en YouTube'), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);
      expect(find.textContaining('sin conexión con YouTube'), findsOneWidget);

      // El reproductor embebido de YouTube (WebView) NO se construye en escritorio.
      expect(find.byType(YoutubePlayer), findsNothing);
    });

    testWidgets('Reintentar vuelve a intentar reproducir', (tester) async {
      var attempts = 0;
      Future<Uri> countingResolver(String youtubeKey) {
        attempts++;
        return Future.error(StateError('fallo transitorio'));
      }

      await tester.pumpWidget(buildScreen(resolveStream: countingResolver));
      await tester.pump();
      await tester.pump();
      expect(attempts, 1);

      await tester.tap(find.text('Reintentar'));
      await tester.pump();
      await tester.pump();

      expect(attempts, 2);
    });

    testWidgets('no desborda en ventanas bajas', (tester) async {
      tester.view.physicalSize = const Size(1000, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildScreen());
      await tester.pump();
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Ver en YouTube'), findsOneWidget);
    });

    testWidgets('muestra el título del video y el acceso a YouTube',
        (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.widgetWithText(AppBar, 'Trailer oficial'), findsOneWidget);
      expect(find.byTooltip('Ver en YouTube'),
          findsOneWidget); // acción del appbar
    });
  });
}
