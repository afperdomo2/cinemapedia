/// Enlaces a videos de YouTube.
class YoutubeLinks {
  YoutubeLinks._();

  /// Página para ver el video con la clave [youtubeKey] en el navegador.
  static Uri watchUrl(String youtubeKey) {
    return Uri.parse('https://www.youtube.com/watch?v=$youtubeKey');
  }

  /// Miniatura de YouTube (16:9) para la clave [youtubeKey].
  ///
  /// [size] acepta `default` (120×90), `mqdefault` (320×180),
  /// `hqdefault` (480×360) y `maxresdefault` (1280×720).
  static String thumbnailUrl(String youtubeKey, {String size = 'mqdefault'}) {
    return 'https://img.youtube.com/vi/$youtubeKey/$size.jpg';
  }
}
