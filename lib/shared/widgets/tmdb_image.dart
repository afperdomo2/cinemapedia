import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Tamaños de imagen que publica TMDB. Se elige el más chico que cubra el
/// espacio en pantalla para no bajar ni decodificar de más.
enum TmdbImageSize {
  w185,
  w342,
  w500,
  w780,
  w1280;

  String get fileName => name;
}

/// Imagen de TMDB con caché en disco, placeholder animado y fallback local.
class TmdbImage extends StatelessWidget {
  const TmdbImage(
    this.path, {
    super.key,
    this.size = TmdbImageSize.w342,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  /// Ruta relativa de TMDB (p. ej. `/abc.jpg`); vacía si no hay imagen.
  final String path;
  final TmdbImageSize size;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  static const _placeholder = AssetImage('assets/loaders/bottle-loader.gif');

  @override
  Widget build(BuildContext context) {
    final image = path.isEmpty
        ? _MissingImage(fit: fit, width: width, height: height)
        : CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/${size.fileName}$path',
            fit: fit,
            width: width,
            height: height,
            fadeInDuration: const Duration(milliseconds: 250),
            placeholder: (context, url) => Image(
              image: _placeholder,
              fit: fit,
              width: width,
              height: height,
            ),
            errorWidget: (context, url, error) =>
                _MissingImage(fit: fit, width: width, height: height),
          );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}

class _MissingImage extends StatelessWidget {
  const _MissingImage({required this.fit, this.width, this.height});

  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      color: colors.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(Icons.broken_image_outlined, color: colors.outline),
    );
  }
}
