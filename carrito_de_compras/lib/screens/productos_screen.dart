import 'package:flutter/material.dart';

class Producto {
  final int idProducto;
  final String nombre;
  final int idCategoria;
  final double precioVenta;

  Producto({
    required this.idProducto,
    required this.nombre,
    required this.idCategoria,
    required this.precioVenta,
  });
}

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  ProductosScreenState createState() => ProductosScreenState();
}

class ProductosScreenState extends State<ProductosScreen> {
  final List<Producto> productos = [];
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  void _agregarProducto() {
    if (_nombreController.text.isNotEmpty && _precioController.text.isNotEmpty) {
      setState(() {
        productos.add(Producto(
          idProducto: productos.length + 1,
          nombre: _nombreController.text,
          idCategoria: 1, // Usa un valor fijo por ahora
          precioVenta: double.parse(_precioController.text),
        ));
        _nombreController.clear();
        _precioController.clear();
      });
    }
  }

  void _eliminarProducto(int index) {
    setState(() {
      productos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Productos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre del Producto',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _agregarProducto,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _precioController,
              decoration: const InputDecoration(
                labelText: 'Precio de Venta',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${productos[index].nombre} - ${productos[index].precioVenta}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _eliminarProducto(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
