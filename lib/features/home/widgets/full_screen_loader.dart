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

  /// Se crea una sola vez para que los mensajes no se reinicien en cada build.
  late final Stream<String> messageStream = Stream.periodic(
    const Duration(milliseconds: 1500),
    (i) => messages[i % messages.length],
  ).take(messages.length);

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
            builder: (context, snapshot) =>
                Text(snapshot.data ?? 'Cargando palomitas...'),
          ),
        ],
      ),
    );
  }
}
