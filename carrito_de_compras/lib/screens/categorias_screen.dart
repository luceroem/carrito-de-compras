import 'package:flutter/material.dart';

class Categoria {
  final int idCategoria;
  String nombre;

  Categoria({required this.idCategoria, required this.nombre});
}

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  CategoriasScreenState createState() => CategoriasScreenState();
}

class CategoriasScreenState extends State<CategoriasScreen> {
  final List<Categoria> categorias = [];
  final List<Categoria> categoriasFiltradas = [];
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _buscarController = TextEditingController();

  void _agregarCategoria() {
    if (_nombreController.text.isNotEmpty) {
      setState(() {
        categorias.add(Categoria(
          idCategoria: categorias.length + 1,
          nombre: _nombreController.text,
        ));
        _nombreController.clear();
      });
    }
  }
  
  void _filtrarCategorias(String query) {
    setState(() {
      categoriasFiltradas.clear();
      categoriasFiltradas.addAll(
        categorias.where((categoria) => 
          categoria.nombre.toLowerCase().contains(query.toLowerCase())
        )
      );
    });
  }

  void _editarCategoria(Categoria categoria) {
    _nombreController.text = categoria.nombre;
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
              setState(() {
                categoria.nombre = _nombreController.text;
                _nombreController.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _eliminarCategoria(int index) {
    setState(() {
      categorias.removeAt(index);
    });
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