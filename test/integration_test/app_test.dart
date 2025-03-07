import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rickandmortyfilter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pruebas de integración de la aplicación completa', () {
    testWidgets('Verificar carga inicial y búsqueda de personajes', (
      WidgetTester tester,
    ) async {
      // Inicia la aplicación
      app.main();
      await tester.pumpAndSettle();

      // Verifica que la aplicación se cargue correctamente
      expect(find.text('Rick and Morty Characters'), findsOneWidget);

      // Espera a que se carguen los datos (puede requerir un tiempo)
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Debería haber personajes en la pantalla (al menos una tarjeta)
      expect(find.byType(Card), findsWidgets);

      // Busca un personaje
      await tester.enterText(find.byType(TextField).first, 'Rick');
      await tester.pumpAndSettle();

      // Verifica que hay resultados de búsqueda y que contienen "Rick"
      expect(find.textContaining('Rick', findRichText: true), findsWidgets);

      // Limpia la búsqueda
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Prueba el filtro de estado
      await tester.tap(find.text('All').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Alive').last);
      await tester.pumpAndSettle();

      // Debería mostrar personajes con estado "Alive"
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Verificar detalles de personaje', (WidgetTester tester) async {
      // Inicia la aplicación
      app.main();
      await tester.pumpAndSettle();

      // Espera a que se carguen los datos
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap en el primer personaje para ver detalles
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();

      // Verifica que aparezcan los detalles
      expect(find.text('Gender:'), findsOneWidget);
      expect(find.text('Origin:'), findsOneWidget);
      expect(find.text('Location:'), findsOneWidget);
    });
  });
}
