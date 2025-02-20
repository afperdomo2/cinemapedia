import 'package:cinemapedia/config/helpers/human_formatter.dart';
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

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final moviesSlideShow = ref.watch(moviewsSlideShowProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);

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
                  title: 'En cartelera',
                  subtitle: HumanFormatter.currentDa(DateTime.now()),
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
                ),
                MoviesHorizontalListView(
                  popularMovies,
                  title: 'Populares',
                  loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage(),
                ),
                MoviesHorizontalListView(
                  topRatedMovies,
                  title: 'Mejor valoradas',
                  loadNextPage: () => ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
                ),
                MoviesHorizontalListView(
                  upcomingMovies,
                  title: 'Próximamente',
                  loadNextPage: () => ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
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
