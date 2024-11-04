// lib/services/api_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class ApiService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<QuerySnapshot> get(String collection) async {
    try {
      return await _db.collection(collection).get();
    } catch (e) {
      print('GET Error: $e');
      rethrow;
    }
  }

  static Future<DocumentReference> post(String collection, Map<String, dynamic> data) async {
    try {
      return await _db.collection(collection).add(data);
    } catch (e) {
      print('POST Error: $e');
      rethrow;
    }
  }

  static Future<void> put(String collection, String id, Map<String, dynamic> data) async {
    try {
      await _db.collection(collection).doc(id).update(data);
    } catch (e) {
      print('PUT Error: $e');
      rethrow;
    }
  }

  static Future<void> delete(String collection, String id) async {
    try {
      await _db.collection(collection).doc(id).delete();
    } catch (e) {
      print('DELETE Error: $e');
      rethrow;
    }
  }

  static Future<DocumentSnapshot> getById(String collection, String id) async {
    try {
      return await _db.collection(collection).doc(id).get();
    } catch (e) {
      print('GET By ID Error: $e');
      rethrow;
    }
  }

  static Stream<QuerySnapshot> getStream(String collection) {
    return _db.collection(collection).snapshots();
  }
}