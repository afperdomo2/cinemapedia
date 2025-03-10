import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  static const name = 'favorites-screen';

  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas favoritas'),
      ),
      body: const Center(
        child: Text('Aquí se mostrarán tus películas favoritas'),
      ),
    );
  }
}
