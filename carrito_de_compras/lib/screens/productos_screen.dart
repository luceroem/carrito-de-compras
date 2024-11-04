import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';
import '../models/categoria.dart';
import '../services/categoria_service.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  ProductosScreenState createState() => ProductosScreenState();
}

class ProductosScreenState extends State<ProductosScreen> {
  final List<Producto> productos = [];
  final List<Producto> productosFiltrados = [];
  final List<Categoria> categorias = [];
  Categoria? categoriaSeleccionada;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _buscarController = TextEditingController();
  final ProductoService _productoService = ProductoService();
  final CategoriaService _categoriaService = CategoriaService();
  bool _isLoading = false;
  Categoria? categoriaFiltro; // Agregar esta línea

  @override
  void initState() {
    super.initState();
    _cargarProductos();
    _cargarCategorias();
  }

  Future<void> _cargarProductos() async {
    setState(() => _isLoading = true);
    try {
      final productosCargados = await _productoService.getAll();
      setState(() {
        productos.clear();
        productos.addAll(productosCargados);
        _filtrarProductos(_buscarController.text); // Esto aplicará los filtros actuales
      });
    } catch (e) {
      _mostrarError('Error al cargar productos: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _cargarCategorias() async {
    try {
      final categoriasCargadas = await _categoriaService.getAll();
      setState(() {
        categorias.addAll(categoriasCargadas);
      });
    } catch (e) {
      _mostrarError('Error al cargar categorías: $e');
    }
  }

  void _agregarProducto() {
    if (_nombreController.text.isNotEmpty && _precioController.text.isNotEmpty && categoriaSeleccionada != null) {
      setState(() => _isLoading = true);
      final nuevoProducto = Producto(
        idProducto: null,
        nombre: _nombreController.text,
        precioVenta: double.tryParse(_precioController.text) ?? 0.0,
        idCategoria: categoriaSeleccionada?.idCategoria ?? 0,
      );

      _productoService.create(nuevoProducto).then((_) {
        _cargarProductos();
        _nombreController.clear();
        _precioController.clear();
        categoriaSeleccionada = null;
        _mostrarMensaje('Producto agregado');
      }).catchError((e) {
        _mostrarError('Error al agregar producto: $e');
      }).whenComplete(() => setState(() => _isLoading = false));
    }
  }
  
  void _filtrarProductos(String query) {
    setState(() {
      query = query.toLowerCase(); // Convertir la búsqueda a minúsculas
      // Primero filtramos por categoría si hay una seleccionada
      var productosFiltradosTemp = categoriaFiltro != null
          ? productos.where((producto) => 
              producto.idCategoria == categoriaFiltro!.idCategoria).toList()
          : List<Producto>.from(productos);

      // Luego aplicamos el filtro de búsqueda por nombre (en minúsculas)
      if (query.isNotEmpty) {
        productosFiltradosTemp = productosFiltradosTemp
            .where((producto) =>
                producto.nombre.toLowerCase().contains(query))
            .toList();
      }

      // Actualizamos la lista filtrada
      productosFiltrados.clear();
      productosFiltrados.addAll(productosFiltradosTemp);
    });
  }

  void _editarProducto(Producto producto) {
    _nombreController.text = producto.nombre;
    _precioController.text = producto.precioVenta.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _precioController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final productoActualizado = producto.copyWith(
                nombre: _nombreController.text,
                precioVenta: double.tryParse(_precioController.text) ?? producto.precioVenta,
              );
              setState(() => _isLoading = true);
              _productoService.update(productoActualizado).then((_) {
                _cargarProductos();
                Navigator.pop(context);
                _mostrarMensaje('Producto actualizado');
              }).catchError((e) {
                _mostrarError('Error al actualizar producto: $e');
              }).whenComplete(() => setState(() => _isLoading = false));
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _eliminarProducto(int idProducto) {
    setState(() => _isLoading = true);
    _productoService.delete(idProducto).then((_) {
      _cargarProductos();
      _mostrarMensaje('Producto eliminado');
    }).catchError((e) {
      _mostrarError('Error al eliminar producto: $e');
    }).whenComplete(() => setState(() => _isLoading = false));
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  String getNombreCategoria(int idCategoria) {
    final categoria = categorias.firstWhere(
      (c) => c.idCategoria == idCategoria,
      orElse: () => Categoria(idCategoria: idCategoria, nombre: 'Categoría no encontrada'),
    );
    return categoria.nombre;
  }

  void _limpiarFiltros() {
    setState(() {
      _buscarController.clear();
      categoriaFiltro = null;
      productosFiltrados.clear();
      productosFiltrados.addAll(productos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_off),
            onPressed: _limpiarFiltros,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _buscarController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar producto',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filtrarProductos,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: DropdownButton<Categoria?>(
                    hint: const Text('Todas las categorías'),
                    value: categoriaFiltro,
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<Categoria?>(
                        value: null,
                        child: Text('Todas'),
                      ),
                      ...categorias.map<DropdownMenuItem<Categoria>>((categoria) {
                        return DropdownMenuItem<Categoria>(
                          value: categoria,
                          child: Text(categoria.nombre),
                        );
                      }).toList(),
                    ],
                    onChanged: (Categoria? newValue) {
                      setState(() {
                        categoriaFiltro = newValue;
                        _filtrarProductos(_buscarController.text);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre del Producto'),
                ),
                TextField(
                  controller: _precioController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButton<Categoria>(
                    hint: const Text('Selecciona una categoría'),
                    value: categoriaSeleccionada,
                    isExpanded: true,
                    onChanged: (Categoria? newValue) {
                    setState(() {
                        categoriaSeleccionada = newValue;
                    });
                    },
                    items: categorias.map<DropdownMenuItem<Categoria>>((Categoria categoria) {
                    return DropdownMenuItem<Categoria>(
                        value: categoria,
                        child: Text(categoria.nombre),
                    );
                    }).toList(),
                ),
                ElevatedButton(
                  onPressed: _agregarProducto,
                  child: const Text('Agregar Producto'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: productosFiltrados.length, // Siempre usar productosFiltrados
                  itemBuilder: (context, index) {
                    final producto = productosFiltrados[index];
                    return ListTile(
                      title: Text(producto.nombre),
                      subtitle: Text(
                        'Precio: \$${producto.precioVenta.toStringAsFixed(2)}  '
                        'Categoría: ${getNombreCategoria(producto.idCategoria)}'
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editarProducto(producto),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _eliminarProducto(producto.idProducto!),
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