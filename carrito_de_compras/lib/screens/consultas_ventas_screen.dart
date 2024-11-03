import 'package:flutter/material.dart';

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

class Producto {
  final int idProducto;
  final String nombre;
  final double precioVenta;

  Producto({required this.idProducto, required this.nombre, required this.precioVenta});
}

class DetalleVenta {
  final Producto producto;
  final int cantidad;
  final double precio;

  DetalleVenta({required this.producto, required this.cantidad, required this.precio});
}

class Venta {
  final int idVenta;
  final DateTime fecha;
  final Cliente cliente;
  final double total;
  final List<DetalleVenta> detalles;

  Venta({
    required this.idVenta,
    required this.fecha,
    required this.cliente,
    required this.total,
    required this.detalles,
  });
}

class ConsultasVentasScreen extends StatefulWidget {
  const ConsultasVentasScreen({super.key});

  @override
  _ConsultasVentasScreenState createState() => _ConsultasVentasScreenState();
}

class _ConsultasVentasScreenState extends State<ConsultasVentasScreen> {
  List<Venta> ventas = [
    Venta(
      idVenta: 1,
      fecha: DateTime.now(),
      cliente: Cliente(idCliente: 1, cedula: '12345678', nombre: 'Juan', apellido: 'Pérez'),
      total: 100.0,
      detalles: [
        DetalleVenta(
          producto: Producto(idProducto: 1, nombre: 'Producto 1', precioVenta: 50.0),
          cantidad: 1,
          precio: 50.0,
        ),
        DetalleVenta(
          producto: Producto(idProducto: 2, nombre: 'Producto 2', precioVenta: 50.0),
          cantidad: 1,
          precio: 50.0,
        ),
      ],
    ),
    // Puedes agregar más ventas para simular datos
  ];

  List<Venta> ventasFiltradas = [];
  String filtroCliente = '';
  DateTime? filtroFecha;

  @override
  void initState() {
    super.initState();
    ventasFiltradas = ventas;
  }

  void _filtrarVentas() {
    setState(() {
      ventasFiltradas = ventas.where((venta) {
        final coincideCliente = filtroCliente.isEmpty ||
            '${venta.cliente.nombre} ${venta.cliente.apellido}'
                .toLowerCase()
                .contains(filtroCliente.toLowerCase());
        final coincideFecha = filtroFecha == null ||
            (venta.fecha.year == filtroFecha!.year &&
                venta.fecha.month == filtroFecha!.month &&
                venta.fecha.day == filtroFecha!.day);
        return coincideCliente && coincideFecha;
      }).toList();
    });
  }

  void _seleccionarFecha(BuildContext context) async {
    final fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (fechaSeleccionada != null) {
      setState(() {
        filtroFecha = fechaSeleccionada;
        _filtrarVentas();
      });
    }
  }

  void _verDetallesVenta(Venta venta) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles de la Venta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Cliente: ${venta.cliente.nombre} ${venta.cliente.apellido}'),
              Text('Fecha: ${venta.fecha.toLocal()}'),
              Text('Total: \$${venta.total.toStringAsFixed(2)}'),
              const Divider(),
              Column(
                children: venta.detalles.map((detalle) {
                  return ListTile(
                    title: Text(detalle.producto.nombre),
                    subtitle: Text('Cantidad: ${detalle.cantidad} - Precio: \$${detalle.precio.toStringAsFixed(2)}'),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
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
        title: const Text('Consultas de Ventas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por cliente',
              ),
              onChanged: (value) {
                filtroCliente = value;
                _filtrarVentas();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(filtroFecha == null
                    ? 'Filtrar por fecha'
                    : 'Fecha: ${filtroFecha!.toLocal()}'),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _seleccionarFecha(context),
                ),
                if (filtroFecha != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        filtroFecha = null;
                        _filtrarVentas();
                      });
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ventasFiltradas.length,
              itemBuilder: (context, index) {
                final venta = ventasFiltradas[index];
                return ListTile(
                  title: Text('Venta #${venta.idVenta} - Total: \$${venta.total.toStringAsFixed(2)}'),
                  subtitle: Text(
                      'Cliente: ${venta.cliente.nombre} ${venta.cliente.apellido}\nFecha: ${venta.fecha.toLocal()}'),
                  onTap: () => _verDetallesVenta(venta),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
