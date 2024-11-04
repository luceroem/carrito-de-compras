// test/categoria_service_test.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../lib/models/categoria.dart';
import '../lib/services/categoria_service.dart';

class MockPathProvider extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  final Directory tempDir;
  MockPathProvider(this.tempDir);
  
  @override
  Future<String?> getApplicationDocumentsPath() async => tempDir.path;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CategoriaService categoriaService;
  late Directory tempDir;
  late File categoriasFile;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    categoriasFile = File('${tempDir.path}/categorias.json');
    await categoriasFile.writeAsString('[]');
    PathProviderPlatform.instance = MockPathProvider(tempDir);
    categoriaService = CategoriaService();
  });

  tearDown(() async {
    if (tempDir.existsSync()) await tempDir.delete(recursive: true);
  });

  group('Categoria CRUD', () {
    test('create and delete categoria', () async {
      final categoria = Categoria(
        idCategoria: 1,
        nombre: 'Test Categoria'
      );

      await categoriaService.create(categoria);
      var content = await categoriasFile.readAsString();
      expect(jsonDecode(content).length, 1);

      await categoriaService.delete(categoria.idCategoria!);
      content = await categoriasFile.readAsString();
      expect(jsonDecode(content), isEmpty);
    });
  });
}