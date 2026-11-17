import 'package:cinemapedia/common/state/movies_state.dart';
import 'package:cinemapedia/config/responsive.dart';
import 'package:cinemapedia/shared/widgets/movie_poster_link.dart';
import 'package:flutter/material.dart';

/// Grilla de pósters con paginación infinita (favoritos, populares…).
///
/// La cantidad de columnas se adapta al ancho de la pantalla.
class MoviesGrid extends StatefulWidget {
  const MoviesGrid(
    this.state, {
    super.key,
    this.onLoadMore,
    this.controller,
  });

  final MoviesState state;
  final VoidCallback? onLoadMore;
  final ScrollController? controller;

  @override
  State<MoviesGrid> createState() => _MoviesGridState();
}

class _MoviesGridState extends State<MoviesGrid> {
  ScrollController? _internalController;

  ScrollController get _controller =>
      widget.controller ?? (_internalController ??= ScrollController());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _internalController?.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (widget.onLoadMore == null) return;
    if (!_controller.hasClients) return;

    final position = _controller.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      widget.onLoadMore!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final movies = widget.state.movies;
    final isLoadingMore = widget.state.isLoadingMore;
    final crossAxisCount =
        Responsive.posterColumns(MediaQuery.sizeOf(context).width);

    return GridView.builder(
      controller: _controller,
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 2 / 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: movies.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= movies.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        return MoviePosterLink(movies[index]);
      },
    );
  }
}
