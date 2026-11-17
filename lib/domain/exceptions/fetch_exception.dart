/// Error de dominio al obtener datos (red caída, timeout, servidor con error…).
///
/// Traduce los errores de infraestructura (Dio) a un error entendible por la
/// capa de presentación, con un mensaje apto para mostrar al usuario.
class FetchException implements Exception {
  const FetchException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'FetchException: $message';
}
