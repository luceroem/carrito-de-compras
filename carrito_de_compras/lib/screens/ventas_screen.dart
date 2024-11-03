import 'package:flutter/material.dart';

class Producto {
  final int idProducto;
  final String nombre;
  final double precioVenta;

  Producto({required this.idProducto, required this.nombre, required this.precioVenta});
}

class Cliente {
  final int idCliente;
  final String cedula;
  final String nombre;
  final String apellido;

  Cliente({
    required this.idCliente,
    required this.cedula,
    required this.nombre,
    required this.apellido,
  });
}

class DetalleVenta {
  final Producto producto;
  int cantidad;

  DetalleVenta({required this.producto, required this.cantidad});
}

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  _VentasScreenState createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  final List<Producto> productos = [
    Producto(idProducto: 1, nombre: 'Producto 1', precioVenta: 10.0),
    Producto(idProducto: 2, nombre: 'Producto 2', precioVenta: 15.0),
    Producto(idProducto: 3, nombre: 'Producto 3', precioVenta: 20.0),
  ];

  final List<DetalleVenta> carrito = [];

  // Función para agregar producto al carrito
  void _agregarAlCarrito(Producto producto) {
    setState(() {
      var item = carrito.firstWhere(
        (detalle) => detalle.producto.idProducto == producto.idProducto,
        orElse: () => DetalleVenta(producto: producto, cantidad: 0),
      );

      if (!carrito.contains(item)) {
        item.cantidad = 1;
        carrito.add(item);
      } else {
        item.cantidad++;
      }
    });
  }

  // Función para ver el carrito y finalizar la compra
  void _finalizarCompra() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String cedula = '';
        String nombre = '';
        String apellido = '';

        return AlertDialog(
          title: const Text('Finalizar Compra'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Cédula'),
                onChanged: (value) {
                  cedula = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                onChanged: (value) {
                  nombre = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Apellido'),
                onChanged: (value) {
                  apellido = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Aquí se almacenaría la información del cliente y la venta
                Cliente cliente = Cliente(
                  idCliente: 1, // Esto es solo un ejemplo, puedes generarlo dinámicamente
                  cedula: cedula,
                  nombre: nombre,
                  apellido: apellido,
                );

                // Guardar los detalles de la venta
                _guardarVenta(cliente);

                // Limpiar el carrito
                setState(() {
                  carrito.clear();
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Compra finalizada exitosamente')),
                );
              },
              child: const Text('Finalizar'),
            ),
          ],
        );
      },
    );
  }

  void _guardarVenta(Cliente cliente) {
    // Aquí puedes guardar los detalles de la venta
    // Esto incluye guardar en una lista o enviar a una base de datos si la tienes configurada
    print('Venta guardada para cliente ${cliente.nombre} ${cliente.apellido}');
    for (var item in carrito) {
      print('Producto: ${item.producto.nombre}, Cantidad: ${item.cantidad}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realizar Venta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return ListView(
                    children: carrito.map((item) {
                      return ListTile(
                        title: Text('${item.producto.nombre} (x${item.cantidad})'),
                        subtitle: Text('Total: \$${item.producto.precioVenta * item.cantidad}'),
                      );
                    }).toList()
                      ..add(
                        ListTile(
                          title: const Text('Finalizar Compra'),
                          trailing: IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: _finalizarCompra,
                          ),
                        ),
                      ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];
          return ListTile(
            title: Text(producto.nombre),
            subtitle: Text('Precio: \$${producto.precioVenta}'),
            trailing: IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () {
                _agregarAlCarrito(producto);
              },
            ),
          );
        },
      ),
    );
  }
}
