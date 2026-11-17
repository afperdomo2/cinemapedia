import 'dart:io';

/// `true` en las plataformas donde la app puede reproducir video embebido.
///
/// El reproductor de `youtube_player_flutter` se apoya en `flutter_inappwebview`,
/// un plugin implementado solo para Android e iOS. En Linux/Windows/macOS no
/// existe la vista web del reproductor, así que esas plataformas degradan a
/// abrir el video en el navegador del sistema.
bool get isMobilePlatform => Platform.isAndroid || Platform.isIOS;
