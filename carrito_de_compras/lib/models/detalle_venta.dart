import 'package:carrito_de_compras/models/producto.dart';

class DetalleVenta {
  final int idVenta;
  final int idDetalleVenta;
  final Producto producto;
  final int cantidad;
  final double precio;

  DetalleVenta({
    required this.idVenta,
    required this.idDetalleVenta,
    required this.producto,
    required this.cantidad,
    required this.precio,
  });
}
