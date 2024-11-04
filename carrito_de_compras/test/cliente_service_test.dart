// test/cliente_service_test.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:carrito_de_compras/models/cliente.dart';
import 'package:carrito_de_compras/services/cliente_service.dart';

class MockPathProviderPlatform extends Fake 
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final Directory tempDir;
  MockPathProviderPlatform(this.tempDir);

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return tempDir.path;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ClienteService clienteService;
  late Directory tempDir;
  late File clientesFile;

  setUp(() async {
    // Create temp directory and initialize file
    tempDir = await Directory.systemTemp.createTemp();
    clientesFile = File('${tempDir.path}/clientes.json');
    
    // Ensure empty JSON array exists
    await clientesFile.writeAsString('[]');
    
    // Setup mock path provider
    PathProviderPlatform.instance = MockPathProviderPlatform(tempDir);
    clienteService = ClienteService();
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Cliente CRUD operations', () {
    test('Delete cliente should remove it completely', () async {
      // Arrange
      final cliente = Cliente(
        idCliente: 1,
        cedula: '1234567890',
        nombre: 'Test Cliente',
        apellido: 'Test Apellido',
        direccion: 'Test Direccion',
        telefono: '0987654321'
      );

      // Act - Create
      await clienteService.create(cliente);
      var content = await clientesFile.readAsString();
      print('After create: $content');
      
      // Verify creation
      var clientes = jsonDecode(content) as List;
      expect(clientes.length, 1);
      
      // Act - Delete  
      await clienteService.delete(cliente.idCliente!);
      content = await clientesFile.readAsString();
      print('After delete: $content');
      
      // Assert - File content
      clientes = jsonDecode(content) as List;
      expect(clientes.isEmpty, true, reason: 'Cliente list should be empty after deletion');
      
      // Assert - Service query
      final eliminado = await clienteService.buscarPorCedula('1234567890');
      expect(eliminado, isNull, reason: 'Cliente should not be found after deletion');
    });
  });
}