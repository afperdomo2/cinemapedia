import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MoviesSlideShow extends StatelessWidget {
  final List<Movie> movies;

  const MoviesSlideShow({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 210,
      width: double.infinity,
      child: Swiper(
        viewportFraction: 0.8, // 80% de la pantalla
        scale: 0.9, // 90% del tamaño
        autoplay: true,
        pagination: _buildPaginationDots(colors),
        itemCount: movies.length,
        itemBuilder: (context, index) => _Slide(movies[index]),
      ),
    );
  }

  SwiperPagination _buildPaginationDots(colors) {
    return SwiperPagination(
      margin: const EdgeInsets.only(top: 10),
      alignment: Alignment.bottomCenter,
      builder: DotSwiperPaginationBuilder(
        activeColor: colors.primary,
        color: Colors.grey[400],
        size: 9,
        space: 4.5,
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide(this.movie);

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 10)),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: boxDecoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movie.backdropPath,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              return (loadingProgress == null)
                  ? FadeIn(child: child)
                  : const DecoratedBox(decoration: BoxDecoration(color: Colors.grey));
            },
          ),
        ),
      ),
    );
  }
}
