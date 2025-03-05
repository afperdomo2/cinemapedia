import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
import 'package:cinemapedia/features/movies/presentation/widgets/vote_average.dart';
import 'package:cinemapedia/features/movies/presentation/widgets/vote_count.dart';
import 'package:flutter/material.dart';

typedef SearchMovieCallBack = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallBack searchMovies;
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({required this.searchMovies});

  void _onQueryChanged(String query) {
    debounceMovies.add([]);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        debounceMovies.add([]);
        return;
      }
      final movies = await searchMovies(query);
      debounceMovies.add(movies);
    });
  }

  void resetMovieStreams() {
    debounceMovies.close();
  }

  @override
  String get searchFieldLabel => 'Buscar películas';

  /// Este método se encarga de construir el widget que se muestra en la parte derecha del appbar.
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
        animate: query.isNotEmpty,
        duration: const Duration(milliseconds: 200),
        child: IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
      ),
    ];
  }

  /// Este método se encarga de construir el widget que se muestra en la parte izquierda del appbar.
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        resetMovieStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  /// Este método se encarga de construir el widget que se muestra cuando no hay sugerencias.
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);

    // NOTE: Revisar que al abrir o cerrar el teclado, se está ejecutando la búsqueda.
    return StreamBuilder(
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return GestureDetector(
              onTap: () {
                resetMovieStreams();
                close(context, movie);
                // context.push('/movie/${movie.id}');
              },
              child: _MovieItem(movie),
            );
          },
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem(this.movie);

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              movie.posterPath,
              width: size.width * 0.2,
              height: size.width * 0.3,
              fit: BoxFit.cover,
            ),
          ),

          /// Title and overview
          const SizedBox(width: 10),
          SizedBox(
            width: size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: textStyles.titleLarge!.copyWith(fontSize: 20)),
                const SizedBox(height: 5),
                Text(movie.overview, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(movie.releaseDate?.year.toString() ?? '', style: textStyles.titleSmall),
                    const SizedBox(width: 7),
                    const Icon(Icons.circle, size: 4, color: Colors.grey),
                    const SizedBox(width: 7),
                    VoteAverage(movie.voteAverage),
                    const SizedBox(width: 7),
                    const Icon(Icons.circle, size: 4, color: Colors.grey),
                    const SizedBox(width: 7),
                    VoteCount(movie.voteCount),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
