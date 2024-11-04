// lib/services/data_service.dart
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:carrito_de_compras/models/categoria.dart';
import 'package:carrito_de_compras/models/producto.dart';
import 'package:carrito_de_compras/models/venta.dart';
import 'package:carrito_de_compras/models/cliente.dart';

class DataService {
  // Debug flag
  static const bool _debug = true;

  void _log(String message) {
    if (_debug) print('DataService: $message');
  }

  Future<String> get _localPath async {
    if (kIsWeb) return '';
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename.json');
  }

  // Generic save method
  Future<void> _saveData<T>(String key, List<T> items, Map<String, dynamic> Function(T) toJson) async {
    try {
      final data = jsonEncode(items.map((item) => toJson(item)).toList());
      _log('Saving $key: $data');
      
      if (kIsWeb) {
        html.window.localStorage[key] = data;
        _log('Saved to localStorage: ${html.window.localStorage[key]}');
      } else {
        final file = await _localFile(key);
        await file.writeAsString(data);
        _log('Saved to file: ${file.path}');
      }
    } catch (e) {
      _log('Error saving $key: $e');
      rethrow;
    }
  }

  // Generic load method
  Future<List<T>> _loadData<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    try {
      String? data;
      
      if (kIsWeb) {
        data = html.window.localStorage[key];
        _log('Loading from localStorage: $data');
      } else {
        try {
          final file = await _localFile(key);
          if (await file.exists()) {
            data = await file.readAsString();
            _log('Loading from file: $data');
          }
        } catch (e) {
          _log('File read error: $e');
        }
      }

      if (data == null || data.isEmpty) {
        _log('No data found for $key');
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      _log('Error loading $key: $e');
      return [];
    }
  }

  // Categorias
  Future<void> guardarCategorias(List<Categoria> categorias) async {
    await _saveData('categorias', categorias, (c) => c.toJson());
  }

  Future<List<Categoria>> cargarCategorias() async {
    return _loadData('categorias', Categoria.fromJson);
  }

  // Productos
  Future<void> guardarProductos(List<Producto> productos) async {
    await _saveData('productos', productos, (p) => p.toJson());
  }

  Future<List<Producto>> cargarProductos() async {
    return _loadData('productos', Producto.fromJson);
  }

  // Ventas
  Future<void> guardarVentas(List<Venta> ventas) async {
    await _saveData('ventas', ventas, (v) => v.toJson());
  }

  Future<List<Venta>> cargarVentas() async {
    return _loadData('ventas', Venta.fromJson);
  }

  Future<void> guardarClientes(List<Cliente> clientes) async {
    await _saveData('clientes', clientes, (c) => c.toJson());
  }

  Future<List<Cliente>> cargarClientes() async {
    return _loadData('clientes', Cliente.fromJson);
  }
}