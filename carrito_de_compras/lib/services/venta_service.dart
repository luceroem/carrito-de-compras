import 'data_service.dart';
import '../models/venta.dart';
import 'dart:math' show max;

class VentaService {
  final DataService _dataService = DataService();

  Future<List<Venta>> getAll() async {
    return _dataService.cargarVentas();
  }

  Future<Venta> create(Venta venta) async {
    try {
      final ventas = await _dataService.cargarVentas();
      final nuevoId = ventas.isEmpty ? 1 : ventas.map((v) => v.idVenta ?? 0).reduce(max) + 1;
      
      final nuevaVenta = Venta(
        idVenta: nuevoId,
        fecha: venta.fecha,
        idCliente: venta.idCliente,
        detalles: venta.detalles,
        total: venta.total,
        clienteNombre: venta.clienteNombre,
      );
      
      ventas.add(nuevaVenta);
      await _dataService.guardarVentas(ventas);
      return nuevaVenta;
    } catch (e) {
      print('Error creating venta: $e');
      rethrow;
    }
  }

  int _generarNuevoId(List<Venta> ventas) {
    if (ventas.isEmpty) return 1;
    return ventas.map((v) => v.idVenta ?? 0).reduce(max) + 1;
  }

  Future<void> update(Venta ventaActualizada) async {
    final ventas = await _dataService.cargarVentas();
    final index = ventas.indexWhere((v) => v?.idVenta == ventaActualizada.idVenta!);
    if (index != -1) {
      ventas[index] = ventaActualizada;
      await _dataService.guardarVentas(ventas);
    } else {
      throw Exception('Venta no encontrada');
    }
  }

  Future<void> delete(int id) async {
    final ventas = await _dataService.cargarVentas();
    ventas.removeWhere((v) => v.idVenta != null && v.idVenta == id);
    await _dataService.guardarVentas(ventas);
  }
}

extension on Object? {
  get idVenta => null;
}
