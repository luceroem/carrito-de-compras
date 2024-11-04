// lib/screens/consultas_ventas_screen.dart

import 'package:flutter/material.dart';
import '../models/venta.dart';
import '../services/venta_service.dart';
import '../services/cliente_service.dart';

class ConsultasVentasScreen extends StatefulWidget {
  const ConsultasVentasScreen({super.key});

  @override
  ConsultasVentasScreenState createState() => ConsultasVentasScreenState();
}

class ConsultasVentasScreenState extends State<ConsultasVentasScreen> {
  final VentaService _ventaService = VentaService();
  final ClienteService _clienteService = ClienteService();
  final TextEditingController _clienteController = TextEditingController();

  List<Venta> _ventas = [];
  List<Venta> _ventasFiltradas = [];
  DateTime? _fechaSeleccionada;
  String _filtroCliente = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarVentas();
  }

  Future<void> _cargarVentas() async {
    setState(() => _isLoading = true);
    try {
      final ventas = await _ventaService.getAll();
      setState(() {
        _ventas = ventas;
        _ventasFiltradas = ventas;
      });
    } catch (e) {
      _mostrarError('Error al cargar ventas');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filtrarVentas() {
    setState(() {
      _ventasFiltradas = _ventas.where((venta) {
        final coincideCliente = _filtroCliente.isEmpty ||
            venta.cliente.nombreCompleto
                .toLowerCase()
                .contains(_filtroCliente.toLowerCase());
                
        final coincideFecha = _fechaSeleccionada == null ||
            (venta.fecha.year == _fechaSeleccionada!.year &&
                venta.fecha.month == _fechaSeleccionada!.month &&
                venta.fecha.day == _fechaSeleccionada!.day);
                
        return coincideCliente && coincideFecha;
      }).toList();
    });
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
        _filtrarVentas();
      });
    }
  }

  void _verDetallesVenta(Venta venta) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalles de la Venta'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cliente: ${venta.cliente.nombreCompleto}'),
              Text('Fecha: ${_formatoFecha(venta.fecha)}'),
              Text('Total: \$${venta.total.toStringAsFixed(2)}'),
              const Divider(),
              const Text('Productos:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...venta.detalles.map((detalle) => ListTile(
                title: Text(detalle.producto.nombre),
                subtitle: Text(
                  'Cantidad: ${detalle.cantidad}\n'
                  'Precio: \$${detalle.precio.toStringAsFixed(2)}'
                ),
                trailing: Text(
                  '\$${(detalle.cantidad * detalle.precio).toStringAsFixed(2)}'
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  String _formatoFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  void _limpiarFiltros() {
    setState(() {
      _fechaSeleccionada = null;
      _filtroCliente = '';
      _clienteController.clear();
      _ventasFiltradas = _ventas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Ventas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_off),
            onPressed: _limpiarFiltros,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _clienteController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar por cliente',
                      prefixIcon: Icon(Icons.person_search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filtroCliente = value;
                        _filtrarVentas();
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _seleccionarFecha,
                ),
              ],
            ),
          ),
          if (_fechaSeleccionada != null)
            Chip(
              label: Text(_formatoFecha(_fechaSeleccionada!)),
              onDeleted: () {
                setState(() {
                  _fechaSeleccionada = null;
                  _filtrarVentas();
                });
              },
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _ventasFiltradas.length,
                    itemBuilder: (context, index) {
                      final venta = _ventasFiltradas[index];
                      return ListTile(
                        title: Text(venta.cliente.nombreCompleto),
                        subtitle: Text(_formatoFecha(venta.fecha)),
                        trailing: Text('\$${venta.total.toStringAsFixed(2)}'),
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