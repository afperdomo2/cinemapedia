import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Apertura de URLs externas con la mejor herramienta disponible del sistema.
class ExternalUrl {
  ExternalUrl._();

  /// Intenta abrir [url] en el navegador/aplicación predeterminada.
  ///
  /// Devuelve `null` si se abrió correctamente, o una descripción del error
  /// para poder informarle al usuario qué pasó.
  static Future<String?> open(Uri url) async {
    // 1) url_launcher: usa el navegador predeterminado del sistema.
    for (final mode in const [
      LaunchMode.externalApplication,
      LaunchMode.platformDefault,
    ]) {
      try {
        if (await launchUrl(url, mode: mode)) return null;
      } catch (error) {
        debugPrint('launchUrl($mode) falló para $url: $error');
      }
    }

    // 2) Último recurso: comando de apertura de cada plataforma. En sistemas
    // con la asociación de navegador rota, estos comandos suelen resolver.
    final command = _systemOpenCommand(url);
    if (command != null) {
      try {
        final result = await Process.run(command.executable, command.arguments);
        if (result.exitCode == 0) return null;
        final detail = (result.stderr as String).trim();
        return detail.isNotEmpty
            ? detail
            : 'el comando ${command.executable} falló';
      } catch (error) {
        return error.toString();
      }
    }

    return 'no hay navegador configurado en el sistema';
  }

  static ({String executable, List<String> arguments})? _systemOpenCommand(
      Uri url) {
    if (Platform.isWindows) {
      return (
        executable: 'cmd',
        arguments: ['/c', 'start', '', url.toString()]
      );
    }
    if (Platform.isMacOS) {
      return (executable: 'open', arguments: [url.toString()]);
    }
    if (Platform.isLinux) {
      return (executable: 'xdg-open', arguments: [url.toString()]);
    }
    return null;
  }
}
