import 'dart:convert';

class Categoria {
  final int idCategoria;
  final String nombre;

  Categoria({required this.idCategoria, required this.nombre});
  factory Categoria.fromJson(Map<String, dynamic> json) {

    // Implement the fromJson method based on your Categoria fields

    return Categoria(
      idCategoria: json['idCategoria'],
      nombre: json['nombre'],
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
