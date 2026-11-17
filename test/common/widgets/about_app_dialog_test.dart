import 'package:cinemapedia/common/widgets/about_app_button.dart';
import 'package:cinemapedia/common/widgets/about_app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  Future<void> pumpDialog(
    WidgetTester tester, {
    required String version,
    String buildNumber = '',
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AboutAppDialog(version: version, buildNumber: buildNumber),
        ),
      ),
    );
  }

  testWidgets('muestra la versión con el número de build', (tester) async {
    await pumpDialog(tester, version: '0.2.0', buildNumber: '3');

    expect(find.text('Versión 0.2.0 (build 3)'), findsOneWidget);
    expect(find.text('Cerrar'), findsOneWidget);
  });

  testWidgets('oculta el número de build cuando está vacío', (tester) async {
    await pumpDialog(tester, version: '0.2.0');

    expect(find.text('Versión 0.2.0'), findsOneWidget);
    expect(find.textContaining('build'), findsNothing);
  });

  testWidgets('el botón de la app bar abre el diálogo con la versión',
      (tester) async {
    PackageInfo.setMockInitialValues(
      appName: 'cinemapedia',
      packageName: 'cinemapedia',
      version: '0.2.0',
      buildNumber: '3',
      buildSignature: '',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AboutAppButton()),
      ),
    );
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(find.byType(AboutAppDialog), findsOneWidget);
    expect(find.text('Versión 0.2.0 (build 3)'), findsOneWidget);
  });
}
