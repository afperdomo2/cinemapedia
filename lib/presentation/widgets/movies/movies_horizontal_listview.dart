import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formatter.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MoviesHorizontalListView extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage;

  const MoviesHorizontalListView(
    this.movies, {
    super.key,
    this.title,
    this.subtitle,
    this.loadNextPage,
  });

  @override
  State<MoviesHorizontalListView> createState() => _MoviesHorizontalListViewState();
}

class _MoviesHorizontalListViewState extends State<MoviesHorizontalListView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;
      final currentScrollPosition = scrollController.position.pixels;
      final maxScrollablePosition = scrollController.position.maxScrollExtent;
      final isNearEndOfList = currentScrollPosition > maxScrollablePosition - 300;
      // Si el usuario se encuentra cerca del final de la lista, se carga la siguiente página.
      if (isNearEndOfList) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    super.dispose(); // Libera los recursos utilizados por el widget.
    scrollController.dispose(); // Libera los recursos utilizados por el controlador de desplazamiento.
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title != null || widget.subtitle != null) _Title(widget.title, widget.subtitle),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => FadeInRight(child: _Slide(widget.movies[index])),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide(this.movie);

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    const imageWidth = 150.0;
    const imageHeight = 200.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image
          SizedBox(
            width: imageWidth,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                height: imageHeight,
                width: imageWidth,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  return (loadingProgress == null)
                      ? FadeIn(child: child)
                      : const DecoratedBox(decoration: BoxDecoration(color: Colors.grey));
                },
              ),
            ),
          ),

          const SizedBox(height: 5),

          /// Rating
          SizedBox(
            width: imageWidth,
            child: Row(
              children: [
                const Icon(Icons.star, size: 20, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  movie.voteAverage.toStringAsFixed(1),
                  style: textStyles.bodyMedium?.copyWith(color: Colors.yellow[800], fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(Icons.people, size: 14, color: Colors.grey),
                const SizedBox(width: 3),
                Text(
                  HumanFormatter.largeNumber(movie.voteCount.toDouble()),
                  style: textStyles.bodySmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(width: 2),
              ],
            ),
          ),

          /// Title
          SizedBox(
            width: imageWidth,
            child: Text(movie.title, maxLines: 2, style: textStyles.titleSmall),
          ),
        ],
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

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        children: [
          if (title != null) Text(title!, style: titleStyle),
          const Spacer(),
          if (subtitle != null)
            FilledButton.tonal(
              onPressed: () {},
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              child: Text(subtitle!),
            ),
        ],
      ),
    );
  }
}
