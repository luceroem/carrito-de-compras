// lib/models/cliente.dart

class Cliente {
  final int? idCliente; // Nullable for new clients
  final String cedula;
  final String nombre;
  final String apellido;
  final String direccion; // Add this line
  final String telefono;

  Cliente({
    this.idCliente,
    required this.cedula,
    required this.nombre,
    required this.apellido,
    required this.direccion, // Add this line
    required this.telefono,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idCliente: json['idCliente'],
      cedula: json['cedula'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      direccion: json['direccion'], // Add this line
      telefono: json['telefono'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCliente': idCliente,
      'cedula': cedula,
      'nombre': nombre,
      'apellido': apellido,
      'direccion': direccion, // Add this line
      'telefono': telefono,
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
      direccion: direccion, // Add this line
      telefono: telefono,
    );
  }
}