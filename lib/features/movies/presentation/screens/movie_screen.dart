import 'package:flutter/material.dart';

class MovieScreen extends StatelessWidget {
  static const name = 'movie_screen';

  final String movieId;

  const MovieScreen(this.movieId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie - $movieId'),
      ),
      body: const Placeholder(),
    );
  }
}
