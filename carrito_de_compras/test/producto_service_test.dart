// test/producto_service_test.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:carrito_de_compras/models/producto.dart';
import 'package:carrito_de_compras/services/producto_service.dart';

class MockPathProvider extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  final Directory tempDir;
  MockPathProvider(this.tempDir);
  
  @override
  Future<String?> getApplicationDocumentsPath() async => tempDir.path;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProductoService productoService;
  late Directory tempDir;
  late File productosFile;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    productosFile = File('${tempDir.path}/productos.json');
    await productosFile.writeAsString('[]');
    PathProviderPlatform.instance = MockPathProvider(tempDir);
    productoService = ProductoService();
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Producto CRUD', () {
    test('create and delete producto', () async {
      final producto = Producto(
        idProducto: 1,
        nombre: 'Test Producto',
        idCategoria: 1,
        precioVenta: 100.0
      );

      await productoService.create(producto);
      var content = await productosFile.readAsString();
      print('After create: $content');
      expect(jsonDecode(content).length, 1);

      await productoService.delete(producto.idProducto!);
      content = await productosFile.readAsString();
      print('After delete: $content');
      expect(jsonDecode(content), isEmpty);
    });
  });
}