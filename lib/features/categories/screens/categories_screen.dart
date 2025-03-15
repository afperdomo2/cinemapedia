import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  static const name = 'categories-screen';

  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: const Center(
        child: Text('Aquí se mostrarán las categorías de películas'),
      ),
    );
  }
}
