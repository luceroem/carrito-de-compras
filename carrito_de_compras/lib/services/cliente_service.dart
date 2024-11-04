import '../models/cliente.dart';
import '../services/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteService {
  static const collection = 'clientes';

  Future<List<Cliente>> getAll() async {
    try {
      final snapshot = await ApiService.get(collection);
      return snapshot.docs.map((doc) => 
        Cliente.fromJson(doc.data() as Map<String, dynamic>)
      ).toList();
    } catch (e) {
      throw Exception('Failed to load clientes: $e');
    }
  }

  Future<Cliente> create(Cliente cliente) async {
    try {
      final docRef = await ApiService.post(collection, cliente.toJson());
      return cliente;
    } catch (e) {
      throw Exception('Failed to create cliente: $e');
    }
  }

  Future<void> update(Cliente cliente) async {
    try {
      await ApiService.put(collection, cliente.idCliente.toString(), cliente.toJson());
    } catch (e) {
      throw Exception('Failed to update cliente: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      await ApiService.delete(collection, id.toString());
    } catch (e) {
      throw Exception('Failed to delete cliente: $e');
    }
  }
  Future<Cliente?> buscarPorCedula(String cedula) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('cedula', isEqualTo: cedula)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return Cliente.fromJson(
        snapshot.docs.first.data() as Map<String, dynamic>
      );
    } catch (e) {
      throw Exception('Failed to find cliente by cedula: $e');
    }
  }
}