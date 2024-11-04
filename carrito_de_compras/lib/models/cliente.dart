// lib/models/cliente.dart

class Cliente {
  final int? idCliente; // Nullable for new clients
  final String cedula;
  final String nombre;
  final String apellido;

  Cliente({
    this.idCliente,
    required this.cedula,
    required this.nombre,
    required this.apellido,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idCliente: json['idCliente'],
      cedula: json['cedula'],
      nombre: json['nombre'],
      apellido: json['apellido'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCliente': idCliente,
      'cedula': cedula,
      'nombre': nombre,
      'apellido': apellido,
    };
  }

  String get nombreCompleto => '$nombre $apellido';

  bool cedulaValida() {
    // Implementar validación de cédula según el formato requerido
    return cedula.length >= 7 && cedula.length <= 10;
  }

  @override
  String toString() {
    return 'Cliente{idCliente: $idCliente, cedula: $cedula, nombre: $nombre, apellido: $apellido}';
  }

  // Copy with method for updating client data
  Cliente copyWith({
    int? idCliente,
    String? cedula,
    String? nombre,
    String? apellido,
  }) {
    return Cliente(
      idCliente: idCliente ?? this.idCliente,
      cedula: cedula ?? this.cedula,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
    );
  }
}