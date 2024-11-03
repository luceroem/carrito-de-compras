import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/categorias');
              },
              child: const Text('Administrar Categorías'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/productos');
              },
              child: const Text('Administrar Productos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/ventas');
              },
              child: const Text('Realizar Venta'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/consultas');
              },
              child: const Text('Consultar Ventas'),
            ),
          ],
        ),
      ),
    );
  }
}
