import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemapedia/config/helpers/external_url.dart';
import 'package:cinemapedia/config/helpers/youtube_links.dart';
import 'package:cinemapedia/config/platform_support.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/shared/services/youtube_stream_resolver.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' as mk;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

typedef StreamResolver = Future<Uri> Function(String youtubeKey);

/// Reproductor de UN video de la película.
///
/// Se abre desde la sección "Videos" de los detalles; para ver otro video se
/// vuelve atrás y se elige desde allí. En Android e iOS se reproduce con el
/// player embebido de YouTube; en Linux/Windows/macOS se reproduce dentro de
/// la app con `media_kit`, y si no se puede obtener el stream se abre en el
/// navegador del sistema como respaldo.
class VideoScreen extends StatefulWidget {
  static const name = 'video_screen';

  final Video video;

  /// Resolución del stream reproducible; inyectable para tests.
  final StreamResolver? resolveStream;

  const VideoScreen({
    super.key,
    required this.video,
    this.resolveStream,
  });

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    // El controller solo tiene sentido donde existe el player embebido.
    if (isMobilePlatform) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.video.youtubeKey,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _openInBrowser() async {
    final error =
        await ExternalUrl.open(YoutubeLinks.watchUrl(widget.video.youtubeKey));
    if (error == null || !mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content:
              Text('No se pudo abrir YouTube en el navegador.\nCausa: $error'),
          duration: const Duration(seconds: 6),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    final surface = controller != null
        // Android / iOS: player embebido de YouTube con pantalla completa.
        ? YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
            ),
            builder: (context, player) => player,
          )
        // Escritorio: player de la app (con respaldo en el navegador).
        : _DesktopVideoPlayer(
            video: widget.video,
            resolveStream:
                widget.resolveStream ?? YoutubeStreamResolver.instance.resolve,
            onOpenInBrowser: _openInBrowser,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.name,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: 'Ver en YouTube',
            onPressed: _openInBrowser,
            icon: const Icon(Icons.open_in_new),
          ),
        ],
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Superficie 16:9 que siempre entra en el viewport.
            final width =
                min(constraints.maxWidth, constraints.maxHeight * 16 / 9);
            return SizedBox(
              width: width,
              height: width * 9 / 16,
              child: surface,
            );
          },
        ),
      ),
    );
  }
}

/// Reproductor embebido para plataformas sin WebView: reproduce el video en la
/// app con `media_kit`; si no se puede, ofrece abrirlo en el navegador.
class _DesktopVideoPlayer extends StatefulWidget {
  const _DesktopVideoPlayer({
    required this.video,
    required this.resolveStream,
    required this.onOpenInBrowser,
  });

  final Video video;
  final StreamResolver resolveStream;
  final Future<void> Function() onOpenInBrowser;

  @override
  State<_DesktopVideoPlayer> createState() => _DesktopVideoPlayerState();
}

class _DesktopVideoPlayerState extends State<_DesktopVideoPlayer> {
  Player? _player;
  mk.VideoController? _controller;
  Object? _error;
  bool _resolving = true;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    setState(() {
      _resolving = true;
      _error = null;
    });

    try {
      final url = await widget.resolveStream(widget.video.youtubeKey);
      final player = Player();
      final controller = mk.VideoController(player);
      await player.open(Media(url.toString()), play: true);

      if (!mounted) {
        await player.dispose();
        return;
      }

      setState(() {
        _player = player;
        _controller = controller;
        _resolving = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _resolving = false;
      });
    }
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller != null) {
      return mk.Video(
        controller: controller,
        fill: Colors.black,
        controls: mk.MaterialDesktopVideoControls,
      );
    }

    return Material(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          /// Miniatura del video (fondo de las vistas de carga y error)
          CachedNetworkImage(
            imageUrl: YoutubeLinks.thumbnailUrl(widget.video.youtubeKey,
                size: 'maxresdefault'),
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
            errorWidget: (context, url, error) =>
                const ColoredBox(color: Colors.black),
          ),

          if (_resolving)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Preparando el video…',
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_circle_fill,
                      size: 72, color: Colors.white),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: widget.onOpenInBrowser,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Ver en YouTube'),
                  ),
                  TextButton(
                    onPressed: _start,
                    child: const Text('Reintentar'),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'No se pudo reproducir el video aquí.\n$_error',
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
