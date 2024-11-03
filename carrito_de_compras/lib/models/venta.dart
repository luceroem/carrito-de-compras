import 'package:carrito_de_compras/models/cliente.dart';

class Venta {
  final int idVenta;
  final DateTime fecha;
  final Cliente cliente; // Puedes guardar el cliente como un objeto completo
  final double total;

  Venta({
    required this.idVenta,
    required this.fecha,
    required this.cliente,
    required this.total,
  });
}
