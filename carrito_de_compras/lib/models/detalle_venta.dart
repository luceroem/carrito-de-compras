// lib/models/detalle_venta.dart

import 'producto.dart';

class DetalleVenta {
  final Producto producto;
  final int cantidad;
  final double precio;

  DetalleVenta({
    required this.producto,
    required this.cantidad,
    required this.precio,
  });

  factory DetalleVenta.fromJson(Map<String, dynamic> json) {
    return DetalleVenta(
      producto: Producto.fromJson(json['producto']),
      cantidad: json['cantidad'] as int,
      precio: (json['precio'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'producto': producto.toJson(),
      'cantidad': cantidad,
      'precio': precio,
    };
  }
}
