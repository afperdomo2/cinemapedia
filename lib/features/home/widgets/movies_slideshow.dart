import 'package:card_swiper/card_swiper.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/features/home/widgets/movie_slide.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        autoplayDelay: 5000, // 5 segundos
        pagination: _buildPaginationDots(colors),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () => context.push('/movie/${movie.id}'),
            child: MovieSlide(movie),
          );
        },
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
