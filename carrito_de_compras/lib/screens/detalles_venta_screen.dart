// lib/screens/detalles_venta_screen.dart

import 'package:flutter/material.dart';
import '../models/venta.dart';

class DetallesVentaScreen extends StatelessWidget {
  final Venta venta;

  const DetallesVentaScreen({Key? key, required this.venta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Venta'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Agregando padding para mejor presentación
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinear contenido a la izquierda
            children: [
              ListTile(
                title: Text('Cliente: ${venta.clienteNombre}'),
                subtitle: Text('Fecha: ${_formatoFecha(venta.fecha)}'),
                trailing: Text('Total: \$${venta.total.toStringAsFixed(2)}', 
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              const Text('Productos:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8), // Espaciado entre el título y la lista de productos
              ...venta.detalles.map((detalle) => ListTile(
                title: Text(detalle.producto.nombre),
                subtitle: Text('Cantidad: ${detalle.cantidad}'),
                trailing: Text('\$${(detalle.cantidad * detalle.precio).toStringAsFixed(2)}'),
              )),
            ],
          ),
        ),
      ),
    );
  }

  String _formatoFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }
}