
class Categoria {
  final int? idCategoria;
  final String nombre;

  Categoria({required this.idCategoria, required this.nombre});
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      idCategoria: json['idCategoria'],
      nombre: json['nombre'],
    );
  }

  Categoria copyWith({int? idCategoria, String? nombre}) {
    return Categoria(
      idCategoria: idCategoria ?? this.idCategoria,
      nombre: nombre ?? this.nombre,
    );
  }



  Map<String, dynamic> toJson() {

    // Implement the toJson method based on your Categoria fields

    return {
      'idCategoria': idCategoria,
      'nombre': nombre,
    };
  }
}
