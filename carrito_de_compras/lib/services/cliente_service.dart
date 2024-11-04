import '../models/cliente.dart';
import '../services/api_service.dart';
import 'dart:convert';

class ClienteService {
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
    try {
      final data = await ApiService.post(collection, cliente.toJson());
      return Cliente.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create cliente: $e');
    }
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

  // lib/services/cliente_service.dart
// lib/services/cliente_service.dart
  Future<void> delete(int id) async {
    try {
      final items = await ApiService.get(collection);
      final updatedItems = items.where((item) => 
        item['idCliente'] != id
      ).toList();
      
      // Save filtered list
      final file = await ApiService.localFile(collection);
      await file.writeAsString(jsonEncode(updatedItems));
    } catch (e) {
      throw Exception('Failed to delete cliente: $e');
    }
  }

  Future<Cliente?> buscarPorCedula(String cedula) async {
    try {
      final items = await ApiService.get(collection);
      final clienteData = items.firstWhere(
        (item) => item['cedula'] == cedula,
        orElse: () => {},
      );
      
      if (clienteData.isEmpty) {
        return null;
      }

      return Cliente.fromJson(clienteData);
    } catch (e) {
      throw Exception('Failed to find cliente by cedula: $e');
    }
  }
}