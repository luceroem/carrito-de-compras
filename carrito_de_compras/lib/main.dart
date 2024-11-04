import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/categorias_screen.dart';
import 'screens/productos_screen.dart';
import 'screens/ventas_screen.dart';
import 'screens/consultas_ventas_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carrito de Compras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/categorias': (context) => const CategoriasScreen(),
        '/productos': (context) => const ProductosScreen(),
        '/ventas': (context) => const VentasScreen(),
        '/consultas': (context) => const ConsultasVentasScreen(),
      },
    );
  }
}