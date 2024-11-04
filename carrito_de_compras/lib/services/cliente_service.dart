import '../models/cliente.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'dart:math' show max;

import '../services/data_service.dart';

class ClienteService {
  final DataService _dataService = DataService();
  static const collection = 'clientes';

  Future<List<Cliente>> getAll() async {
    try {
      final items = await ApiService.get(collection);
      return items.map((item) => Cliente.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load clientes: $e');
    }
  }

  Future<Cliente> create(Cliente cliente) async {
    final clientes = await _dataService.cargarClientes();
    // Generate new ID
    final nuevoId = clientes.isEmpty ? 1 : clientes.map((c) => c.idCliente ?? 0).reduce(max) + 1;
    
    // Create new client with generated ID
    final nuevoCliente = Cliente(
      idCliente: nuevoId,
      cedula: cliente.cedula,
      nombre: cliente.nombre,
      apellido: cliente.apellido,
      direccion: cliente.direccion,
      telefono: cliente.telefono,
    );
    
    clientes.add(nuevoCliente);
    await _dataService.guardarClientes(clientes);
    return nuevoCliente;
  }

  Future<void> update(Cliente cliente) async {
    try {
      await ApiService.put(
        collection,
        cliente.idCliente.toString(),
        cliente.toJson()
      );
    } catch (e) {
      throw Exception('Failed to update cliente: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      await ApiService.delete(collection, id.toString()); // Suponiendo que tu API admite DELETE.
    } catch (e) {
      throw Exception('Failed to delete cliente: $e');
    }
  }

  Future<Cliente?> getClienteByCedula(String cedula) async {
    try {
      final items = await ApiService.get(collection);
      for (var item in items) {
        if (item['cedula'] == cedula) {
          return Cliente.fromJson(item);
        }
      }
      return null; // Retornar null si no se encuentra
    } catch (e) {
      throw Exception('Failed to find cliente by cedula: $e');
    }
  }

  Future<Cliente?> getClienteById(int idCliente) async {
    try {
      final items = await ApiService.get(collection);
      for (var item in items) {
        if (item['idCliente'] == idCliente) {
          return Cliente.fromJson(item);
        }
      }
      return null; // Retornar null si no se encuentra
    } catch (e) {
      throw Exception('Failed to find cliente by ID: $e');
    }
  }
}
