import '../models/categoria.dart';
import 'data_service.dart'; // Importa DataService

class CategoriaService {
  final DataService _dataService = DataService(); // Instancia de DataService

  Future<List<Categoria>> getAll() async {
    return _dataService.cargarCategorias();
  }

  Future<Categoria> create(Categoria categoria) async {
    final categorias = await _dataService.cargarCategorias();
    final nuevaCategoria = categoria.copyWith(idCategoria: categorias.length + 1);
    categorias.add(nuevaCategoria);
    await _dataService.guardarCategorias(categorias);
    return nuevaCategoria;
  }

  Future<void> update(Categoria categoriaActualizada) async {
    final categorias = await _dataService.cargarCategorias();
    final index = categorias.indexWhere((c) => c?.idCategoria == categoriaActualizada.idCategoria!);
    if (index != -1) {
      categorias[index] = categoriaActualizada;
      await _dataService.guardarCategorias(categorias);
    } else {
      throw Exception('Categoría no encontrada');
    }
  }

  Future<void> delete(int id) async {
    final categorias = await _dataService.cargarCategorias();
    categorias.removeWhere((c) => c.idCategoria != null && c.idCategoria == id);
    await _dataService.guardarCategorias(categorias);
  }
}

extension on Object? {
  get idCategoria => null;
}