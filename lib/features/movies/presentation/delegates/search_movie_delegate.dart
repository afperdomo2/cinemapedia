import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/features/movies/domain/entities/movie.dart';
import 'package:cinemapedia/features/movies/presentation/widgets/vote_average.dart';
import 'package:cinemapedia/features/movies/presentation/widgets/vote_count.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef SearchMovieCallBack = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallBack searchMovies;
  // final List<Movie> initialMovies;

  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  Timer? debounceTimer;
  bool isSearching = false;

  SearchMovieDelegate({
    required this.searchMovies,
    // required this.initialMovies,
  });

  @override
  String get searchFieldLabel => 'Buscar películas';

  void _onQueryChanged(String query) {
    if (debounceTimer?.isActive ?? false) {
      debounceTimer?.cancel();
    }
    isSearching = true;
    debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);
      query.isEmpty ? debounceMovies.add([]) : debounceMovies.add(movies);
      isSearching = false;
    });
  }

  void resetMovieStreams() {
    // if (!debounceMovies.isClosed) {
    //   debounceMovies.close();
    // }
    debounceMovies.close();
  }

  /// Botones de acción
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      /// Botón de limpiar búsqueda
      FadeIn(
        animate: query.isNotEmpty,
        duration: const Duration(milliseconds: 200),
        child: IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
      ),
    ];
  }

  /// Botón de regreso
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

  /// Resultados de la búsqueda
  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  /// Sugerencias de búsqueda
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);

    return StreamBuilder(
      stream: debounceMovies.stream,
      // initialData: initialMovies,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        if (isSearching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (movies.isEmpty) {
          return (query.isEmpty) ? const _SearchInputEmpty() : _MoviesNotFound(query: query);
        }

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return GestureDetector(
              onTap: () {
                // Actualizar el provider al seleccionar una película
                // Future.microtask(() {
                //   ref.read(searchQueryProvider.notifier).update((state) => movie.title);
                // });
                // resetMovieStreams(); // No se requiere cerrar la búsqueda
                // close(context, movie); // No se requiere cerrar la búsqueda
                context.push('/movie/${movie.id}');
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

class _SearchInputEmpty extends StatelessWidget {
  const _SearchInputEmpty();

  @override
  Widget build(BuildContext context) {
    const message = 'Ingresa el nombre de una película para buscarla';
    return Center(
      child: Text(message, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}

class _MoviesNotFound extends StatelessWidget {
  const _MoviesNotFound({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final message = "No se encontraron películas con el nombre: '$query'";

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie_creation_outlined, size: 60, color: Theme.of(context).primaryColorLight),
          Text(message, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
