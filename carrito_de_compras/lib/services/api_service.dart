// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ApiService {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> localFile(String collection) async {

    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/$collection.json');

  }

  static Future<List<Map<String, dynamic>>> get(String collection) async {
    try {
      final file = await localFile(collection);
      final contents = await file.readAsString();
      return List<Map<String, dynamic>>.from(jsonDecode(contents));
    } catch (e) {
      print('GET Error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> post(String collection, Map<String, dynamic> data) async {
    try {
      final items = await get(collection);
      items.add(data);
      final file = await localFile(collection);
      await file.writeAsString(jsonEncode(items));
      return data;
    } catch (e) {
      print('POST Error: $e');
      rethrow;
    }
  }

  static Future<void> put(String collection, String id, Map<String, dynamic> data) async {
    try {
      final items = await get(collection);
      final index = items.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        items[index] = data;
        final file = await localFile(collection);
        await file.writeAsString(jsonEncode(items));
      }
    } catch (e) {
      print('PUT Error: $e');
      rethrow;
    }
  }

  // lib/services/api_service.dart
  static Future<void> delete(String collection, String id) async {
    try {
      final items = await get(collection);
      final updatedItems = items.where((item) => 
        item['idCliente'].toString() != id
      ).toList();
      
      final file = await localFile(collection);
      await file.writeAsString(jsonEncode(updatedItems));
    } catch (e) {
      print('DELETE Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getById(String collection, String id) async {
    try {
      final items = await get(collection);
      return items.firstWhere((item) => item['id'] == id);
    } catch (e) {
      print('GET By ID Error: $e');
      return null;
    }
  }

  static Stream<List<Map<String, dynamic>>> getStream(String collection) async* {
    while (true) {
      yield await get(collection);
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}