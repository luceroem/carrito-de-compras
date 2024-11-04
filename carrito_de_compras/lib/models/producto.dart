class Producto {
  final int idProducto;
  final String nombre;
  final int idCategoria;
  final double precioVenta;

  Producto({
    required this.idProducto,
    required this.nombre,
    required this.idCategoria,
    required this.precioVenta,
  });

  // Método para mapear desde JSON
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['idProducto'],
      nombre: json['nombre'],
      idCategoria: json['idCategoria'],
      precioVenta: double.tryParse(json['precioVenta'].toString()) ?? 0.0,
    );
  }

  // Método para mapear a JSON
  Map<String, dynamic> toJson() {
    return {
      'idProducto': idProducto,
      'nombre': nombre,
      'idCategoria': idCategoria,
      'precioVenta': precioVenta,
    };
  }
}
