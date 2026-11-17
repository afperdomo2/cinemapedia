import 'package:cinemapedia/config/responsive.dart';
import 'package:flutter/material.dart';

/// Bloque placeholder con pulso suave, para pantallas de carga.
///
/// Los skeletons muestran la forma del contenido que viene (pósters, títulos,
/// slideshow) en vez de un spinner: la pantalla "ya parece" la definitiva.
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  final double? width;
  final double? height;
  final double borderRadius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;

    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 0.9).animate(_controller),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}

/// Grilla de pósters placeholder para las pantallas con [MoviesGrid].
class MoviesSkeletonGrid extends StatelessWidget {
  const MoviesSkeletonGrid({super.key, this.itemCount = 12});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount =
        Responsive.posterColumns(MediaQuery.sizeOf(context).width);

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 2 / 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const SkeletonBox(borderRadius: 16),
    );
  }
}

/// Placeholder del inicio: slideshow + las tres filas horizontales.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        /// Slideshow
        Padding(
          padding: const EdgeInsets.all(8),
          child: SkeletonBox(
            width: width,
            height: 240,
            borderRadius: 16,
          ),
        ),

        /// Secciones: título + fila de pósters
        for (var section = 0; section < 3; section++) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 16, 12, 8),
            child: SkeletonBox(width: 140, height: 18),
          ),
          SizedBox(
            height: 190,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) => const SkeletonBox(
                width: 115,
                height: 172,
                borderRadius: 12,
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}
