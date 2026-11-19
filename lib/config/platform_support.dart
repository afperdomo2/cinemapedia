import 'dart:io';

/// `true` en las plataformas donde la app puede reproducir video embebido.
///
/// El reproductor de `youtube_player_flutter` se apoya en `webview_flutter`
/// (vía `youtube_player_iframe`), un plugin implementado para Android e iOS.
/// En Linux/Windows/macOS la app usa su propio reproductor con `media_kit`
/// (y si falla, abre el video en el navegador del sistema).
bool get isMobilePlatform => Platform.isAndroid || Platform.isIOS;
