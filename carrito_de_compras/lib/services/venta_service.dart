import '../models/venta.dart';
import '../services/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VentaService {
  static const collection = 'ventas';

  Future<List<Venta>> getAll() async {
    try {
      final snapshot = await ApiService.get(collection);
      return snapshot.docs.map((doc) => 
        Venta.fromJson(doc.data() as Map<String, dynamic>)
      ).toList();
    } catch (e) {
      throw Exception('Failed to load ventas: $e');
    }
  }

  Future<Venta> create(Venta venta) async {
    try {
      final docRef = await ApiService.post(collection, venta.toJson());
      return venta;
    } catch (e) {
      throw Exception('Failed to create venta: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      await ApiService.delete(collection, id.toString());
    } catch (e) {
      throw Exception('Failed to delete venta: $e');
    }
  }
}