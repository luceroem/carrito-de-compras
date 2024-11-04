// lib/screens/ventas_screen.dart

import 'package:flutter/material.dart';
import '../models/venta.dart';
import '../models/cliente.dart';
import '../models/producto.dart';
import '../models/detalle_venta.dart';
import '../services/venta_service.dart';
import '../services/cliente_service.dart';
import '../services/producto_service.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  VentasScreenState createState() => VentasScreenState();
}

class VentasScreenState extends State<VentasScreen> {
  final _productoController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  
  final List<DetalleVenta> _carrito = [];
  List<Producto> _productosFiltrados = [];
  Cliente? _clienteSeleccionado;
  
  final _ventaService = VentaService();
  final _clienteService = ClienteService();
  final _productoService = ProductoService();

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    try {
      final productos = await _productoService.getAll();
      setState(() => _productosFiltrados = productos);
    } catch (e) {
      _mostrarError('Error al cargar productos');
    }
  }

  Future<void> _buscarProductos(String query) async {
    if (query.isEmpty) {
      await _cargarProductos();
      return;
    }
    
    try {
      final productos = await _productoService.getAll();
      setState(() => _productosFiltrados = productos.where((producto) => producto.nombre.contains(query)).toList());
    } catch (e) {
      _mostrarError('Error al buscar productos');
    }
  }

  Future<void> _buscarCliente(String cedula) async {
    try {
      final cliente = await _clienteService.buscarPorCedula(cedula);
      setState(() => _clienteSeleccionado = cliente);
    } catch (e) {
      _mostrarCrearCliente();
    }
  }

  void _mostrarCrearCliente() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Cliente'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidoController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _crearCliente(),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _crearCliente() async {
    try {
      final cliente = Cliente(
        cedula: _cedulaController.text,
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
      );
      final clienteCreado = await _clienteService.create(cliente);
      setState(() => _clienteSeleccionado = clienteCreado);
      Navigator.pop(context);
    } catch (e) {
      _mostrarError('Error al crear cliente');
    }
  }

  void _agregarAlCarrito(Producto producto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Agregar ${producto.nombre}'),
        content: TextField(
          controller: _cantidadController,
          decoration: const InputDecoration(labelText: 'Cantidad'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              final cantidad = int.tryParse(_cantidadController.text) ?? 0;
              if (cantidad > 0) {
                setState(() {
                  _carrito.add(DetalleVenta(
                    producto: producto,
                    cantidad: cantidad,
                    precio: producto.precioVenta,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  Future<void> _finalizarVenta() async {
    if (_carrito.isEmpty || _clienteSeleccionado == null) {
      _mostrarError('Complete los datos de la venta');
      return;
    }

    try {
      final venta = Venta(
        fecha: DateTime.now(),
        cliente: _clienteSeleccionado!,
        detalles: _carrito,
      );
      await _ventaService.create(venta);
      setState(() {
        _carrito.clear();
        _clienteSeleccionado = null;
      });
      _mostrarMensaje('Venta realizada con éxito');
    } catch (e) {
      _mostrarError('Error al procesar la venta');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Venta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => _mostrarCarrito(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Búsqueda de cliente
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _cedulaController,
              decoration: const InputDecoration(
                labelText: 'Cédula del Cliente',
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) => _buscarCliente(value),
            ),
          ),
          // Cliente seleccionado
          if (_clienteSeleccionado != null)
            ListTile(
              title: Text('${_clienteSeleccionado!.nombre} ${_clienteSeleccionado!.apellido}'),
              subtitle: Text('Cédula: ${_clienteSeleccionado!.cedula}'),
            ),
          // Búsqueda de productos
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _productoController,
              decoration: const InputDecoration(
                labelText: 'Buscar Producto',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _buscarProductos,
            ),
          ),
          // Lista de productos
          Expanded(
            child: ListView.builder(
              itemCount: _productosFiltrados.length,
              itemBuilder: (context, index) {
                final producto = _productosFiltrados[index];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('\$${producto.precioVenta}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () => _agregarAlCarrito(producto),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _finalizarVenta,
        label: const Text('Finalizar Venta'),
        icon: const Icon(Icons.check),
      ),
    );
  }

  void _mostrarCarrito() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          ListTile(
            title: const Text('Carrito de Compras'),
            trailing: Text('Total: \$${_calcularTotal()}'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _carrito.length,
              itemBuilder: (context, index) {
                final detalle = _carrito[index];
                return ListTile(
                  title: Text(detalle.producto.nombre),
                  subtitle: Text('Cantidad: ${detalle.cantidad}'),
                  trailing: Text('\$${detalle.precio * detalle.cantidad}'),
                  leading: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() => _carrito.removeAt(index));
                      Navigator.pop(context);
                      _mostrarCarrito();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _calcularTotal() {
    return _carrito.fold(
      0, 
      (total, detalle) => total + (detalle.precio * detalle.cantidad)
    );
  }
}