import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// Resuelve la URL reproducible de un video de YouTube.
///
/// YouTube no publica URLs directas oficialmente: se extraen del manifiesto
/// público del video (lo mismo que hacen los reproductores de código abierto
/// como NewPipe o yt-dlp). Es una solución no oficial: puede dejar de
/// funcionar si YouTube cambia su backend, por eso la pantalla de video
/// conserva el botón de abrir en el navegador como respaldo.
class YoutubeStreamResolver {
  YoutubeStreamResolver({YoutubeExplode? youtubeClient})
      : _youtube = youtubeClient ?? YoutubeExplode();

  /// Instancia compartida: conserva la caché de streams entre pantallas.
  static final YoutubeStreamResolver instance = YoutubeStreamResolver();

  final YoutubeExplode _youtube;
  final _cache = <String, Uri>{};

  /// Devuelve la URL con audio y video del video [youtubeKey].
  Future<Uri> resolve(String youtubeKey) async {
    final cached = _cache[youtubeKey];
    if (cached != null) return cached;

    final manifest =
        await _youtube.videos.streamsClient.getManifest(youtubeKey);

    // Streams "muxed" = audio y video juntos (los únicos reproducibles con un
    // solo elemento multimedia).
    final muxed = manifest.muxed;
    if (muxed.isEmpty) {
      throw StateError(
        'YouTube no ofrece un stream reproducible para este video '
        '(¿es una transmisión en vivo?)',
      );
    }

    final url = muxed.withHighestBitrate().url;
    _cache[youtubeKey] = url;
    return url;
  }
}
