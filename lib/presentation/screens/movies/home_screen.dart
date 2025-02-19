import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  ConsumerState<_HomeView> createState() => __HomeViewState();
}

class __HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    // Carga la primera página de películas en cines.
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final moviesSlideShow = ref.watch(moviewsSlideShowProvider);
    final loadNextPage = ref.read(nowPlayingMoviesProvider.notifier).loadNextPage;

    if (moviesSlideShow.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true, // Indica si el appbar debe ser flotante.
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: const CustomAppBar(),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Column(
              children: [
                // const CustomAppBar(),
                const SizedBox(height: 2),
                MoviesSlideShow(movies: moviesSlideShow),
                MoviesHorizontalListView(
                  nowPlayingMovies,
                  title: 'En cines',
                  subtitle: 'Lunes 17',
                  loadNextPage: () => loadNextPage(),
                ),
                MoviesHorizontalListView(
                  nowPlayingMovies,
                  title: 'Próximamente',
                  subtitle: 'Estrenos',
                  loadNextPage: () => loadNextPage(),
                ),
                MoviesHorizontalListView(
                  nowPlayingMovies,
                  title: 'Populares',
                  subtitle: 'Semana',
                  loadNextPage: () => loadNextPage(),
                ),
                MoviesHorizontalListView(
                  nowPlayingMovies,
                  title: 'Mejor valoradas',
                  subtitle: '2024',
                  loadNextPage: () => loadNextPage(),
                ),
                const SizedBox(height: 10),
              ],
            )
          ]),
        ),
      ],
    );
  }
}
