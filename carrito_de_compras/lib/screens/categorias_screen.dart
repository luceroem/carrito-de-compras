import 'package:flutter/material.dart';

class Categoria {
  final int idCategoria;
  final String nombre;

  Categoria({required this.idCategoria, required this.nombre});
}

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  CategoriasScreenState createState() => CategoriasScreenState();
}

class CategoriasScreenState extends State<CategoriasScreen> {
  final List<Categoria> categorias = [];
  final TextEditingController _nombreController = TextEditingController();

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre de la Categoría',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _agregarCategoria,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categorias[index].nombre),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _eliminarCategoria(index),
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
