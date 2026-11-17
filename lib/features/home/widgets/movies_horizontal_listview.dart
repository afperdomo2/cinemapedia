import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/config/responsive.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/features/home/widgets/movie_card.dart';
import 'package:cinemapedia/features/movie_details/screens/movie_details_screen.dart';
import 'package:cinemapedia/shared/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviesHorizontalListView extends StatefulWidget {
  final MoviesState state;
  final String? title;
  final String? subtitle;
  final VoidCallback? onLoadMore;

  const MoviesHorizontalListView(
    this.state, {
    super.key,
    this.title,
    this.subtitle,
    this.onLoadMore,
  });

  @override
  State<MoviesHorizontalListView> createState() =>
      _MoviesHorizontalListViewState();
}

class _MoviesHorizontalListViewState extends State<MoviesHorizontalListView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController
        .dispose(); // Libera los recursos del controlador de scroll.
    super.dispose();
  }

  void _onScroll() {
    if (widget.onLoadMore == null) return;
    if (!scrollController.hasClients) return;

    final position = scrollController.position;
    final isNearEndOfList = position.pixels > position.maxScrollExtent - 300;
    if (isNearEndOfList) {
      widget.onLoadMore!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final movies = widget.state.movies;

    // En tablets/escritorio las tarjetas crecen manteniendo la proporción
    final cardWidth =
        Responsive.posterCardWidth(MediaQuery.sizeOf(context).width);
    final listHeight =
        cardWidth * 220 / 135 + 130; // imagen + rating + título + márgenes

    // Sección sin contenido y con error: se muestra inline, sin bloquear a las
    // demás secciones.
    if (movies.isEmpty && widget.state.hasError) {
      return SizedBox(
        height: 160,
        child: ErrorView(
          compact: true,
          message: widget.state.errorMessage!,
          onRetry: () => widget.onLoadMore?.call(),
        ),
      );
    }

    if (movies.isEmpty && widget.state.isInitialLoading) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return SizedBox(
      height: listHeight,
      child: Column(
        children: [
          if (widget.title != null || widget.subtitle != null)
            _Title(widget.title, widget.subtitle),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: movies.length + (widget.state.isLoadingMore ? 1 : 0),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (index >= movies.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                return _MovieItem(movies[index], cardWidth: cardWidth);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieItem extends StatelessWidget {
  const _MovieItem(this.movie, {required this.cardWidth});

  final Movie movie;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Ver detalles de ${movie.title}',
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.pushNamed(
          MovieDetailsScreen.name,
          pathParameters: {'movieId': '${movie.id}'},
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: MovieCard(movie, imageWidth: cardWidth),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const _Title(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Row(
        children: [
          if (title != null) Expanded(child: Text(title!, style: titleStyle)),
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.labelMedium,
            ),
        ],
      ),
    );
  }
}
