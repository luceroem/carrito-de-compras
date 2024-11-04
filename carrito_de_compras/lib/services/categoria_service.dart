import '../models/categoria.dart';
import '../services/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriaService {
  static const collection = 'categorias';

  Future<List<Categoria>> getAll() async {
    try {
      final snapshot = await ApiService.get(collection);
      return snapshot.docs.map((doc) => 
        Categoria.fromJson(doc.data() as Map<String, dynamic>)
      ).toList();
    } catch (e) {
      throw Exception('Failed to load categorias: $e');
    }
  }

  Future<Categoria> create(Categoria categoria) async {
    try {
      final docRef = await ApiService.post(collection, categoria.toJson());
      return categoria;
    } catch (e) {
      throw Exception('Failed to create categoria: $e');
    }
  }

  Future<void> update(Categoria categoria) async {
    try {
      await ApiService.put(collection, categoria.idCategoria.toString(), categoria.toJson());
    } catch (e) {
      throw Exception('Failed to update categoria: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      await ApiService.delete(collection, id.toString());
    } catch (e) {
      throw Exception('Failed to delete categoria: $e');
    }
  }
}