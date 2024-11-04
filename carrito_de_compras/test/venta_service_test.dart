// test/venta_service_test.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:carrito_de_compras/models/venta.dart';
import 'package:carrito_de_compras/models/cliente.dart';
import 'package:carrito_de_compras/models/detalle_venta.dart';
import 'package:carrito_de_compras/services/venta_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProvider extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  final Directory tempDir;
  MockPathProvider(this.tempDir);
  
  @override
  Future<String?> getApplicationDocumentsPath() async => tempDir.path;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late VentaService ventaService;
  late Directory tempDir;
  late File ventasFile;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    ventasFile = File('${tempDir.path}/ventas.json');
    await ventasFile.writeAsString('[]');
    PathProviderPlatform.instance = MockPathProvider(tempDir);
    ventaService = VentaService();
  });

  tearDown(() async {
    if (tempDir.existsSync()) await tempDir.delete(recursive: true);
  });

  group('Venta CRUD', () {
    test('create and delete venta', () async {
      final cliente = Cliente(
        idCliente: 1,
        cedula: '123',
        nombre: 'Test',
        apellido: 'Cliente',
        direccion: 'Dir',
        telefono: '456'
      );

      final venta = Venta(
        idVenta: 1,
        fecha: DateTime.now(),
        cliente: cliente,
        detalles: []
      );

      await ventaService.create(venta);
      var content = await ventasFile.readAsString();
      expect(jsonDecode(content).length, 1);

      await ventaService.delete(venta.idVenta!);
      content = await ventasFile.readAsString();
      expect(jsonDecode(content), isEmpty);
    });
  });
}