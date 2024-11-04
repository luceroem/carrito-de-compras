class Producto {
  final int? idProducto;
  final String nombre;
  final double precioVenta;
  final int idCategoria;

  Producto({
    this.idProducto,
    required this.nombre,
    required this.precioVenta,
    required this.idCategoria,
  });

  Producto copyWith({
    int? idProducto,
    String? nombre,
    double? precioVenta,
    int? idCategoria,
  }) {
    return Producto(
      idProducto: idProducto ?? this.idProducto,
      nombre: nombre ?? this.nombre,
      precioVenta: precioVenta ?? this.precioVenta,
      idCategoria: idCategoria ?? this.idCategoria,
    );
  }

  Map<String, dynamic> toJson() => {
        'idProducto': idProducto,
        'nombre': nombre,
        'precioVenta': precioVenta,
        'idCategoria': idCategoria,
      };

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        idProducto: json['idProducto'] as int?,
        nombre: json['nombre'] as String,
        precioVenta: (json['precioVenta'] as num).toDouble(),
        idCategoria: json['idCategoria'] as int,
      );
}