import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/features/home/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    scrollController
        .dispose(); // Libera los recursos utilizados por el controlador de desplazamiento.
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if (widget.title != null || widget.subtitle != null)
            _Title(widget.title, widget.subtitle),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.push('/movie/${widget.movies[index].id}');
                  },
                  child: FadeInRight(
                    child: MovieCard(widget.movies[index]),
                  ),
                );
              },
            ),
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
