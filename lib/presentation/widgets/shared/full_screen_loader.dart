import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  final messages = <String>[
    'Buscando los mejores asientos...',
    'Preparando la pantalla grande...',
    'Revisando los trailers...',
    'Haciendo palomitas...',
    'Limpiando las butacas...',
    'Encendiendo las luces...',
    'Acomodando el sonido...',
    'Preparando el escenario...',
    'Esto está tardando más de lo esperado...',
  ];

  /// Crea un stream que emite un mensaje diferente cada segundo.
  Stream<String> get messageStream {
    return Stream.periodic(
      const Duration(milliseconds: 1500),
      (i) => messages[i % messages.length],
    ).take(messages.length);
  }

  FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: messageStream,
            builder: (context, snapshot) => Text(snapshot.data ?? 'Cargando palomitas...'),
          ),
        ],
      ),
    );
  }
}
