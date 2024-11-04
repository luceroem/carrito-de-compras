import '../models/producto.dart';
import '../services/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductoService {
  static const collection = 'productos';

  Future<List<Producto>> getAll() async {
    try {
      final snapshot = await ApiService.get(collection);
      return snapshot.docs.map((doc) => 
        Producto.fromJson(doc.data() as Map<String, dynamic>)
      ).toList();
    } catch (e) {
      throw Exception('Failed to load productos: $e');
    }
  }

  Future<Producto> create(Producto producto) async {
    try {
      final docRef = await ApiService.post(collection, producto.toJson());
      return producto;
    } catch (e) {
      throw Exception('Failed to create producto: $e');
    }
  }

  Future<void> update(Producto producto) async {
    try {
      await ApiService.put(collection, producto.idProducto.toString(), producto.toJson());
    } catch (e) {
      throw Exception('Failed to update producto: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      await ApiService.delete(collection, id.toString());
    } catch (e) {
      throw Exception('Failed to delete producto: $e');
    }
  }
}