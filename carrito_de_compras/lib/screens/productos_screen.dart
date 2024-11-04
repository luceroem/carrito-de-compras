import 'package:flutter/material.dart';

class Producto {
  final int idProducto;
  String nombre;
  double precioVenta;
  int idCategoria;

  Producto({
    required this.idProducto,
    required this.nombre,
    required this.precioVenta,
    required this.idCategoria,
  });
}

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  ProductosScreenState createState() => ProductosScreenState();
}

class ProductosScreenState extends State<ProductosScreen> {
  final List<Producto> productos = [];
  final List<Producto> productosFiltrados = [];
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _buscarController = TextEditingController();

  void _agregarProducto() {
    if (_nombreController.text.isNotEmpty && _precioController.text.isNotEmpty) {
      setState(() {
        productos.add(Producto(
          idProducto: productos.length + 1,
          nombre: _nombreController.text,
          precioVenta: double.tryParse(_precioController.text) ?? 0.0,
          idCategoria: 1, // Default category
        ));
        _nombreController.clear();
        _precioController.clear();
      });
    }
  }
  
  void _filtrarProductos(String query) {
    setState(() {
      productosFiltrados.clear();
      productosFiltrados.addAll(
        productos.where((producto) => 
          producto.nombre.toLowerCase().contains(query.toLowerCase())
        )
      );
    });
  }

  void _editarProducto(Producto producto) {
    _nombreController.text = producto.nombre;
    _precioController.text = producto.precioVenta.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _precioController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                producto.nombre = _nombreController.text;
                producto.precioVenta = double.tryParse(_precioController.text) ?? producto.precioVenta;
                _nombreController.clear();
                _precioController.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
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
              controller: _buscarController,
              decoration: const InputDecoration(
                labelText: 'Buscar producto',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filtrarProductos,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre del Producto'),
                ),
                TextField(
                  controller: _precioController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: _agregarProducto,
                  child: const Text('Agregar Producto'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: productosFiltrados.isEmpty 
                ? productos.length 
                : productosFiltrados.length,
              itemBuilder: (context, index) {
                final producto = productosFiltrados.isEmpty 
                  ? productos[index] 
                  : productosFiltrados[index];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('Precio: \$${producto.precioVenta.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editarProducto(producto),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _eliminarProducto(index),
                      ),
                    ],
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