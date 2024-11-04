import 'data_service.dart';
import '../models/venta.dart';

class VentaService {
  final DataService _dataService = DataService();

  Future<List<Venta>> getAll() async {
    return _dataService.cargarVentas();
  }

  Future<Venta> create(Venta venta) async {
    final ventas = await _dataService.cargarVentas();
    final nuevaVenta = venta.copyWith(idVenta: ventas.length + 1);
    ventas.add(nuevaVenta);
    await _dataService.guardarVentas(ventas);
    return nuevaVenta;
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