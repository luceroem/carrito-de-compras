import 'package:flutter/material.dart';
import '../services/categoria_service.dart';
import '../models/categoria.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  CategoriasScreenState createState() => CategoriasScreenState();
}

class CategoriasScreenState extends State<CategoriasScreen> {
  String? _errorMensaje;
  bool _isLoading = false;
  List<Categoria> categorias = [];
  List<Categoria> categoriasFiltradas = [];
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _buscarController = TextEditingController();
  final CategoriaService _categoriaService = CategoriaService();

  void _agregarCategoria() {
  if (_nombreController.text.isNotEmpty) {
    final nuevaCategoria = Categoria(
      idCategoria: categorias.length + 1,
      nombre: _nombreController.text,
    );

    setState(() => _isLoading = true); // Inicia la carga

    _categoriaService.create(nuevaCategoria).then((_) {
      _cargarCategorias(); // Recarga la lista después de agregar
      _nombreController.clear();
      _mostrarMensaje('Categoría agregada');
    }).catchError((e) {
      _mostrarError('Error al agregar categoría: $e');
    }).whenComplete(() => setState(() => _isLoading = false)); // Finaliza la carga
  }
}

void _filtrarCategorias(String query) {
  setState(() {
    categoriasFiltradas = categorias
        .where((categoria) =>
            categoria.nombre.toLowerCase().contains(query.toLowerCase()))
        .toList();
  });
}

void _editarCategoria(Categoria categoriaOriginal) {
  _nombreController.text = categoriaOriginal.nombre;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Editar Categoría'),
      content: TextField(
        controller: _nombreController,
        decoration: const InputDecoration(labelText: 'Nombre'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() => _isLoading = true); // Muestra la carga
            final categoriaEditada = categoriaOriginal.copyWith(nombre: _nombreController.text);

             _categoriaService.update(categoriaEditada).then((_) {
                _cargarCategorias();
                Navigator.pop(context);
                _mostrarMensaje('Categoría actualizada');


            }).catchError((error) {
                _mostrarError('Error al actualizar: $error');



            }).whenComplete(() => setState(() => _isLoading = false));

          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}

void _eliminarCategoria(int idCategoria) {
  setState(() => _isLoading = true);
  _categoriaService.delete(idCategoria).then((_) {
    _cargarCategorias();
    _mostrarMensaje('Categoría eliminada');
  }).catchError((error) {
        _mostrarError('Error al eliminar: $error');

  }).whenComplete(() => setState(() => _isLoading = false));
}

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    try {
      final categoriasCargadas = await _categoriaService.getAll(); // Usa el servicio
      setState(() {
        categorias = categoriasCargadas;
        categoriasFiltradas = List.from(categorias);
        _isLoading = false;
        _errorMensaje = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMensaje = 'Error al cargar categorías: $e';
      });
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Categorías'),
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _buscarController,
              decoration: const InputDecoration(
                labelText: 'Buscar categoría',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filtrarCategorias,
            ),
          ),
          // Campo para agregar nueva categoría
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nueva Categoría',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _agregarCategoria,
                ),
              ),
            ),
          ),
          // Lista de categorías
          Expanded(
            child: ListView.builder(
              itemCount: categoriasFiltradas.isEmpty 
                ? categorias.length 
                : categoriasFiltradas.length,
              itemBuilder: (context, index) {
                final categoria = categoriasFiltradas.isEmpty 
                  ? categorias[index] 
                  : categoriasFiltradas[index];
                return ListTile(
                  title: Text(categoria.nombre),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editarCategoria(categoria),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _eliminarCategoria(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}	