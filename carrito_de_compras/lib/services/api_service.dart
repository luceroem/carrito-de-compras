import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ApiService {
  static Future<String> get _localPath async {
    if (kIsWeb) return '';
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<void> _saveToStorage(String collection, String data) async {
    if (kIsWeb) {
      html.window.localStorage[collection] = data;
    } else {
      final file = await localFile(collection);
      await file.writeAsString(data);
    }
  }

  static Future<String?> _loadFromStorage(String collection) async {
    if (kIsWeb) {
      return html.window.localStorage[collection];
    } else {
      try {
        final file = await localFile(collection);
        if (await file.exists()) {
          return await file.readAsString();
        }
      } catch (e) {
        print('Load error: $e');
      }
      return null;
    }
  }

  static Future<File> localFile(String collection) async {
    final path = await _localPath;
    return File('$path/$collection.json');
  }

  static Future<List<Map<String, dynamic>>> get(String collection) async {
    try {
      final contents = await _loadFromStorage(collection);
      if (contents == null || contents.isEmpty) return [];
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
      await _saveToStorage(collection, jsonEncode(items));
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
        await _saveToStorage(collection, jsonEncode(items));
      }
    } catch (e) {
      print('PUT Error: $e');
      rethrow;
    }
  }

  static Future<void> delete(String collection, String id) async {
    try {
      final items = await get(collection);
      final updatedItems = items.where((item) => 
        item['idCliente'].toString() != id
      ).toList();
      
      await _saveToStorage(collection, jsonEncode(updatedItems));
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