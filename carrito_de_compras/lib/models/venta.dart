// lib/models/venta.dart

import 'detalle_venta.dart';

class Venta {
  final int? idVenta; // Nullable for new sales
  final DateTime fecha;
  final int idCliente;
  final List<DetalleVenta> detalles;
  double total;
  final String clienteNombre;

  Venta({
    this.idVenta,
    required this.fecha,
    required this.idCliente,
    required this.detalles,
    required this.total,
    required this.clienteNombre,
  });

  Venta copyWith({
      int? idVenta,
      DateTime? fecha,
      String? clienteNombre,
      List<DetalleVenta>? detalles,
      double? total,
    }) {
      return Venta(
        idVenta: idVenta ?? this.idVenta,
        fecha: fecha ?? this.fecha,
        idCliente: idCliente,
        clienteNombre: clienteNombre ?? this.clienteNombre,
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
      idCliente: json['idCliente'],
      detalles: (json['detalles'] as List)
          .map((item) => DetalleVenta.fromJson(item))
          .toList(),
      total: json['total'],
      clienteNombre: json['clienteNombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idVenta': idVenta,
      'fecha': fecha.toIso8601String(),
      'idCliente': idCliente,
      'detalles': detalles.map((detalle) => detalle.toJson()).toList(),
      'total': total,
      'clienteNombre': clienteNombre,
    };
  }
}
