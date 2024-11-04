// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carrito_de_compras/main.dart';

void main() {
  testWidgets('App should render home screen', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify app structure
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    
    // Verify app title
    expect(find.text('Carrito de Compras'), findsOneWidget);
    
    // Verify buttons exist
    expect(find.byType(ElevatedButton), findsNWidgets(4));
    
    // Verify button text
    expect(find.text('Administrar Categorías'), findsOneWidget);
    expect(find.text('Administrar Productos'), findsOneWidget);
    expect(find.text('Realizar Venta'), findsOneWidget);
    expect(find.text('Consultar Ventas'), findsOneWidget);

    // Test navigation
    await tester.tap(find.text('Administrar Categorías'));
    await tester.pumpAndSettle();
  });
}