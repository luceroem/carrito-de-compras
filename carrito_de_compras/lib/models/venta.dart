// lib/models/venta.dart

import 'package:carrito_de_compras/models/cliente.dart';
import 'package:carrito_de_compras/models/detalle_venta.dart';

class Venta {
  final int? idVenta;
  final DateTime fecha;
  final Cliente cliente;
  final List<DetalleVenta> detalles;
  double total;

  Venta({
    this.idVenta,
    required this.fecha,
    required this.cliente,
    required this.detalles,
    this.total = 0,
  }) {
    calcularTotal();
  }

  Venta copyWith({
    int? idVenta,
    DateTime? fecha,
    Cliente? cliente,
    List<DetalleVenta>? detalles,
    double? total,
  }) {
    return Venta(
      idVenta: idVenta ?? this.idVenta,
      fecha: fecha ?? this.fecha,
      cliente: cliente ?? this.cliente,
      detalles: detalles ?? this.detalles,
      total: total ?? this.total,
    );
  }

  void calcularTotal() {
    total = detalles.fold(
      0, 
      (sum, detalle) => sum + (detalle.precio * detalle.cantidad)
    );
  }

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      idVenta: json['idVenta'],
      fecha: DateTime.parse(json['fecha']),
      cliente: Cliente.fromJson(json['cliente']),
      detalles: (json['detalles'] as List)
          .map((detalle) => DetalleVenta.fromJson(detalle))
          .toList(),
      total: json['total']?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idVenta': idVenta,
      'fecha': fecha.toIso8601String(),
      'cliente': cliente.toJson(),
      'detalles': detalles.map((detalle) => detalle.toJson()).toList(),
      'total': total,
    };
  }

  void agregarDetalle(DetalleVenta detalle) {
    detalles.add(detalle);
    calcularTotal();
  }

  void removerDetalle(int index) {
    detalles.removeAt(index);
    calcularTotal();
  }

  void actualizarCantidad(int index, int nuevaCantidad) {
    if (index >= 0 && index < detalles.length) {
      detalles[index].cantidad = nuevaCantidad;
      calcularTotal();
    }
  }
}