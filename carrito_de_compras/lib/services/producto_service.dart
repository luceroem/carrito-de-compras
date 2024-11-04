import '../models/producto.dart';
import 'data_service.dart';

class ProductoService {
  final DataService _dataService = DataService();

  Future<List<Producto>> getAll() async {
    return _dataService.cargarProductos();
  }

  Future<Producto> create(Producto producto) async {
    final productos = await _dataService.cargarProductos();
    final nuevoProducto = producto.copyWith(idProducto: productos.length + 1);
    productos.add(nuevoProducto);
    await _dataService.guardarProductos(productos);
    return nuevoProducto;
  }

  Future<void> update(Producto productoActualizado) async {
    final productos = await _dataService.cargarProductos();
    final index = productos.indexWhere((p) => p?.idProducto == productoActualizado.idProducto!);
    if (index != -1) {
      productos[index] = productoActualizado;
      await _dataService.guardarProductos(productos);
    } else {
      throw Exception('Producto no encontrado');
    }
  }

  Future<void> delete(int id) async {
    final productos = await _dataService.cargarProductos();
    productos.removeWhere((p) => p.idProducto != null && p.idProducto == id);
    await _dataService.guardarProductos(productos);
  }
}

extension on Object? {
  get idProducto => null;
}