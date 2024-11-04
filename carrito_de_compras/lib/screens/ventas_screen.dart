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
    final productos = await _productoService.getAll();
    setState(() => _productosFiltrados = productos
      .where((producto) => producto.nombre.contains(query) || producto.idCategoria.toString() == query)
      .toList());
  }

  Future<void> _buscarCliente(String cedula) async {
    final cliente = await _clienteService.getClienteByCedula(cedula);
    if (cliente != null) {
      setState(() => _clienteSeleccionado = cliente);
    } else {
      // En lugar de abrir el diálogo directamente, mostrar un mensaje
      final shouldCreateClient = await _mostrarCrearClienteDialog();
      if (shouldCreateClient) {
        _mostrarCrearCliente();
      }
    }
  }

  Future<bool> _mostrarCrearClienteDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cliente no encontrado'),
        content: const Text('¿Desea registrar un nuevo cliente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sí'),
          ),
        ],
      ),
    ).then((value) => value ?? false); // Manejar null
  }

  void _mostrarCrearCliente() {
    _nombreController.clear();
    _apellidoController.clear();

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
        direccion: 'Luque', // Replace with actual value
        telefono: '0984 971 774', // Replace with actual value
      );
      final clienteCreado = await _clienteService.create(cliente);
      setState(() => _clienteSeleccionado = clienteCreado);
      Navigator.pop(context);
      _mostrarMensaje('Cliente creado exitosamente.');
    } catch (e) {
      _mostrarError('Error al crear cliente');
    }
  }

  void _agregarAlCarrito(Producto producto) {
    // Limpiar el controlador antes de mostrar el diálogo
    _cantidadController.clear();

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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
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
                // Mostrar un mensaje de confirmación
                _mostrarMensaje('${producto.nombre} agregado al carrito');
              } else {
                _mostrarError('Ingrese una cantidad válida');
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  Future<void> _finalizarVenta() async {
    if (_clienteSeleccionado == null) {
      _mostrarError('Seleccione o registre un cliente');
      return;
    }
    if (_carrito.isEmpty) {
      _mostrarError('El carrito está vacío');
      return;
    }

    final venta = Venta(
      fecha: DateTime.now(),
      idCliente: _clienteSeleccionado!.idCliente!,
      detalles: _carrito,
      total: _calcularTotal(),
      clienteNombre: '${_clienteSeleccionado!.nombre} ${_clienteSeleccionado!.apellido}',
    );

    try {
      await _ventaService.create(venta);
      setState(() {
        _carrito.clear();
        _clienteSeleccionado = null;
      });
      _mostrarMensaje('Venta realizada con éxito');
    } catch (e) {
      _mostrarError('Error al realizar la venta');
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

  void _finalizarOrdenDesdeCarrito() {
    if (_carrito.isEmpty) {
      _mostrarError('El carrito está vacío');
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        final cedulaController = TextEditingController();
        final nombreController = TextEditingController();
        final apellidoController = TextEditingController();

        return AlertDialog(
          title: const Text('Finalizar Orden'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cedulaController,
                  decoration: const InputDecoration(labelText: 'Cédula del Cliente'),
                ),
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: apellidoController,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final cedula = cedulaController.text.trim();
                  final nombre = nombreController.text.trim();
                  final apellido = apellidoController.text.trim();
                  
                  if (cedula.isEmpty || nombre.isEmpty || apellido.isEmpty) {
                    _mostrarError('Todos los campos son requeridos');
                    return;
                  }

                  // Buscar o crear cliente
                  Cliente cliente;
                  final clienteExistente = await _clienteService.getClienteByCedula(cedula);
                  
                  if (clienteExistente != null) {
                    cliente = clienteExistente;
                  } else {
                    cliente = await _clienteService.create(Cliente(
                      cedula: cedula,
                      nombre: nombre,
                      apellido: apellido,
                      direccion: 'Dirección por defecto',
                      telefono: 'Teléfono por defecto',
                    ));
                  }

                  // Verificar que el cliente tenga ID
                  if (cliente.idCliente == null) {
                    throw Exception('Error al generar ID de cliente');
                  }

                  // Crear y guardar la venta
                  final venta = Venta(
                    fecha: DateTime.now(),
                    idCliente: cliente.idCliente!,
                    detalles: List.from(_carrito),
                    total: _calcularTotal(),
                    clienteNombre: '${cliente.nombre} ${cliente.apellido}',
                  );

                  await _ventaService.create(venta);

                  setState(() {
                    _carrito.clear();
                    _clienteSeleccionado = null;
                  });

                  Navigator.pop(context);
                  _mostrarMensaje('Venta realizada con éxito');
                } catch (e) {
                  print('Error detallado: $e'); // Para depuración
                  _mostrarError('Error al procesar la venta: ${e.toString()}');
                }
              },
              child: const Text('Finalizar'),
            ),
          ],
        );
      },
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
        onPressed: _carrito.isNotEmpty ? _finalizarOrdenDesdeCarrito : null,
        label: const Text('Finalizar Orden'),
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
