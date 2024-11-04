// lib/models/detalle_venta.dart

import 'producto.dart';

class DetalleVenta {
  final int? idDetalleVenta;  // Nullable for new items
  final int? idVenta;         // Nullable for new items
  final Producto producto;
  int cantidad;
  final double precio;

  DetalleVenta({
    this.idDetalleVenta,
    this.idVenta,
    required this.producto,
    required this.cantidad,
    required this.precio,
  });

  factory DetalleVenta.fromJson(Map<String, dynamic> json) {
    return DetalleVenta(
      idDetalleVenta: json['idDetalleVenta'],
      idVenta: json['idVenta'],
      producto: Producto.fromJson(json['producto']),
      cantidad: json['cantidad'],
      precio: json['precio'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDetalleVenta': idDetalleVenta,
      'idVenta': idVenta,
      'producto': producto.toJson(),
      'cantidad': cantidad,
      'precio': precio,
    };
  }

  double get subtotal => cantidad * precio;
}